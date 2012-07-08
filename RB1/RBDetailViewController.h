#import "RBMasterTableViewController.h"
#import "WebViewController.h"
#import "RBDetailViewTableCell.h"
#import "CommentsViewController.h"

@interface RBDetailViewController : UIViewController <UISplitViewControllerDelegate, 
                                                    UIPopoverControllerDelegate, 
                                                    MasterTableViewControllerDelegate, 
                                                    AuthenticationViewControllerDelegate, 
                                                    WebViewControllerDelegate, 
                                                    DetailViewTableCellDelegate, 
                                                    CommentsViewControllerDelegate> 
{
    @private
    UIPopoverController* _masterPopoverController;
}
@property (strong, nonatomic) IBOutlet UITableView* infoTable;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *toolbarTitle;
@property (strong, nonatomic) SubReddit* selectedSubReddit;
@end
