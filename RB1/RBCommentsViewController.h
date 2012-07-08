@class RBCommentsViewController;

@protocol RBCommentsViewControllerDelegate <NSObject>

- (void) commentsViewControllerShouldDismiss:(RBCommentsViewController*)viewController;

@end

@interface RBCommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id <RBCommentsViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray* comments;
@property (strong, nonatomic) RBThing* thing;
@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
@property (strong, nonatomic) IBOutlet UITableViewCell *commentCell;
@property (strong, nonatomic) IBOutlet UIWebView *commentBodyView;

- (IBAction)backButtonPressed:(id)sender;

@end
