#import "User.h"

@implementation User

@synthesize username = _username;
@synthesize password = _password;
@synthesize cookie = _cookie;
@synthesize modhash = _modhash;

- (id) init
{
    if (nil != (self = [super init])) {
        _username = @"trangatrang";
        _password = @"ldeffort";
    }
    return self;
}

@end
