#import "SubReddit.h"

@implementation SubReddit

NSString* const SubRedditCreated = @"created";
NSString* const SubRedditCreatedUTC = @"created_utc";
NSString* const SubRedditDescription = @"description";
NSString* const SubRedditDisplayName = @"display_name";
NSString* const SubRedditHeaderImageUrl = @"header_img";
NSString* const SubRedditHeaderTitle = @"header_title";
NSString* const SubRedditUniqueId = @"id";
NSString* const SubRedditOver18 = @"over18";
NSString* const SubRedditSubscribers = @"subscribers";
NSString* const SubRedditTitle = @"title";
NSString* const SubRedditUrl = @"url";

@synthesize displayName;
@synthesize title;
@synthesize url;
@synthesize headerImageUrl;
@synthesize headerTitle;
@synthesize created;
@synthesize createdUTC;
@synthesize over18;
@synthesize subscribers;
@synthesize uniqueId;
@synthesize subRedditDescription;

+ (SubReddit*) subRedditFromDictionary:(NSDictionary*)dictionary
{
    SubReddit* subReddit = [[SubReddit alloc] init];
    NSDictionary* subRedditDictionary = [dictionary objectForKey:APIKeyData];
    [subReddit setCreated:[subRedditDictionary objectForKey:SubRedditCreated]];
    [subReddit setCreatedUTC:[subRedditDictionary objectForKey:SubRedditCreatedUTC]];
    [subReddit setSubRedditDescription:[subRedditDictionary objectForKey:SubRedditDescription]];
    [subReddit setDisplayName:[subRedditDictionary objectForKey:SubRedditDisplayName]];
    [subReddit setHeaderImageUrl:[subRedditDictionary objectForKey:SubRedditHeaderImageUrl]];
    [subReddit setHeaderTitle:[subRedditDictionary objectForKey:SubRedditHeaderTitle]];
    [subReddit setUniqueId:[subRedditDictionary objectForKey:SubRedditUniqueId]];
    [subReddit setOver18:[subRedditDictionary objectForKey:SubRedditOver18]];
    [subReddit setSubscribers:[subRedditDictionary objectForKey:SubRedditSubscribers]];
    [subReddit setUrl:[subRedditDictionary objectForKey:SubRedditUrl]];
    [subReddit setTitle:[subRedditDictionary objectForKey:SubRedditTitle]];
    
    return subReddit;
}

// XXX: We also get header size, not sure if we'll need this so I'm leaving it out

@end
