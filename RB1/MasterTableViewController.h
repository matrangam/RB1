#import "AuthenticationViewController.h"

@class MasterTableViewController, SubReddit;

@protocol MasterTableViewControllerDelegate  <NSObject>

- (void) masterTableViewController:(MasterTableViewController*)tableViewController didSelectSubreddit:(SubReddit*)subreddit;

@end

@interface MasterTableViewController : UITableViewController <AuthenticationViewControllerDelegate>

@property (unsafe_unretained, nonatomic) id delegate;

@end
