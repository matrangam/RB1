#import "RBAppDelegate.h"
#import "RBMasterTableViewController.h"

@implementation RBAppDelegate {
    NSUInteger networkActivityCount;
    uint64_t networkActivityStarted;
    double networkActivityElapsedTimeInMilliseconds;
}

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize navController = _navController;
@synthesize dataProvider = _dataProvider;
@synthesize masterViewController = _masterViewController;
@synthesize detailViewController = _detailViewController;


+ (RBAppDelegate*) sharedAppDelegate
{
    RBAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate;
}

- (RBDataProvider*) dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[RBDataProvider alloc] init];
    }
    return _dataProvider;
}

- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    _splitViewController = (UISplitViewController*)self.window.rootViewController;
    [_splitViewController setDelegate:[[_splitViewController viewControllers] lastObject]];
       
    _detailViewController = (RBDetailViewController*)[[_splitViewController viewControllers] lastObject];
    _masterViewController = (RBMasterTableViewController*)[[[_splitViewController viewControllers] objectAtIndex:0] topViewController];
    [_masterViewController setDelegate:_detailViewController];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName:kQueryStartNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification) {
        Query* query = [notification object];
        NSString *postBody = [[NSString alloc] initWithData:[[query request] HTTPBody] encoding:NSUTF8StringEncoding];
        NSLog(@"%@", postBody);
        NSLog(@"-> %@", query);
        if (!networkActivityCount) {
            if (![[UIApplication sharedApplication] isNetworkActivityIndicatorVisible]) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            } else {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_turnOffNetworkActivityIndicator) object:nil];
            }
        }
        networkActivityCount++;
    }];
    
    [nc addObserverForName:kQueryCompleteNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification) {
        Query* query = [notification object];
        NSLog(@"<- %@", query);
        networkActivityCount--;
        if (!networkActivityCount) {
            [self performSelector:@selector(_turnOffNetworkActivityIndicator) withObject:nil afterDelay:1.0];
        }
    }];
    return YES;
}

- (void) _turnOffNetworkActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
