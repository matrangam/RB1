#import "HomeInfoViewTableCell.h"

NSString* kHomeInfoViewTableCellReuseIdentifier = @"HomeInfoViewTableCell";
CGFloat kHomeInfoViewTableCellHeight = 90.0;

@implementation HomeInfoViewTableCell
@synthesize iconImageView;
@synthesize titleLabel;
@synthesize goButton;


+ (HomeInfoViewTableCell*) createNewCellFromNib
{
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"HomeInfoViewTableCell" owner:self options:nil];
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
	HomeInfoViewTableCell* newCell = nil;
	NSObject* nibItem = nil;
	while ((nibItem = [nibEnumerator nextObject]) != nil) {
		if ([nibItem isKindOfClass: [HomeInfoViewTableCell class]]) {
			newCell = (HomeInfoViewTableCell*)nibItem;
			if ([newCell.reuseIdentifier isEqualToString:kHomeInfoViewTableCellReuseIdentifier]) {
                break;
            } else {
                newCell = nil;
            }
		}
	}
	return newCell;
}


@end
