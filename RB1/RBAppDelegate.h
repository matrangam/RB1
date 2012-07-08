@class RBDetailViewController, RBMasterTableViewController;

@interface RBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UISplitViewController* splitViewController;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) RBDataProvider* dataProvider;
@property (strong, nonatomic) RBDetailViewController* detailViewController;
@property (strong, nonatomic) RBMasterTableViewController* masterViewController;

+ (RBAppDelegate*) sharedAppDelegate;

@end
