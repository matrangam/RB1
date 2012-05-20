@class HomeInfoView, HomeViewController;

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView* _selectionListTable;
    IBOutlet HomeInfoView* _homeInfoView;
}


@end
