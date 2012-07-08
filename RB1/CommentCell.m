#import "CommentCell.h"

NSString* kCommentCellReuseIdentifier = @"CommentCell";

@implementation CommentCell

@synthesize comment = _comment;
@synthesize commentBody = _commentBody;

- (void) setComment:(Comment*)comment
{
    _comment = comment;
    NSString* HTMLString = [NSString stringWithFormat:@"<html><body>%@</body></html>", _comment.bodyHTML];
    [_commentBody loadHTMLString:HTMLString baseURL:nil];
    _commentBody.contentMode = UIViewContentModeScaleToFill;
    
    
}

@end
