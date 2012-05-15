#import "DataProvider.h"

@implementation DataProvider {
    NSURLResponse* _response;
    NSMutableData* _responseData;
}

static NSString* endpoint = @"http://www.reddit.com/api/";

@synthesize didComplete = _didComplete;
@synthesize didFailWithError = _didFailWithError;

- (NSString*) queryStringFormDictionary:(NSDictionary*)dictionary  
{
    if ([dictionary count] == 0) {
        return nil;
    }
    
    NSMutableString *string = [NSMutableString string];
    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        id object = [dictionary objectForKey:key];
        if ([object isKindOfClass:[NSString class]]) {
            object = object;
        }
        else if ([object respondsToSelector:@selector(stringValue)]) {
            object = [object stringValue];
        }
        else {
            [[NSException exceptionWithName:NSGenericException reason:@"Bad request object" userInfo:nil] raise];
        }
        [string appendFormat:@"%@=%@", key, [[object description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([keys lastObject] != key) {
            [string appendString:@"&"];
        }
    }
    return string;
}

- (Query*) queryWithRequest:(NSURLRequest*)request completionBlock:(void(^)(id))completionBlock onFailedWithError:(void(^)(NSError* error))failedWithError
{
    NSAssert(nil != completionBlock, @"???");
    
    dispatch_queue_t queue = dispatch_get_current_queue();
    dispatch_retain(queue);
    void (^completionBlock_)(id) = [completionBlock copy];
    void (^failedWithError_)(id) = [failedWithError copy];
    
    Query* query = [Query queryWithRequest:request queue:nil delegate:self startImmediately:YES];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    dispatch_after(popTime, queue, ^(void){
        if (!query.didReceiveData) {
            [query cancel];
            dispatch_async(queue, ^{
                NSString* errorMessage = @"The connect has Timed Out";
                failedWithError_([NSError errorWithDomain:@"" code:0 userInfo:[NSDictionary dictionaryWithObject:errorMessage forKey:@"errorMessage"]]);
            });
            dispatch_release(queue);
        } 
    });
    
    self.didComplete = ^(NSURLResponse* response, id object) {
        dispatch_async(queue, ^{
            NSDictionary* jsonDict = [object objectForKey:@"json"];
            completionBlock_(jsonDict);
        }) ;
        dispatch_release(queue);
    };
    
    return query;
}

- (Query*) queryForPosttingToURI:(NSString*)uri withParameters:(NSDictionary*)parameters completionBlock:(void(^)(id))completionBlock onFailedWithError:(void(^)(NSError* error))failedWithError
{
    NSAssert(nil != completionBlock, @"???");
    
    NSString* urlString = [endpoint stringByAppendingString:uri];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    if ([parameters count] > 0) {
        NSString* body = [self queryStringFormDictionary:parameters];
        NSLog(@"Request Body: %@", body);
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return [self queryWithRequest:request completionBlock:completionBlock onFailedWithError:failedWithError];
}

- (void) authenticateUser:(User*)user withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError *))failedWithError
{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:user.username, QueryStringUsername, user.password, QueryStringPassword, @"json", QueryStringAPIType, nil];
    [self queryForPosttingToURI:[NSString stringWithFormat:LoginPathFormat, user.username] withParameters:parameters 
                completionBlock:^(id response) {
                    
                    NSLog(@"%@", response);
                } 
                onFailedWithError:^(NSError *error) {
                    //
                }
    ];
}   

- (void)query:(Query *)query didReceiveData:(NSData *)data
{
    if (!_responseData) {
        _responseData = [[NSMutableData alloc] init];
    }
    [_responseData appendData:data];
}

- (void)query:(Query *)query didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    _responseData = [[NSMutableData alloc] init];
}

- (void)query:(Query *)query didFailWithError:(NSError *)error
{
    _didFailWithError(error);
}

- (void) queryDidFinishLoading:(Query *)query
{
    NSString* jsonString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSString* response = [NSString stringWithObjectAsJSON:jsonString];
    NSLog(@"%@", response);

    if (_didComplete) {
        _didComplete(_response, [NSObject objectWithJSON:jsonString]);
    }
    
    _response = nil;
    _responseData = nil;
}

@end
