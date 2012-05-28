#import "Thing.h"

@implementation Thing

@synthesize title;
@synthesize author;
@synthesize created;
@synthesize createdUTC;
@synthesize thumbnail;
@synthesize domain;
@synthesize ups;
@synthesize downs;
@synthesize comments;
@synthesize uniqueId;
@synthesize subredditId;
@synthesize subreddit;

+ (Thing*) thingFromDictionary:(NSDictionary*)dictionary
{
    NSDictionary* thingDictionary = [dictionary objectForKey:APIKeyData];
    Thing* thing = [[Thing alloc] init];
    [thing setAuthor:[thingDictionary objectForKey:@"author"]];
    [thing setTitle:[thingDictionary objectForKey:@"title"]];
    [thing setCreated:[thingDictionary objectForKey:@"created"]];
    [thing setCreatedUTC:[thingDictionary objectForKey:@"created_utc"]];
    [thing setThumbnail:[thingDictionary objectForKey:@"thumbnail"]];
    [thing setDomain:[thingDictionary objectForKey:@"domain"]];
    [thing setUps:[thingDictionary objectForKey:@"ups"]];
    [thing setDowns:[thingDictionary objectForKey:@"downs"]];
    [thing setComments:[thingDictionary objectForKey:@"num_comments"]];
    [thing setUniqueId:[thingDictionary objectForKey:@"id"]];
    [thing setSubredditId:[thingDictionary objectForKey:@"subreddit_id"]];
    [thing setSubreddit:[thingDictionary objectForKey:@"subreddit"]];
    
    return thing;
}

@end
