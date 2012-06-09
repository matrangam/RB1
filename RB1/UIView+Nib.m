#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (id) viewWithNibNamed:(NSString*)nibName
{
    NSArray* topLevelObjects = [[UINib nibWithNibName:nibName bundle:nil] instantiateWithOwner:nil options:nil];
    NSAssert(topLevelObjects.count == 1, @"WTF?");
    id view = [topLevelObjects objectAtIndex:0];
    return view;
}
@end
