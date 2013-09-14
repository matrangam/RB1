#import "RBCommentsViewController.h"
#import "RBCommentCell.h"

@interface RBCommentsViewController ()

@end

@implementation RBCommentsViewController

@synthesize delegate = _delegate;
@synthesize comments = _comments;
@synthesize thing = _thing;
@synthesize commentsTable = _commentsTable;
@synthesize commentCell = _commentCell;
@synthesize commentBodyView = _commentBodyView;

#pragma mark View Lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [[self dataProvider] commentsForThing:_thing withCompletionBlock:^(NSArray* comments){
        _comments = [NSArray arrayWithArray:comments];
        [_commentsTable reloadData];
    } failBlock:^(NSError *error) {
        //
    }];
}

- (void)viewDidUnload 
{
    [self setCommentsTable:nil];
    [self setCommentCell:nil];
    [self setCommentBodyView:nil];
    [super viewDidUnload];
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RBComment* comment = [_comments objectAtIndex:indexPath.row];
    NSString* commentBody = comment.body;
    CGSize cellSize = [commentBody sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] 
                              constrainedToSize:CGSizeMake(tableView.frame.size.width, 999) 
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    return cellSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RBCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:kRBCommentCellReuseIdentifier];
    if (nil == cell) {
        cell = [UIView viewWithNibNamed:kRBCommentCellReuseIdentifier];
    }
    
    RBComment* currentComment = [_comments objectAtIndex:indexPath.row];
    [cell setComment:currentComment];

    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RBComment* comment = [_comments objectAtIndex:indexPath.row];
    NSLog(@"%@", comment.children);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)backButtonPressed:(id)sender 
{
    [_delegate commentsViewControllerShouldDismiss:self];
}

- (RBDataProvider*) dataProvider 
{
    return [[RBAppDelegate sharedAppDelegate] dataProvider];
}

@end
