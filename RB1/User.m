#import "User.h"

@implementation User

@synthesize username = _username;
@synthesize password = _password;
@synthesize cookie = _cookie;
@synthesize modhash = _modhash;
@synthesize redditSession = _redditSession;

- (id) init
{
    if (nil != (self = [super init])) {
        _username = @"trangatrang";
        _password = @"";
    }
    return self;
}

- (void) setCookie:(NSString *)cookie
{
    if (_cookie != cookie) {
        _cookie = cookie;
        NSArray *items = [cookie componentsSeparatedByString:@","];
        _redditSession = [items lastObject];
    }
}

@end
