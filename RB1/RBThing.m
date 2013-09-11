#import "RBThing.h"

@implementation RBThing

+ (NSDictionary*) apiKeyToPropertyNameMap
{
    static NSDictionary* map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
                @"approved_by": @"approvedBy",
                @"author": @"author",
                @"author_flair_css_class": @"authorFlairCssClass",
                @"author_flair_text": @"authorFlairText",
                @"banned_by": @"bannedBy",
                @"clicked": @"clicked",
                @"created": @"created",
                @"created_utc": @"createdUTC",
                @"distinguished": @"distinguished",
                @"domain": @"domain",
                @"downs": @"downs",
                @"edited": @"edited",
                @"hidden": @"hidden",
                @"id": @"uniqueId",
                @"is_self": @"isSelf",
                @"likes": @"likes",
                @"link_flair_css_class": @"linkFlairCssClass",
                @"link_flair_text": @"linkFlairText",
                @"media": @"media",
                @"media_embed": @"mediaEmbed",
                @"name": @"name",
                @"num_comments": @"numberOfComments",
                @"num_reports": @"numberOfReports",
                @"over_18": @"over18",
                @"permalink": @"permalink",
                @"saved": @"saved",
                @"score": @"score",
                @"secure_media": @"secureMedia",
                @"secure_media_embed": @"secureMediaEmbed",
                @"selftext": @"selftext",
                @"selftext_html": @"selftextHTML",
                @"stickied": @"stickied",
                @"subreddit": @"subreddit",
                @"subreddit_id": @"subredditId",
                @"thumbnail": @"thumbnail",
                @"title": @"title",
                @"ups": @"ups",
                @"url": @"url"};
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
            NSString* actualKey = [[RBThing apiKeyToPropertyNameMap] valueForKey:key];
            if (actualKey) {
                [self setValue:[self.data valueForKey:key] forKey:actualKey];
            };
        }
    }
    return self;
}

- (void) setValue:(id)value forKey:(NSString*)key
{
    id cleanedValue = [self cleanedValue:value forPropertyName:key ofClass:[self class]];
    if (cleanedValue) {
        [super setValue:cleanedValue forKey:key];
    }
}

- (void) setValue:(id)value forUndefinedKey:(NSString*)key
{
    NSLog(@"WARNING: Setting value: %@ for undefined key: %@", value, key);
}

@end
