#import "RBSubReddit.h"

@implementation RBSubReddit

- (RBSubReddit*) subRedditWithDictionary:(NSDictionary*)dictionary
{
    RBSubReddit* subReddit = [[RBSubReddit alloc] init];

    for (id key in dictionary.allKeys) {
        [subReddit setValue:[dictionary valueForKey:key] forKey:key];
    }
    
    for (id key in subReddit.data) {
        [subReddit setValue:[subReddit.data valueForKey:key] forKey:key];
    }
    return subReddit;
}

- (void) setValue:(id)value forUndefinedKey:(NSString*)key
{
    if ([key isEqualToString:@"id"]) {
        [self setUniqueId:value];
    } else {
        NSLog(@"WARNING: Setting value: %@ for undefined key: %@", value, key);
    }
}

@end
