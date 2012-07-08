#import "RBCommentCell.h"

NSString* kRBCommentCellReuseIdentifier = @"RBCommentCell";

@implementation RBCommentCell

@synthesize comment = _comment;

- (void) setComment:(RBComment*)comment
{
    _comment = comment;
    [self.textLabel setNumberOfLines:0];
    [self.textLabel setLineBreakMode:UILineBreakModeWordWrap];
    NSString* noBreaksComment = [_comment.body stringByReplacingOccurrencesOfString:@"/n" withString:@" "];
    [self.textLabel setText:noBreaksComment];
}

@end
