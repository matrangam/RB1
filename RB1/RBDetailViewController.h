#import "RBMasterTableViewController.h"
#import "RBWebViewController.h"
#import "RBDetailViewTableCell.h"
#import "RBCommentsViewController.h"

@interface RBDetailViewController : UIViewController <UISplitViewControllerDelegate, 
                                                    UIPopoverControllerDelegate, 
                                                    RBMasterTableViewControllerDelegate, 
                                                    RBAuthenticationViewControllerDelegate, 
                                                    RBWebViewControllerDelegate, 
                                                    RBDetailViewTableCellDelegate, 
                                                    RBCommentsViewControllerDelegate> 
{
    @private
    UIPopoverController* _masterPopoverController;
}
@property (strong, nonatomic) IBOutlet UITableView* infoTable;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *toolbarTitle;
@property (strong, nonatomic) RBSubReddit* selectedSubReddit;
@end
