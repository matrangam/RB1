#import "RBModelObject.h"

@interface RBSubReddit : RBModelObject

@property (nonatomic, strong) NSString* accountsActive;
@property (nonatomic, strong) NSNumber* commentScoreHideMins;
@property (nonatomic, strong) NSNumber* created;
@property (nonatomic, strong) NSNumber* createdUTC;
@property (nonatomic, strong) NSString* descriptionRaw;
@property (nonatomic, strong) NSString* descriptionHTML;
@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* headerImage;
@property (nonatomic, strong) NSArray* headerSize;
@property (nonatomic, strong) NSString* headerTitle;
@property (nonatomic, strong) NSString* uniqueId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* over18;
@property (nonatomic, strong) NSString* publicDescription;
@property (nonatomic, strong) NSNumber* publicTraffic;
@property (nonatomic, strong) NSString* submissionType;
@property (nonatomic, strong) NSString* submit_link_label;
@property (nonatomic, strong) NSString* submit_text_label;
@property (nonatomic, strong) NSString* subreddit_type;
@property (nonatomic, strong) NSNumber* subscribers;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSNumber* userIsBanned;
@property (nonatomic, strong) NSNumber* userIsContributor;
@property (nonatomic, strong) NSNumber* userIsModerator;
@property (nonatomic, strong) NSNumber* userIsSubscriber;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
