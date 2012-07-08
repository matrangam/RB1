#import "CommentCell.h"

NSString* kCommentCellReuseIdentifier = @"CommentCell";

@implementation CommentCell

@synthesize comment = _comment;

- (void) setComment:(Comment*)comment
{
    _comment = comment;
    [self.textLabel setNumberOfLines:0];
    [self.textLabel setLineBreakMode:UILineBreakModeWordWrap];
    NSString* noBreaksComment = [_comment.body stringByReplacingOccurrencesOfString:@"/n" withString:@" "];
    [self.textLabel setText:noBreaksComment];
}

@end
