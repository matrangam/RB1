@class HomeInfoViewController, MasterTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DataProvider* dataProvider;
@property (strong, nonatomic) HomeInfoViewController* detailViewController;
@property (strong, nonatomic) MasterTableViewController* masterViewController;

+ (AppDelegate*) sharedAppDelegate;

@end
