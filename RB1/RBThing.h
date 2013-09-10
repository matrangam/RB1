@interface RBThing : NSObject

@property (nonatomic, strong) NSString* approved_by;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* author_flair_css_class;
@property (nonatomic, strong) NSString* author_flair_text;
@property (nonatomic, strong) NSString* banned_by;
@property (nonatomic, strong) NSString* clicked;
@property (nonatomic, strong) NSNumber* created;
@property (nonatomic, strong) NSNumber* created_utc;
@property (nonatomic, strong) NSString* distinguished;
@property (nonatomic, strong) NSString* domain;
@property (nonatomic, strong) NSNumber* downs;
@property (nonatomic, strong) NSNumber* edited;
@property (nonatomic) BOOL hidden;
@property (nonatomic, strong) NSString* uniqueId;
@property (nonatomic, strong) NSNumber* is_self;
@property (nonatomic, strong) NSString* likes;
@property (nonatomic, strong) NSString* link_flair_css_class;
@property (nonatomic, strong) NSString* link_flair_text;
@property (nonatomic, strong) NSString* media;
@property (nonatomic, strong) NSDictionary* media_embed;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* num_comments;
@property (nonatomic, strong) NSString* num_reports;
@property (nonatomic) BOOL over_18;
@property (nonatomic, strong) NSString* permalink;
@property (nonatomic) BOOL saved;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSString* secure_media;
@property (nonatomic, strong) NSString* secure_media_embed;
@property (nonatomic, strong) NSString* selftext;
@property (nonatomic, strong) NSString* selftext_html;
@property (nonatomic) BOOL stickied;
@property (nonatomic, strong) NSString* subreddit;
@property (nonatomic, strong) NSString* subreddit_id;
@property (nonatomic, strong) NSString* thumbnail;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSNumber* ups;
@property (nonatomic, strong) NSString* url;

@property (nonatomic, getter = hasBeenVisited) BOOL visited;

@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic, strong) NSString* kind;

- (RBThing*) thingFromDictionary:(NSDictionary*)dictionary;

@end
