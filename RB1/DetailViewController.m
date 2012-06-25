#import "DetailViewController.h"
#import "DetailViewTableCell.h"
#import "WebViewController.h"

@implementation DetailViewController {
    UITableView* _infoTable;
    NSArray* _things;
    MasterTableViewController* _masterTableViewController;
    Thing* _selectedThing;
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
    
    _masterTableViewController = (MasterTableViewController*)[[[[[AppDelegate sharedAppDelegate] splitViewController] viewControllers] objectAtIndex:0] topViewController];
}

- (void) viewDidUnload 
{
    [self setToolbar:nil];
    [self setLoginButton:nil];
    [self setToolbarTitle:nil];
    [super viewDidUnload];
}

#pragma mark MasterTableViewControllerDelegate

- (void) masterTableViewController:(MasterTableViewController*)tableViewController didSelectSubreddit:(SubReddit*)subreddit
{
    [_masterPopoverController dismissPopoverAnimated:YES];
    
    [[self toolbarTitle] setText:[subreddit title]];
        
    [self setSelectedSubReddit:subreddit];
    [[self dataProvider] infoForReddit:_selectedSubReddit.url withCompletionBlock:^(NSArray* things) {
        _things = [NSArray arrayWithArray:things];
        [_infoTable reloadData];
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
    return kDetailViewTableCellHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    DetailViewTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kDetailViewTableCellReuseIdentifier];
    if (nil == cell) {
        cell = [UIView viewWithNibNamed:kDetailViewTableCellReuseIdentifier];
    }
    [cell setThing:[_things objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedThing = [_things objectAtIndex:[indexPath row]];
    if (![[_selectedThing isSelf] boolValue]) {
        [self performSegueWithIdentifier:@"WebViewPush" sender:nil];        
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
        [(AuthenticationViewController*)[segue destinationViewController] setDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"WebViewPush"]) {
        [(WebViewController*)[segue destinationViewController] setThing:_selectedThing];
    }
}

- (void) authenticationViewController:(AuthenticationViewController*)authenticationViewController authenticatedUser:(User*)user
{
    [[self dataProvider] redditsForUser:user
        withCompletionBlock:^(NSArray* subreddits) {
            [_masterTableViewController setSubReddits:subreddits];
        } failBlock:^(NSError* error) {
            //
        }
    ];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (DataProvider*) dataProvider 
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

@end
