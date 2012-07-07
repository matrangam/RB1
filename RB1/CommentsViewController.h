@class CommentsViewController;

@protocol CommentsViewControllerDelegate <NSObject>

- (void) commentsViewControllerShouldDismiss:(CommentsViewController*)viewController;

@end

@interface CommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id <CommentsViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray* comments;
@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
- (IBAction)backButtonPressed:(id)sender;

@end
