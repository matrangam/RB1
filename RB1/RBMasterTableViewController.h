#import "RBAuthenticationViewController.h"

@class RBMasterTableViewController, SubReddit;

@protocol MasterTableViewControllerDelegate  <NSObject>

- (void) masterTableViewController:(RBMasterTableViewController*)tableViewController didSelectSubreddit:(SubReddit*)subreddit;

@end

@interface RBMasterTableViewController : UITableViewController

@property (unsafe_unretained, nonatomic) id delegate;
@property (strong, nonatomic) NSArray* subReddits;

@end
