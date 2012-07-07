#import "CommentsViewController.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

@synthesize delegate = _delegate;
@synthesize comments = _comments;
@synthesize commentsTable = _commentsTable;

#pragma mark View Lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload 
{
    [self setCommentsTable:nil];
    [super viewDidUnload];
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment* comment = [_comments objectAtIndex:indexPath.row];
    NSString* commentBody = comment.body;
    CGSize cellSize = [commentBody sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(tableView.frame.size.width, 999) lineBreakMode:UILineBreakModeWordWrap];
    
    return cellSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    if (nil == cell) {
        [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];        
    }
    
    [cell.textLabel setNumberOfLines:0];    
    Comment* currentComment = [_comments objectAtIndex:indexPath.row];
    NSString* commentBody = currentComment.body;
    CGSize cellSize = [commentBody sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(tableView.frame.size.width, 999) lineBreakMode:UILineBreakModeWordWrap];

    CGRect frame = cell.textLabel.frame;
    frame.size.height = cellSize.height;
    [cell.textLabel setFrame:frame];
    
    cell.textLabel.text = commentBody;
    
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Comment* comment = [_comments objectAtIndex:indexPath.row];
    NSLog(@"%@", comment.bodyHTML);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)backButtonPressed:(id)sender 
{
    [_delegate commentsViewControllerShouldDismiss:self];
}
@end
