#import "RBComment.h"

@implementation RBComment {
    NSMutableArray* _parsedReplies;
    NSMutableArray* _parsedChildren;
}

+ (NSDictionary*) apiKeyToPropertyNameMap
{
    static NSDictionary* map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{@"approved_by": @"approvedBy",
                @"author": @"author",
                @"author_flair_css_class": @"authorFlairCssClass",
                @"author_flair_text": @"authorFlairText",
                @"banned_by": @"bannedBy",
                @"body": @"body",
                @"body_html": @"bodyHTML",
                @"children": @"children",
                @"created": @"created",
                @"created_utc": @"createdUTC",
                @"distinguished": @"distinguished",
                @"downs": @"downs",
                @"edited": @"edited",
                @"gilded": @"gilded",
                @"id": @"uniqueId",
                @"likes": @"likes",
                @"link_id": @"linkId",
                @"name": @"name",
                @"num_reports": @"numReports",
                @"parent_id": @"parentId",
                @"replies": @"replies",
                @"score_hidden": @"scoreHidden",
                @"subreddit": @"subreddit",
                @"subreddit_id": @"subredditId",
                @"ups": @"ups"};
    });
    return map;
}



- (id) initWithDictionary:(NSDictionary*)dictionary
{
    if (nil != (self = [super init])) {
        for (id key in dictionary.allKeys) {
            [self setValue:[dictionary valueForKey:key] forKey:key];
        }
        
        for (id key in self.data) {
            NSString* actualKey = [[RBComment apiKeyToPropertyNameMap] valueForKey:key];
            if (actualKey) {
                [self setValue:[self.data valueForKey:key] forKey:key];
            };
        }
    }
    return self;
}

- (void) setValue:(id)value forKey:(NSString*)key
{
    id cleanedValue = [self cleanedValue:value forPropertyName:key ofClass:[self class]];
    if (cleanedValue) {
        
        if ([key isEqualToString:@"replies"] && [cleanedValue isKindOfClass:[NSDictionary class]]) {
            _parsedReplies = [[NSMutableArray alloc] init];
            RBComment* subComment = [[RBComment alloc] initWithDictionary:value];
            [_parsedReplies addObject:subComment];
            
        } else if ([key isEqualToString:@"children"] && [cleanedValue isKindOfClass:[NSArray class]]) {
            _parsedChildren = [[NSMutableArray alloc] init];
            for (NSDictionary* child in cleanedValue) {
                if ([child isKindOfClass:[NSDictionary class]] && [[child objectForKey:@"kind"] isEqualToString:@"t1"]) {
                    RBComment* subComment = [[RBComment alloc] initWithDictionary:child];
                    [_parsedChildren addObject:subComment];
                }
            }
            [super setValue:_parsedChildren forKey:key];
        } else {
            [super setValue:cleanedValue forKey:key];
        }
    }
}

- (void) setValue:(id)value forUndefinedKey:(NSString*)key
{
    NSLog(@"WARNING: Setting value: %@ for undefined key: %@", value, key);
}
/*
    Each comment with replies has a dictionary called replies, 
    This dictionary contains a key called 'data' which contains another dictionary where the key 'children' contains an array
    Every object in the array is a dictionary where 'Data' is the key and the value is a comment
    Every comment can possibly have replies so this sequence can be arbitrarily DEEP 
 
    Comment {
    --- Replies {
 
        --- Data { 
            --- Children (
 
                --- Data {
                    --- Comment {
*/


//String	author:                 the account name of the poster
//String	author_flair_css_class:	the css class of the author's flair. subreddit specific
//String	author_flair_text:      the text of the author's flair. subreddit specific
//String	body:                   the raw text. this is the unformatted text which includes the raw markup characters such as ** for bold.
//String	body_html:              the formatted html text. this is the html formatted version of the marked up text. Items that are boldened by ** or *** will now have <em> or *** tags on them. Additionally, bullets and numbered lists will now be in html list format. NOTE: The html string will be escaped. You must unescape to get the raw html.
//String	link_id	
//String	parent_id	
//String	subreddit	subreddit of thing excluding the /r/ prefix. "pics"
//String	subreddit_id

@end


