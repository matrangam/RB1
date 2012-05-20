@interface Thing : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSNumber* created;
@property (nonatomic, strong) NSNumber* createdUTC;
@property (nonatomic, strong) NSString* thumbnail;
@property (nonatomic, strong) NSString* domain;

@property (nonatomic, strong) NSNumber* ups;
@property (nonatomic, strong) NSNumber* downs;
@property (nonatomic, strong) NSString* uniqueId;
@property (nonatomic, strong) NSString* subredditId;

+ (Thing*) thingFromDictionary:(NSDictionary*)dictionary;

@end
