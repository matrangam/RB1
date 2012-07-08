@interface CommentCell : UITableViewCell

extern NSString* kCommentCellReuseIdentifier;

@property (strong, nonatomic) Comment* comment;
@property (strong, nonatomic) IBOutlet UIWebView *commentBody;

@end
