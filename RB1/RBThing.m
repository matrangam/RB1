#import "RBThing.h"

@implementation RBThing

@synthesize title;
@synthesize author;
@synthesize isSelf;
@synthesize created;
@synthesize createdUTC;
@synthesize thumbnail;
@synthesize domain;
@synthesize ups;
@synthesize downs;
@synthesize comments;
@synthesize name;
@synthesize url;
@synthesize uniqueId;
@synthesize subredditId;
@synthesize subreddit;
@synthesize visited;

+ (RBThing*) thingFromDictionary:(NSDictionary*)dictionary
{
    NSDictionary* thingDictionary = [dictionary objectForKey:APIKeyData];
    RBThing* thing = [[RBThing alloc] init];
    [thing setAuthor:[thingDictionary objectForKey:@"author"]];
    [thing setTitle:[thingDictionary objectForKey:@"title"]];
    [thing setIsSelf:[thingDictionary objectForKey:@"is_self"]];
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
    [thing setName:[thingDictionary objectForKey:@"name"]];
    [thing setUrl:[thingDictionary objectForKey:@"url"]];
    [thing setVisited:NO];
    
    return thing;
}

@end
