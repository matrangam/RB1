//api constants
static NSString* const UserAgentString = @"iOS reddit browser by /u/trangatrang";
static NSString* const QueryStringPassword = @"passwd";
static NSString* const QueryStringUsername = @"user";
static NSString* const QueryStringAPIType = @"api_type";

static NSString* const APIKeyData = @"data";
static NSString* const APIKeyChildren = @"children";

static NSString* const RedditDefaultUrl = @"http://www.reddit.com";

//uri paths with formats
static NSString* const LoginPathFormat = @"/api/login/%@"; // username
static NSString* const InfoPathFormat = @"/by_id%@.json"; // thing.name
static NSString* const CommentsPathFormat = @"/comments/%@/.json"; // thing.uniqueId
//uri paths
static NSString* const AnonymousRedditsPath = @"/reddits/.json";
static NSString* const AuthenticatedRedditsPath = @"/reddits/mine/.json";