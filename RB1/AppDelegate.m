#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize dataProvider = _dataProvider;

+ (AppDelegate*) sharedAppDelegate
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate;
}

- (DataProvider*) dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[DataProvider alloc] init];
    }
    return _dataProvider;
}

@end
