#import "MasterTableViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, MasterTableViewControllerDelegate, UIPopoverControllerDelegate, AuthenticationViewControllerDelegate> 
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
