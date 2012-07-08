#import "RBDataProvider.h"
#import "NSString+QueryString.h"

@implementation RBDataProvider {
    NSURLResponse* _response;
    NSMutableData* _responseData;
}

@synthesize didComplete = _didComplete;
@synthesize didFailWithError = _didFailWithError;

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
            NSDictionary* jsonDictionary = [NSDictionary dictionary];
            __block id responseObject = object;
            if ([responseObject isKindOfClass:[NSArray class]]) {
                responseObject = [responseObject objectAtIndex:1];
            }
            if ([responseObject objectForKey:@"json"]) {
                jsonDictionary = [responseObject objectForKey:@"json"];
            }
            if ([responseObject objectForKey:APIKeyData]) {
                jsonDictionary = [responseObject objectForKey:APIKeyData];
            }
            NSArray* errors = [jsonDictionary objectForKey:@"errors"];
            if ([errors count]) {
                NSError* error = [NSError errorWithDomain:@"bad thing" code:0 userInfo:nil];
                failedWithError_(error);
                return;
            }
            completionBlock_(jsonDictionary);
        }) ;
        dispatch_release(queue);
    };
    return query;
}

#pragma Mark PostCalls

- (Query*) queryForPosttingToURI:(NSString*)uri withParameters:(NSDictionary*)parameters completionBlock:(void(^)(id))completionBlock onFailedWithError:(void(^)(NSError* error))failedWithError
{
    NSAssert(nil != completionBlock, @"???");
    
    NSString* urlString = [RedditDefaultUrl stringByAppendingString:uri];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setValue:UserAgentString forHTTPHeaderField:@"User-Agent"];    

    if ([parameters count] > 0) {
        NSString* body = [NSString queryStringFromDictionary:parameters];
        NSLog(@"Request Body: %@", body);
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return [self queryWithRequest:request completionBlock:completionBlock onFailedWithError:failedWithError];
}

#pragma Mark GetCalls

- (Query*) queryForGettingFromURI:(NSString*)uri parameters:(NSDictionary*)parameters withCompletionBlock:(void(^)(id))completionBlock onFailedWithError:(void(^)(NSError* error))failedWithError
{
    NSAssert(nil != completionBlock, @"???");
    
    NSString* urlString = [RedditDefaultUrl stringByAppendingString:uri];
    if ([parameters count] > 0) {
        NSString* q = [NSString queryStringFromDictionary:parameters];
        urlString = [urlString stringByAppendingFormat:@"?%@", q];
    }
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    [request setValue:UserAgentString forHTTPHeaderField:@"User-Agent"];    
    
    return [self queryWithRequest:request completionBlock:completionBlock onFailedWithError:failedWithError];
}

#pragma Mark Query Stuff

- (void) query:(Query*)query didReceiveData:(NSData *)data
{
    if (!_responseData) {
        _responseData = [[NSMutableData alloc] init];
    }
    [_responseData appendData:data];
}

- (void) query:(Query*)query didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    _responseData = [[NSMutableData alloc] init];
}

- (void) query:(Query*)query didFailWithError:(NSError *)error
{
    _didFailWithError(error);
}

- (void) queryDidFinishLoading:(Query*)query
{
    if (_didComplete) {
        NSString* jsonString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];        
        @try {
            _didComplete(_response, [NSObject objectWithJSON:jsonString]);
        }
        @catch (NSException *exception) {
            if (_didFailWithError) {
                _didFailWithError([NSError errorWithDomain:@"" code:0 userInfo:nil]);
            }
        }   
    }
    _response = nil;
    _responseData = nil;
}

#pragma Mark API Calls

- (void) authenticateUser:(RBUser*)user withCompletionBlock:(void(^)(RBUser*))completionBlock failBlock:(void(^)(NSError *))failedWithError
{
    NSAssert(nil != completionBlock, @"???");
    
    void (^completionBlock_)(RBUser*) = [completionBlock copy];
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:user.username, QueryStringUsername, user.password, QueryStringPassword, @"json", QueryStringAPIType, nil];

    [self queryForPosttingToURI:[NSString stringWithFormat:LoginPathFormat, user.username] withParameters:parameters 
        completionBlock:^(id response) {
            NSDictionary* responseDict = [response objectForKey:APIKeyData];
            [user setCookie:[responseDict objectForKey:@"cookie"]];
            [user setModhash:[responseDict objectForKey:@"modhash"]];
            completionBlock_(user);
        } onFailedWithError:^(NSError* error) {
            NSLog(@"%@", error);
        }
    ];
}

#pragma mark Auth Calls

- (void) redditsForAnonymousUserWithCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError
{
    void (^completionBlock_)(NSArray*) = [completionBlock copy];
    [self queryForGettingFromURI:AnonymousRedditsPath parameters:nil 
        withCompletionBlock:^(NSDictionary* response) {
            NSArray* children = [response objectForKey:APIKeyChildren];
            NSMutableArray* allSubReddits = [NSMutableArray array];
            for (NSDictionary* subRedditDictionary in children) {
                [allSubReddits addObject:[RBSubReddit subRedditFromDictionary:subRedditDictionary]];
            }
            completionBlock_(allSubReddits);
        } onFailedWithError:failedWithError
    ];
}

- (void) redditsForUser:(RBUser*)user withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError
{
    void (^completionBlock_)(NSArray*) = [completionBlock copy];
    NSDictionary* parameters = [NSDictionary dictionaryWithObject:user.redditSession forKey:@"cookie"];
    
    [self queryForGettingFromURI:AuthenticatedRedditsPath parameters:parameters
         withCompletionBlock:^(NSDictionary* response) {
             NSArray* children = [response objectForKey:APIKeyChildren];
             NSMutableArray* allSubReddits = [NSMutableArray array];
             for (NSDictionary* subRedditDictionary in children) {
                 [allSubReddits addObject:[RBSubReddit subRedditFromDictionary:subRedditDictionary]];
             }
             completionBlock_(allSubReddits);
         } onFailedWithError:failedWithError
     ];    
}

- (void) thingsForRedditNamed:(NSString*)reddit count:(NSNumber*)count lastId:(NSString*)lastId withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError
{
    void(^completionBlock_)(NSArray*) = [completionBlock copy];

    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:count forKey:@"count"];
    [params setValue:lastId forKey:@"after"];

    [self queryForGettingFromURI:[NSString stringWithFormat:@"%@%@", reddit, @".json"] parameters:params
        withCompletionBlock:^(NSDictionary* response) {
            NSArray* children = [response objectForKey:APIKeyChildren];
            NSMutableArray* allTheThings = [NSMutableArray array];
            for (NSDictionary* thing in children) {
                RBThing* newThing = [RBThing thingFromDictionary:thing];
                [allTheThings addObject:newThing];
            }
            completionBlock_(allTheThings);
        } onFailedWithError:failedWithError
    ];
}

- (void) commentsForThing:(RBThing*)thing withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError
{
    void(^completionBlock_)(NSArray*) = [completionBlock copy];
    
    [self queryForGettingFromURI:[NSString stringWithFormat:CommentsPathFormat, thing.uniqueId] parameters:nil 
         withCompletionBlock:^(NSDictionary* response) {
             NSArray* children = [response objectForKey:APIKeyChildren];
             NSMutableArray* comments = [NSMutableArray array];
             for (NSDictionary* comment in children) {
                 RBComment* newComment = [RBComment commentFromDictionary:comment];
                 [comments addObject:newComment];
             }
             completionBlock_(comments);
         } onFailedWithError:failedWithError
     ];   
}

+ (id<ImageLoader>) sharedImageLoader
{
    static id<ImageLoader> instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[CachingImageLoader alloc] initWithBackingImageLoader:[NetworkImageLoader sharedImageLoader] diskPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Icons"]]; 
    });
    return instance;
}

@end
