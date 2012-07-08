#import "CommentsViewController.h"
#import "CommentCell.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

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
    Comment* comment = [_comments objectAtIndex:indexPath.row];
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
    CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellReuseIdentifier];
    if (nil == cell) {
        cell = [UIView viewWithNibNamed:kCommentCellReuseIdentifier];
    }
    
    Comment* currentComment = [_comments objectAtIndex:indexPath.row];
    [cell setComment:currentComment];

    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Comment* comment = [_comments objectAtIndex:indexPath.row];
    NSLog(@"%@", comment.body);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)backButtonPressed:(id)sender 
{
    [_delegate commentsViewControllerShouldDismiss:self];
}

- (DataProvider*) dataProvider 
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

@end
