#import "MasterTableViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, MasterTableViewControllerDelegate> 
{
    @private
    UIPopoverController* _masterPopoverController;
}
@property (strong, nonatomic) IBOutlet UITableView* infoTable;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) SubReddit* selectedSubReddit;
@end
