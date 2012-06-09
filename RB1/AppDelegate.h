@class DetailViewController, MasterTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DataProvider* dataProvider;
@property (strong, nonatomic) DetailViewController* detailViewController;
@property (strong, nonatomic) MasterTableViewController* masterViewController;

+ (AppDelegate*) sharedAppDelegate;

@end
