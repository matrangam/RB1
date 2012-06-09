@class MasterTableViewController, SubReddit;

@protocol MasterTableViewControllerDelegate  <NSObject>

- (void) masterTableViewController:(MasterTableViewController*)tableViewController didSelectSubreddit:(SubReddit*)subreddit;

@end

@interface MasterTableViewController : UITableViewController

@property (unsafe_unretained, nonatomic) id <MasterTableViewControllerDelegate> delegate;

@end