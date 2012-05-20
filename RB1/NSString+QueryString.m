#import "NSString+QueryString.h"

@implementation NSString (QueryString)

+ (NSString*) queryStringFormDictionary:(NSDictionary*)dictionary  
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

@end
