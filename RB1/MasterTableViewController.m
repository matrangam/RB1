#import "MasterTableViewController.h"

@interface MasterTableViewController ()
- (void) _sortSubreddits:(NSArray*)subreddits;
@end

@implementation MasterTableViewController {
    NSArray* _subReddits;
}

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self dataProvider] redditsForAnonymousUserWithCompletionBlock:^(NSArray *subReddits) {
        [self _sortSubreddits:subReddits];
    } failBlock:^(NSError *error) {
        //
    }];
}

#pragma mark methods man

- (void) _sortSubreddits:(NSArray*)subreddits 
{
    _subReddits = [subreddits sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    [self.tableView reloadData];    
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _subReddits.count;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    if (nil == cell) {
        //XXX: set up the cell
    }
    SubReddit* subReddit = [_subReddits objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:subReddit.displayName];
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [[self delegate] masterTableViewController:self didSelectSubreddit:[_subReddits objectAtIndex:[indexPath row]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark AuthenticationViewControllerDelegate

- (void) authenticationViewController:(AuthenticationViewController*)authenticationViewController authenticatedUser:(User*)user
{
    [[self dataProvider] redditsForUser:user withCompletionBlock:^(NSArray *subReddits) {
        [self _sortSubreddits:subReddits];
    } failBlock:^(NSError* error) {
        //
    }];
}

- (DataProvider*) dataProvider
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

@end
