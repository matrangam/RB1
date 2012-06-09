extern NSString* kHomeInfoViewTableCellReuseIdentifier;
extern CGFloat kHomeInfoViewTableCellHeight;

@interface HomeInfoViewTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentsButton;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

@end
