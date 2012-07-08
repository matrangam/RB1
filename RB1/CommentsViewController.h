@class CommentsViewController;

@protocol CommentsViewControllerDelegate <NSObject>

- (void) commentsViewControllerShouldDismiss:(CommentsViewController*)viewController;

@end

@interface CommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id <CommentsViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray* comments;
@property (strong, nonatomic) Thing* thing;
@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
@property (strong, nonatomic) IBOutlet UITableViewCell *commentCell;
@property (strong, nonatomic) IBOutlet UIWebView *commentBodyView;

- (IBAction)backButtonPressed:(id)sender;

@end
