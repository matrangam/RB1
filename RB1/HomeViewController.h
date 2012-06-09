@class HomeInfoViewController, HomeViewController;

@interface HomeViewController : UISplitViewController <UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView* _selectionListTable;
    IBOutlet HomeInfoViewController* _homeInfoView;
}


@end
