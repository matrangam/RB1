@interface CommentCell : UITableViewCell

extern NSString* kCommentCellReuseIdentifier;

@property (strong, nonatomic) Comment* comment;

@end
