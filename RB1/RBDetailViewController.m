#import "RBDetailViewController.h"
#import "RBWebViewController.h"
#import "RBCommentsViewController.h"

#define PAGE_COUNT_INCREMENT    25

@implementation RBDetailViewController {
    UITableView* _infoTable;
    NSArray* _things;
    RBMasterTableViewController* _masterTableViewController;
    RBThing* _selectedThing;
    NSInteger _pageCounter;
    NSInteger _lastSelectedRow;
}
@synthesize infoTable = _infoTable;
@synthesize toolbar = _toolbar;
@synthesize loginButton = _loginButton;
@synthesize toolbarTitle = _toolbarTitle;
@synthesize selectedSubReddit = _selectedSubReddit;

#pragma mark View LifeCycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _masterTableViewController = [RBAppDelegate masterViewController];
}

- (void) viewDidUnload 
{
    [self setToolbar:nil];
    [self setLoginButton:nil];
    [self setToolbarTitle:nil];
    [super viewDidUnload];
}

#pragma mark MasterTableViewControllerDelegate

- (void) masterTableViewController:(RBMasterTableViewController*)tableViewController didSelectSubreddit:(RBSubReddit*)subreddit
{
    [_masterPopoverController dismissPopoverAnimated:YES];
    
    [[self toolbarTitle] setText:[subreddit title]];
        
    [self setSelectedSubReddit:subreddit];
    
    _pageCounter = PAGE_COUNT_INCREMENT;
    [[self dataProvider] thingsForRedditNamed:_selectedSubReddit.url count:[NSNumber numberWithInteger:_pageCounter] lastId:nil withCompletionBlock:^(NSArray* things) {
        _things = [NSArray arrayWithArray:things];
        if (_pageCounter == PAGE_COUNT_INCREMENT) {
            [_infoTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        }
        [_infoTable reloadData];
        _pageCounter += PAGE_COUNT_INCREMENT;
    } failBlock:^(NSError* error) {
        //
    }];
}

#pragma mark TableView Methods

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _things.count;
}

- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kRBDetailViewTableCellHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    RBDetailViewTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kRBDetailViewTableCellReuseIdentifier];
    if (nil == cell) {
        cell = [UIView viewWithNibNamed:kRBDetailViewTableCellReuseIdentifier];
        [cell setDelegate:self];
    }
    [cell setThing:[_things objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedThing = [_things objectAtIndex:[indexPath row]];
    [_selectedThing setVisited:YES];
    _lastSelectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"WebViewPush" sender:nil];
}

- (void) tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == _things.count - 1) {
        
        RBThing* lastThing = _things.lastObject;
        [[self dataProvider] thingsForRedditNamed:_selectedSubReddit.url count:[NSNumber numberWithInteger:_pageCounter] lastId:lastThing.name withCompletionBlock:^(NSArray* things) {
            NSMutableArray* newArray = _things.mutableCopy;
            [newArray addObjectsFromArray:things];
            _things = newArray;
            [_infoTable reloadData];
            _pageCounter += PAGE_COUNT_INCREMENT;
        } failBlock:^(NSError* error) {
            //
        }];
    }
}

#pragma Mark SplitViewController

- (void) splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController*)pc
{
    [barButtonItem setTitle:@"Reddits"];
    NSMutableArray* items = [[[self toolbar] items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [[self toolbar] setItems:items animated:YES];
    _masterPopoverController = pc;
}

- (void) splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController*)aViewController invalidatingBarButtonItem:(UIBarButtonItem*)barButtonItem
{
    NSMutableArray* items = [[[self toolbar] items] mutableCopy];
    [items removeObject:barButtonItem];
    [[self toolbar] setItems:items animated:YES];
    _masterPopoverController = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AuthModal"]) {
        [(RBAuthenticationViewController*)[segue destinationViewController] setDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"WebViewPush"]) {
        RBWebViewController* viewController = (RBWebViewController*)[segue destinationViewController];
        [viewController setThing:_selectedThing];
        [viewController setDelegate:self];        
    }
    else if ([[segue identifier] isEqualToString:@"CommentsModal"]) {
        RBCommentsViewController* viewController = (RBCommentsViewController*)[segue destinationViewController];
        [viewController setThing:_selectedThing];
        [viewController setDelegate:self];
    }
}

#pragma mark AuthenticationControllerDelegate

- (void) authenticationViewController:(RBAuthenticationViewController*)authenticationViewController authenticatedUser:(RBUser*)user
{
    [[self dataProvider] redditsForUser:user
        withCompletionBlock:^(NSArray* subreddits) {
            [_masterTableViewController setSubReddits:subreddits];
        } failBlock:^(NSError* error) {
            //
        }
    ];
}

#pragma mark WebViewControllerDelegate

- (void) webViewControllerShouldDismiss:(RBWebViewController*)webViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSIndexPath* path = [NSIndexPath indexPathForRow:_lastSelectedRow inSection:0];
        [_infoTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark DetailViewTableCellDelegate

- (void) detailViewTableCell:(RBDetailViewTableCell*)detailViewTableCell didSelectCommentsForThing:(RBThing*)thing
{
    _selectedThing = thing;
    [self performSegueWithIdentifier:@"CommentsModal" sender:self];
}

#pragma mark CommentsViewControllerDelegate

- (void)commentsViewControllerShouldDismiss:(RBCommentsViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        // dismiss
    }];    
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (RBDataProvider*) dataProvider 
{
    return [[RBAppDelegate sharedAppDelegate] dataProvider];
}

@end
