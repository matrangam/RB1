#import "RBDetailViewTableCell.h"
#import "NSString+TimeInterval.h"

NSString* kRBDetailViewTableCellReuseIdentifier = @"RBDetailViewTableCell";
CGFloat kRBDetailViewTableCellHeight = 90.0;

@implementation RBDetailViewTableCell

@synthesize delegate = _delegate;
@synthesize iconImageView = _iconImageView;
@synthesize titleLabel = _titleLabel;
@synthesize commentsButton = _commentsButton;
@synthesize authorLabel = _authorLabel;
@synthesize thing = _thing;

- (void) setThing:(Thing *)thing
{
    if (_thing != thing) {
        _thing = thing;
        NSInteger timeInterval = [[NSDate dateWithTimeIntervalSince1970:thing.createdUTC.doubleValue] timeIntervalSinceDate:[NSDate date]];
        [[self authorLabel] setText:[NSString stringWithFormat:@"Submitted %@ by %@ to %@", [NSString stringForTimeInterval:timeInterval includeSeconds:YES], thing.author, thing.subreddit]];
        [[self titleLabel] setText:thing.title];        
        [[self commentsButton] setTitle:[NSString stringWithFormat:@"%@", thing.comments] forState:UIControlStateNormal];
    }
}

- (IBAction) commentsButtonPressed:(id)sender 
{
    [_delegate detailViewTableCell:self didSelectCommentsForThing:_thing];
}
@end
