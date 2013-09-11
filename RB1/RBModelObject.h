@interface RBModelObject : NSObject

@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic, strong) NSString* kind;

- (id) cleanedValue:(id)value forPropertyName:(NSString*)propertyName ofClass:(Class)classToCheck;

@end
