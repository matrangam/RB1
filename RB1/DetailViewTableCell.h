extern NSString* kDetailViewTableCellReuseIdentifier;
extern CGFloat kDetailViewTableCellHeight;

@interface DetailViewTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentsButton;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

@end
