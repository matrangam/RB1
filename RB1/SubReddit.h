@interface SubReddit : NSObject

@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* headerImageUrl;
@property (nonatomic, strong) NSString* headerTitle;
@property (nonatomic, strong) NSNumber* created;
@property (nonatomic, strong) NSNumber* createdUTC;
@property (nonatomic, strong) NSString* over18;
@property (nonatomic, strong) NSNumber* subscribers;
@property (nonatomic, strong) NSString* uniqueId;
@property (nonatomic, strong) NSString* subRedditDescription;

+ (SubReddit*) subRedditFromDictionary:(NSDictionary*)dictionary;

@end
