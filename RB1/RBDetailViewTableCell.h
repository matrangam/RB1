extern NSString* kRBDetailViewTableCellReuseIdentifier;
extern CGFloat kRBDetailViewTableCellHeight;

@class RBThing, RBDetailViewTableCell;
@protocol RBDetailViewTableCellDelegate <NSObject>

- (void) detailViewTableCell:(RBDetailViewTableCell*)detailViewTableCell didSelectCommentsForThing:(RBThing*)thing;

@end

@interface RBDetailViewTableCell : UITableViewCell

@property (unsafe_unretained, nonatomic) id <RBDetailViewTableCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentsButton;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *iconSpinner;
@property (strong, nonatomic) RBThing* thing;

- (IBAction) commentsButtonPressed:(id)sender;

@end
