#import "DataProvider.h"

@implementation DataProvider {
    NSMutableData* _data;
}

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

-(void) authenticateUser:(User*)user withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError *))failedWithError
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.reddit.com/api/login"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];

    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:user.username, @"user", user.password, @"passwd", @"json", @"api_type", nil];
    if ([parameters count] > 0) {
        NSString* body = [self queryStringFormDictionary:parameters];
        NSLog(@"Request Body: %@", body);
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }

    Query* query = [Query queryWithRequest:request queue:nil delegate:self startImmediately:YES];
    [query start];
}

- (void)query:(Query *)query didReceiveData:(NSData *)data
{
    NSLog(@"%@", data);
    if (!_data) {
        _data = [[NSMutableData alloc] init];
    }
    [_data appendData:data];
}

- (void)query:(Query *)query didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

- (void)query:(Query *)query didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void) queryDidFinishLoading:(Query *)query
{
    NSString* jsonString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSString* result = [NSString stringWithObjectAsJSON:jsonString];
    NSLog(@"%@", result);
}

@end
