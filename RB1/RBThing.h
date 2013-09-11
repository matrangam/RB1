#import "RBModelObject.h"

@interface RBThing : RBModelObject

@property (nonatomic, strong) NSString* approvedBy;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* authorFlairCssClass;
@property (nonatomic, strong) NSString* authorFlairText;
@property (nonatomic, strong) NSString* bannedBy;
@property (nonatomic, strong) NSNumber* clicked;
@property (nonatomic, strong) NSNumber* created;
@property (nonatomic, strong) NSNumber* createdUTC;
@property (nonatomic, strong) NSString* distinguished;
@property (nonatomic, strong) NSString* domain;
@property (nonatomic, strong) NSNumber* downs;
@property (nonatomic, strong) NSNumber* edited;
@property (nonatomic, strong) NSNumber* hidden;
@property (nonatomic, strong) NSString* uniqueId;
@property (nonatomic, strong) NSNumber* isSelf;
@property (nonatomic, strong) NSString* likes;
@property (nonatomic, strong) NSString* linkFlairCssClass;
@property (nonatomic, strong) NSString* linkFlairText;
@property (nonatomic, strong) NSDictionary* media;
@property (nonatomic, strong) NSDictionary* mediaEmbed;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* numberOfComments;
@property (nonatomic, strong) NSString* numberOfReports;
@property (nonatomic, strong) NSNumber* over18;
@property (nonatomic, strong) NSString* permalink;
@property (nonatomic, strong) NSNumber* saved;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSDictionary* secureMedia;
@property (nonatomic, strong) NSDictionary* secureMediaEmbed;
@property (nonatomic, strong) NSString* selftext;
@property (nonatomic, strong) NSString* selftextHTML;
@property (nonatomic, strong) NSNumber* stickied;
@property (nonatomic, strong) NSString* subreddit;
@property (nonatomic, strong) NSString* subredditId;
@property (nonatomic, strong) NSString* thumbnail;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSNumber* ups;
@property (nonatomic, strong) NSString* url;

@property (nonatomic, getter = hasBeenVisited) BOOL visited;

@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic, strong) NSString* kind;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
