@interface RBComment : NSObject

@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSString* bodyHTML;
@property (nonatomic, strong) NSString* linkId;
@property (nonatomic, strong) NSString* parentId;
@property (nonatomic, strong) NSString* subreddit;
@property (nonatomic, strong) NSString* subredditId;

+ (RBComment*) commentFromDictionary:(NSDictionary*)dictionary;

@end
