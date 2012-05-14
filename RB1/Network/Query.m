#import "Query.h"
#import "QueryManager.h"
#import <libkern/OSAtomic.h>


@interface QueryManager (Private)
- (void) _schedule:(Query*)query;
- (void) _cancel:(Query*)query;
@end


@implementation Query
@synthesize didReceiveData = _didReceiveData;
@synthesize request = _request;
@synthesize queryManager = _queryManager;
@synthesize queue = _queue;
@synthesize delegate = _delegate;

- (void) dealloc
{
    if (_queue) {
        dispatch_release(_queue), _queue = nil;
    }
}

+ (id) queryWithURL:(NSURL*)url delegate:(id)delegate startImmediately:(BOOL)startImmediately
{
    return [self queryWithRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0] queue:nil delegate:delegate startImmediately:startImmediately];
}

+ (id) queryWithRequest:(NSURLRequest*)request queue:(dispatch_queue_t)queue delegate:(id)delegate startImmediately:(BOOL)startImmediately
{
    Query* query = [[Query alloc] initWithRequest:request];
    query.queue = queue;
    query.delegate = delegate;
    if (startImmediately) {
        [query start];
    }
    return query;
}

- (id) initWithRequest:(NSURLRequest*)request
{
    NSAssert(request, @"request must not be nil.");
    if (nil != (self = [super init])) {
        _request = [request copy];
    }
    return self;
}

- (BOOL) started
{
    return _started != 0;
}

- (BOOL) cancelled
{
    return _cancelled != 0;
}

- (void) setQueryManager:(QueryManager*)queryManager
{
    NSAssert(!_started, @"");
    if (queryManager != _queryManager) {
        _queryManager = queryManager;
    }
}

- (void) setQueue:(dispatch_queue_t)queue
{
    NSAssert(!_started, @"");
    if (queue != _queue) {
        if (_queue) {
            dispatch_release(_queue);
        }
        if (queue) {
            dispatch_retain(queue);
        }
        _queue = queue;
    }
}

- (void) setDelegate:(id)delegate
{
    NSAssert(!_started, @"");
    if (delegate != _delegate) {
        _delegate = delegate;
    }
}

- (void) start
{
    NSAssert(!_finished, @"");
    if (!_finished && OSSpinLockTry(&_started) && !_cancelled) {
        [(_queryManager ? _queryManager : [QueryManager sharedQueryManager]) _schedule:self];
    }
}

- (void) cancel
{
    if (OSSpinLockTry(&_cancelled) && !_finished && _started) {
        [(_queryManager ? _queryManager : [QueryManager sharedQueryManager]) _cancel:self];
    }
}

- (void) _finish
{
    OSSpinLockTry(&_finished);
}

- (void) setDidReceiveData:(BOOL)didReceiveData
{
    if (_didReceiveData != didReceiveData) {
        _didReceiveData = didReceiveData;
    }
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<Query %@>", [_request URL]];
}

@end
