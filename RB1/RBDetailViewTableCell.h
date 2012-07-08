extern NSString* kRBDetailViewTableCellReuseIdentifier;
extern CGFloat kRBDetailViewTableCellHeight;

@class Thing, RBDetailViewTableCell;
@protocol DetailViewTableCellDelegate <NSObject>

- (void) detailViewTableCell:(RBDetailViewTableCell*)detailViewTableCell didSelectCommentsForThing:(Thing*)thing;

@end

@interface RBDetailViewTableCell : UITableViewCell

@property (unsafe_unretained, nonatomic) id <DetailViewTableCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentsButton;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) Thing* thing;

- (IBAction) commentsButtonPressed:(id)sender;

@end
