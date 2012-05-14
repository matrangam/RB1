#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DataProvider* dataProvider;

+ (AppDelegate*) sharedAppDelegate;

@end
