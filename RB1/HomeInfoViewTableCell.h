extern NSString* kHomeInfoViewTableCellReuseIdentifier;
extern CGFloat kHomeInfoViewTableCellHeight;

@interface HomeInfoViewTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

+ (HomeInfoViewTableCell*) createNewCellFromNib;

@end
