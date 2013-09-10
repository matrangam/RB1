#import "RBThing.h"

@implementation RBThing

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    if (nil != (self = [super init])) {
        for (id key in dictionary.allKeys) {
            [self setValue:[dictionary valueForKey:key] forKey:key];
        }
        
        for (id key in self.data) {
            [self setValue:[self.data valueForKey:key] forKey:key];
        }
    }
    return self;
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
