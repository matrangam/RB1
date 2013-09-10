#import "RBModelObject.h"
#import <objc/runtime.h>

@implementation RBModelObject

- (id) cleanedValue:(id)value forPropertyName:(NSString*)propertyName
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
