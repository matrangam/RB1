#import "RBDetailViewTableCell.h"
#import "NSString+TimeInterval.h"

NSString* kRBDetailViewTableCellReuseIdentifier = @"RBDetailViewTableCell";
CGFloat kRBDetailViewTableCellHeight = 90.0;

@implementation RBDetailViewTableCell

+ (UIColor*) inactiveColor
{
    return [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
}

- (CGRect) frameForSelfPostOfLabel:(UILabel*)label
{
    return CGRectMake(10, label.frame.origin.y, _commentsButton.frame.origin.x - 20, label.frame.size.height);
}

- (void) setThing:(RBThing *)thing
{
    if (_thing != thing) {
        _thing = thing;
        NSInteger timeInterval = [[NSDate dateWithTimeIntervalSince1970:thing.createdUTC.doubleValue] timeIntervalSinceDate:[NSDate date]];
        [[self authorLabel] setText:[NSString stringWithFormat:@"Submitted %@ by %@ to %@", [NSString stringForTimeInterval:timeInterval includeSeconds:YES], thing.author, thing.subreddit]];
        [[self titleLabel] setText:thing.title];
        [[self commentsButton] setTitle:[NSString stringWithFormat:@"%@", thing.numberOfComments] forState:UIControlStateNormal];
        if (_thing.hasBeenVisited) {
            self.titleLabel.textColor = [self.class inactiveColor];
            self.authorLabel.textColor = [self.class inactiveColor];
        }
        if ([_thing.isSelf isEqualToNumber:@(0)]) {
            [_iconSpinner startAnimating];
            [[RBDataProvider sharedImageLoader] loadImageForURL:[NSURL URLWithString:_thing.thumbnail] completionBlock:^(UIImage* image, BOOL isFinished) {
                [self.iconImageView setImage:image];
                [_iconSpinner stopAnimating];
            }];
        } else {
            [self.iconImageView setImage:nil];
            [_iconSpinner stopAnimating];
            
            [_titleLabel setFrame:[self frameForSelfPostOfLabel:_titleLabel]];
            [_authorLabel setFrame:[self frameForSelfPostOfLabel:_authorLabel]];
            [self layoutSubviews];
        }
    }
}

- (IBAction) commentsButtonPressed:(id)sender 
{
    [_delegate detailViewTableCell:self didSelectCommentsForThing:_thing];
}

- (RBDataProvider*) dataProvider
{
    return [[RBAppDelegate sharedAppDelegate] dataProvider];
}

@end
