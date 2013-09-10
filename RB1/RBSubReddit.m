#import "RBSubReddit.h"
#import <objc/runtime.h>

@implementation RBSubReddit

+ (NSDictionary*) apiKeyToPropertyNameMap
{
    static NSDictionary* map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
                @"accounts_active": @"accountsActive",
                @"comment_score_hide_mins": @"commentScoreHideMins",
                @"created": @"created",
                @"created_utc": @"createdUTC",
                @"description": @"descriptionRaw",
                @"description_html": @"descriptionHTML",
                @"display_name": @"displayName",
                @"header_img": @"headerImage",
                @"header_size": @"headerSize",
                @"header_title": @"headerTitle",
                @"id": @"uniqueId",
                @"name": @"name",
                @"over18": @"over18",
                @"public_description": @"publicDescription",
                @"public_traffic": @"publicTraffic",
                @"submission_type": @"submissionType",
                @"subscribers": @"subscribers",
                @"title": @"title",
                @"url": @"url",
                @"user_is_banned": @"userIsBanned",
                @"user_is_contributor": @"userIsContributor",
                @"user_is_moderator": @"userIsModerator",
                @"user_is_subscriber": @"userIsSubscriber"};
    });
    return map;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    if (nil != (self = [super init])) {
        for (id key in dictionary.allKeys) {
            [self setValue:[dictionary valueForKey:key] forKey:key];
        }
        
        for (id key in self.data) {
            NSString* actualKey = [[RBSubReddit apiKeyToPropertyNameMap] valueForKey:key];
            if (actualKey) {
                [self setValue:[self.data valueForKey:key] forKey:actualKey];
            };
        }
    }
    return self;
}

- (void) setValue:(id)value forKey:(NSString*)key
{
    id cleanedValue = [self _cleanedValue:value forPropertyName:key];
    if (cleanedValue) {
        [super setValue:cleanedValue forKey:key];
    }
}

- (void) setValue:(id)value forUndefinedKey:(NSString*)key
{
    if ([key isEqualToString:@"id"]) {
        [self setUniqueId:value];
    } else {
        NSLog(@"WARNING: Setting value: %@ for undefined key: %@", value, key);
    }
}

- (id) _cleanedValue:(id)value forPropertyName:(NSString*)propertyName
{
    if (!propertyName) {
        return nil;
    }
    
    Class propertyClass = nil;
    NSString* attributes = nil;
    const char* propertyNameAsUTF8 = [propertyName UTF8String];
    Class classToCheck = [self class];
    objc_property_t property = nil;
    do {
        property = class_getProperty(classToCheck, propertyNameAsUTF8);
        if (property) {
            break;
        }
        classToCheck = [classToCheck superclass];
    } while (classToCheck);
    if (!property) {
        return nil;
    }
    
    attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
    if ([attributes hasPrefix:@"T@\"NSNumber\""]) {
        propertyClass = [NSNumber class];
    } else if ([attributes hasPrefix:@"T@\"NSString\""]) {
        propertyClass = [NSString class];
    } else if ([attributes hasPrefix:@"T@\"NSDictionary\""]) {
        propertyClass = [NSDictionary class];
    } else if ([attributes hasPrefix:@"T@\"NSArray\""]) {
        propertyClass = [NSArray class];
    } else {
        NSLog(@"WARNING: I don't know how to interpret what class property %@ is (\"%@\").", propertyName, attributes);
        return nil;
    }
    
    if (![value isKindOfClass:propertyClass]) {
        if ([value isKindOfClass:[NSString class]] && propertyClass == [NSNumber class]) {
            if ([value isEqualToString:@"null"]) {
                value = nil;
            } else {
                value = [NSNumber numberWithInt:[value intValue]];
            }
        } else if ([value isKindOfClass:[NSNull class]]) {
            value = nil;
        } else {
            NSLog(@"WARNING: I don't know how to turn a %@ into a %@, defaulting to nil.", [value class], propertyClass);
            value = nil;
        }
    } else if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    
    return value;
}
@end
