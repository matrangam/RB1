#import "QueryManager.h"
#import "Query.h"


NSString* const kQueryStartNotification      = @"kQueryDidStartNotification";
NSString* const kQueryCompleteNotification   = @"kQueryDidCompleteNotification";

@interface Query (Private)
@property (nonatomic) BOOL didReceiveData;
- (void) _finish;
@end

@interface QueryManagerURLConnection : NSObject <NSURLConnectionDelegate>{
    QueryManager* _queryManager;
    Query* _query;
    dispatch_queue_t _queue;
    id _delegate;
    int _retryCount;
    BOOL _receivedResponse;
    NSURLConnection* _connection;
}
@property (nonatomic, strong) Query* query;
@property (nonatomic, strong) NSURLConnection* connection;
- (id) initWithQueryManager:(QueryManager*)queryManager query:(Query*)query retryCount:(int)retryCount;
@end
#pragma mark -


@implementation QueryManager

+ (QueryManager*) sharedQueryManager
{
    static QueryManager* instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[QueryManager alloc] init];
    });
    return instance;
}

- (void) dealloc
{
    [[NSThread class] performSelector:@selector(exit) onThread:_thread withObject:nil waitUntilDone:YES];
}

- (id) init
{
    if (nil != (self = [super init])) {
        _maxConcurrent = 5;
        _retryCount = 3;
        _backlog = [[NSMutableArray alloc] init];
        _active = [[NSMutableArray alloc] init];
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(_runLoop) object:nil];
        [_thread setThreadPriority:0.0];
        [_thread setName:NSStringFromClass([self class])];
        [_thread start];
    }
    return self;
}

- (void) _tick:(NSTimer*)timer
{
    // Do nothing.
}

- (void) _runLoop
{
    NSAssert([NSThread currentThread] == _thread, @"");
    @autoreleasepool {
        NSRunLoop* currentRunLoop = [NSRunLoop currentRunLoop];
        NSTimer* timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(_tick:) userInfo:nil repeats:YES];
        [currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
        while (![_thread isCancelled]) {
            @autoreleasepool {
                @try {
                    [currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
                } @catch (id exception) {
                    NSLog(@"%@", exception);
                }
            }
        }
        [timer invalidate];
    }
}

- (void) _cancelAll
{
    NSAssert([NSThread currentThread] == _thread, @"");
    for (QueryManagerURLConnection* delegate in [_active copy]) {
        [[delegate query] cancel];
    }
    for (QueryManagerURLConnection* delegate in [_backlog copy]) {
        [[delegate query] cancel];
    }
}

- (void) _runNextInBacklog
{
    NSAssert([NSThread currentThread] == _thread, @"");
    NSInteger count;
    if (0 == (count = [_backlog count]) || [_active count] >= _maxConcurrent) {
        return;
    }
    do {
        Query* query = [_backlog lastObject];
        if (query.cancelled) {
            [_backlog removeLastObject];
        } else {
            QueryManagerURLConnection* delegate = [[QueryManagerURLConnection alloc] initWithQueryManager:self query:query retryCount:_retryCount];
            [_active addObject:delegate];
            [[NSNotificationCenter defaultCenter] postNotificationName:kQueryStartNotification object:query];
            [_backlog removeLastObject];
            break;
        }
    } while (--count);
}

- (void) _removeQueryFromActiveSet:(Query*)query  
{
    NSAssert([NSThread currentThread] == _thread, @"");
    for (NSInteger i = [_active count] - 1; i >= 0; i--) {
        QueryManagerURLConnection* delegate = [_active objectAtIndex:i];
        if (delegate.query == query) {
            [delegate setQuery:nil];
            [delegate.connection cancel];
            [_active removeObjectAtIndex:i];
            [[NSNotificationCenter defaultCenter] postNotificationName:kQueryCompleteNotification object:query];
            delegate.query = nil;
            break;
        }
    }
}

- (void) _runNextInBacklogAfterRemovingQueryFromActiveSet:(Query*)query
{
    NSAssert([NSThread currentThread] == _thread, @"");
    [self _removeQueryFromActiveSet:query];
    [self _runNextInBacklog];
}

- (void) _schedule:(Query*)query
{
    if ([NSThread currentThread] != _thread) {
        [self performSelector:@selector(_schedule:) onThread:_thread withObject:query waitUntilDone:NO];
    } else {
        [_backlog addObject:query];
        [self _runNextInBacklog];
    }
}

- (void) _cancel:(Query*)query
{
    if ([NSThread currentThread] != _thread) {
        [self performSelector:@selector(_cancel:) onThread:_thread withObject:query waitUntilDone:NO];
    } else {
        NSInteger indexOf = [_backlog indexOfObject:query];
        if (NSNotFound != indexOf) {
            [_backlog removeObjectAtIndex:indexOf];
        } else {
            [self _runNextInBacklogAfterRemovingQueryFromActiveSet:query];
        }
    }
}

- (void) cancelAll
{
    [self performSelector:@selector(_cancelAll) onThread:_thread withObject:nil waitUntilDone:NO];
}

@synthesize maxConcurrent = _maxConcurrent;
@synthesize retryCount = _retryCount;
@end
#pragma mark -


@implementation QueryManagerURLConnection

- (void) dealloc
{
    dispatch_release(_queue), _queue = nil;
}

- (id) initWithQueryManager:(QueryManager*)queryManager query:(Query*)query retryCount:(int)retryCount
{
    NSAssert(query, @"");
    if (nil != (self = [super init])) {
        _queryManager = queryManager;
        _retryCount = retryCount;
        _query = query;
        _delegate = query.delegate;
        _connection = [[NSURLConnection alloc] initWithRequest:query.request delegate:self startImmediately:YES];
        if (nil == (_queue = query.queue)) {
            _queue = dispatch_queue_create([[NSString stringWithFormat:@"%@ (%p)", NSStringFromClass([_query class]), _query, nil] UTF8String], NULL);
        } else {
            dispatch_retain(_queue);
        }
    }
    return self;
}

- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    _receivedResponse = YES;
    _query.didReceiveData = YES;
    if (!_query.cancelled && [_delegate respondsToSelector:@selector(query:didReceiveResponse:)]) {
        id delegate = _delegate;
        Query* query = _query;
        dispatch_async(_queue, ^{
            if (!query.cancelled) {
                [delegate query:query didReceiveResponse:response];
            }
        });
    }
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    if (!_query.cancelled && [_delegate respondsToSelector:@selector(query:didReceiveData:)]) {
        id delegate = _delegate;
        Query* query = _query;
        query.didReceiveData = YES;
        dispatch_async(_queue, ^{
            if (!query.cancelled) {
                [delegate query:query didReceiveData:data];
            }
        });
    }
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    if (!_query.cancelled) {
        if (!_receivedResponse && _retryCount) {
            _connection = [[NSURLConnection alloc] initWithRequest:_query.request delegate:self startImmediately:YES];
            _retryCount--;
            return;
        } else if ([_delegate respondsToSelector:@selector(query:didFailWithError:)]) {
            id delegate = _delegate;
            Query* query = _query;
            dispatch_async(_queue, ^{
                if (!query.cancelled) {
                    [delegate query:query didFailWithError:error];
                }
            });
        }
    }
    
    [_queryManager _runNextInBacklogAfterRemovingQueryFromActiveSet:_query];
    [_query _finish];
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection
{
    if (!_query.cancelled && [_delegate respondsToSelector:@selector(queryDidFinishLoading:)]) {
        id delegate = _delegate;
        Query* query = _query;
        dispatch_async(_queue, ^{
            if (!query.cancelled) {
                [delegate queryDidFinishLoading:query];
            }
        });
    }

    [_queryManager _runNextInBacklogAfterRemovingQueryFromActiveSet:_query];
    [_query _finish];
}

- (NSURLRequest*) connection:(NSURLConnection*)connection willSendRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)redirectResponse 
{
    if (!_query.cancelled && [_delegate respondsToSelector:@selector(query:willSendRequest:redirectResponse:)]) {
        id delegate = _delegate;
        Query* query = _query;
        __block NSURLRequest* requestToReturn = request;
        void (^block)(void) = ^{
            requestToReturn = [delegate query:query willSendRequest:request redirectResponse:redirectResponse];
        };
        if (dispatch_get_current_queue() != _queue) {
            dispatch_sync(_queue, block); // We're looking for a result, so no ASYNC possible.
        } else {
            block();
        }
        return requestToReturn;
    } else {
        return request;
    }
}


@synthesize query = _query;
@synthesize connection = _connection;
@end
