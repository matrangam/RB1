extern NSString* kDetailViewTableCellReuseIdentifier;
extern CGFloat kDetailViewTableCellHeight;

@class Thing, DetailViewTableCell;
@protocol DetailViewTableCellDelegate <NSObject>

- (void) detailViewTableCell:(DetailViewTableCell*)detailViewTableCell didSelectCommentsForThing:(Thing*)thing;

@end

@interface DetailViewTableCell : UITableViewCell

@property (unsafe_unretained, nonatomic) id <DetailViewTableCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentsButton;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) Thing* thing;

- (IBAction) commentsButtonPressed:(id)sender;

@end
