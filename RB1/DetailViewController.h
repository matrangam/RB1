#import "MasterTableViewController.h"
#import "WebViewController.h"
#import "DetailViewTableCell.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, MasterTableViewControllerDelegate, UIPopoverControllerDelegate, AuthenticationViewControllerDelegate, WebViewControllerDelegate, DetailViewTableCellDelegate> 
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
