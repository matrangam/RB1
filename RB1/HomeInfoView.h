@interface HomeInfoView : UIView <UITableViewDataSource, UITableViewDelegate> {
    UITableView* _infoTable;
}

@property (nonatomic, strong) SubReddit* selectedSubReddit;

@end
