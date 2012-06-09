#import "AppDelegate.h"

@interface AppDelegate ()
- (void) _showOrHideNetworkIndicator;
@end

@implementation AppDelegate {
    id _queryObserver;
}

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

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UISplitViewController* splitViewController = (UISplitViewController*) self.window.rootViewController;
    [splitViewController setDelegate:[[splitViewController viewControllers] lastObject]];
    
    _queryObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kQueryStartNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        Query* query = [note object];
        NSLog(@"--> %@", query);
        [self _showOrHideNetworkIndicator];
    }];
    return YES;
}

- (void) _showOrHideNetworkIndicator
{
    if (![[UIApplication sharedApplication] isNetworkActivityIndicatorVisible]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] removeObserver:self], _queryObserver = nil;
}

@end
