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
@synthesize uniqueId;
@synthesize subredditId;

+ (Thing*) thingFromDictionary:(NSDictionary*)dictionary
{
    NSDictionary* thingDictionary = [dictionary objectForKey:@"data"];
    Thing* thing = [[Thing alloc] init];
    [thing setAuthor:[thingDictionary objectForKey:@"author"]];
    [thing setTitle:[thingDictionary objectForKey:@"title"]];
    [thing setCreated:[thingDictionary objectForKey:@"created"]];
    [thing setCreatedUTC:[thingDictionary objectForKey:@"created_utc"]];
    [thing setThumbnail:[thingDictionary objectForKey:@"thumbnail"]];
    [thing setDomain:[thingDictionary objectForKey:@"domain"]];
    [thing setUps:[thingDictionary objectForKey:@"ups"]];
    [thing setDowns:[thingDictionary objectForKey:@"downs"]];
    [thing setUniqueId:[thingDictionary objectForKey:@"id"]];
    [thing setSubredditId:[thingDictionary objectForKey:@"subreddit_id"]];
    
    return thing;
}

@end
