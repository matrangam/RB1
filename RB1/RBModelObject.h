@interface RBModelObject : NSObject

- (id) cleanedValue:(id)value forPropertyName:(NSString*)propertyName ofClass:(Class)classToCheck;

@end
