#import "RBModelObject.h"

@interface RBComment : RBModelObject

@property (nonatomic, strong) NSString* approvedBy;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* authorFlairCssClass;
@property (nonatomic, strong) NSString* authorFlairText;
@property (nonatomic, strong) NSString* bannedBy;
@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSString* bodyHTML;
@property (nonatomic, strong) NSArray* children;
@property (nonatomic, strong) NSNumber* created;
@property (nonatomic, strong) NSNumber* createdUTC;
@property (nonatomic, strong) NSString* distinguished;
@property (nonatomic, strong) NSNumber* downs;
@property (nonatomic, strong) NSNumber* edited;
@property (nonatomic, strong) NSNumber* gilded;
@property (nonatomic, strong) NSString* uniqueId;
@property (nonatomic, strong) NSString* likes;
@property (nonatomic, strong) NSString* linkId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* numReports;
@property (nonatomic, strong) NSString* parentId;
@property (nonatomic, strong) NSDictionary* replies;
@property (nonatomic, strong) NSString* scoreHidden;
@property (nonatomic, strong) NSString* subreddit;
@property (nonatomic, strong) NSString* subredditId;
@property (nonatomic, strong) NSNumber* ups;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
