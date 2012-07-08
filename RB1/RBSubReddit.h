extern NSString* const SubRedditCreated;
extern NSString* const SubRedditCreatedUTC;
extern NSString* const SubRedditDescription;
extern NSString* const SubRedditDisplayName;
extern NSString* const SubRedditHeaderImageUrl;
extern NSString* const SubRedditHeaderTitle;
extern NSString* const SubRedditUniqueId;
extern NSString* const SubRedditOver18;
extern NSString* const SubRedditSubscribers;
extern NSString* const SubRedditTitle;
extern NSString* const SubRedditUrl;

@interface RBSubReddit : NSObject

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
@property (nonatomic, assign) NSInteger headerHeight;
@property (nonatomic, assign) NSInteger headerWidth;

+ (RBSubReddit*) subRedditFromDictionary:(NSDictionary*)dictionary;

@end
