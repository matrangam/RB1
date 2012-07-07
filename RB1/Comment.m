#import "Comment.h"

@implementation Comment

@synthesize author;
@synthesize body;
@synthesize bodyHTML;
@synthesize linkId;
@synthesize parentId;
@synthesize subreddit;
@synthesize subredditId;

+ (Comment*) commentFromDictionary:(NSDictionary*)dictionary
{
    NSDictionary* commentDictionary = [dictionary objectForKey:APIKeyData];
    Comment* newComment = [[Comment alloc] init];
    [newComment setAuthor:[commentDictionary objectForKey:@"author"]];
    [newComment setBody:[commentDictionary objectForKey:@"body"]];
    [newComment setBodyHTML:[commentDictionary objectForKey:@"body_html"]];
    [newComment setLinkId:[commentDictionary objectForKey:@"link_id"]];
    [newComment setParentId:[commentDictionary objectForKey:@"parent_id"]];
    [newComment setSubreddit:[commentDictionary objectForKey:@"subreddit"]];
    [newComment setSubredditId:[commentDictionary objectForKey:@"subreddit_id"]];
    
    return newComment;
}

//String	author	the account name of the poster
//String	author_flair_css_class	the css class of the author's flair. subreddit specific
//String	author_flair_text	the text of the author's flair. subreddit specific
//String	body	the raw text. this is the unformatted text which includes the raw markup characters such as ** for bold.
//String	body_html	the formatted html text. this is the html formatted version of the marked up text. Items that are boldened by ** or *** will now have <em> or *** tags on them. Additionally, bullets and numbered lists will now be in html list format. NOTE: The html string will be escaped. You must unescape to get the raw html.
//String	link_id	
//String	parent_id	
//String	subreddit	subreddit of thing excluding the /r/ prefix. "pics"
//String	subreddit_id
@end


