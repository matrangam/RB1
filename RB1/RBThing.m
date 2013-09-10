#import "RBThing.h"

@implementation RBThing

- (RBThing*) thingFromDictionary:(NSDictionary*)dictionary
{
    RBThing* thing = [[RBThing alloc] init];
    
    for (id key in dictionary.allKeys) {
        [thing setValue:[dictionary valueForKey:key] forKey:key];
    }
    
    for (id key in thing.data) {
        [thing setValue:[thing.data valueForKey:key] forKey:key];
    }
    return thing;
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
