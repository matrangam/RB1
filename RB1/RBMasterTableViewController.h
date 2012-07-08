#import "RBAuthenticationViewController.h"

@class RBMasterTableViewController, RBSubReddit;

@protocol RBMasterTableViewControllerDelegate  <NSObject>

- (void) masterTableViewController:(RBMasterTableViewController*)tableViewController didSelectSubreddit:(RBSubReddit*)subreddit;

@end

@interface RBMasterTableViewController : UITableViewController

@property (unsafe_unretained, nonatomic) id delegate;
@property (strong, nonatomic) NSArray* subReddits;

@end
