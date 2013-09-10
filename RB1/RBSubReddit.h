@interface RBSubReddit : NSObject

@property (nonatomic, strong) NSString* accounts_active;
@property (nonatomic, strong) NSNumber* comment_score_hide_mins;
@property (nonatomic, strong) NSNumber* created;
@property (nonatomic, strong) NSNumber* created_utc;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* description_html;
@property (nonatomic, strong) NSString* display_name;
@property (nonatomic, strong) NSString* header_img;
@property (nonatomic, strong) NSArray* header_size;
@property (nonatomic, strong) NSString* header_title;
@property (nonatomic, strong) NSString* uniqueId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) BOOL over18;
@property (nonatomic, strong) NSString* public_description;
@property (nonatomic) BOOL public_traffic;
@property (nonatomic, strong) NSString* submission_type;
@property (nonatomic, strong) NSString* submit_link_label;
@property (nonatomic, strong) NSString* submit_text_label;
@property (nonatomic, strong) NSString* subreddit_type;
@property (nonatomic, strong) NSNumber* subscribers;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* user_is_banned;
@property (nonatomic, strong) NSString* user_is_contributor;
@property (nonatomic, strong) NSString* user_is_moderator;
@property (nonatomic, strong) NSString* user_is_subscriber;

@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic, strong) NSString* kind;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
