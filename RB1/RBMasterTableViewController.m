#import "RBMasterTableViewController.h"

@interface RBMasterTableViewController ()
- (void) _sortSubreddits:(NSArray*)subreddits;
@end

@implementation RBMasterTableViewController 

@synthesize delegate = _delegate;
@synthesize subReddits = _subReddits;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self dataProvider] redditsForAnonymousUserWithCompletionBlock:^(NSArray *subReddits) {
        [self setSubReddits:subReddits];
    } failBlock:^(NSError *error) {
        //
    }];
}

#pragma mark methods man

- (void) setSubReddits:(NSArray*)subReddits
{
    if (_subReddits != subReddits) {
        _subReddits = [subReddits sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"display_name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
        [self.tableView reloadData];            
    }
}

- (void) _sortSubreddits:(NSArray*)subreddits 
{
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
    RBSubReddit* subReddit = [_subReddits objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:subReddit.display_name];
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

- (RBDataProvider*) dataProvider
{
    return [[RBAppDelegate sharedAppDelegate] dataProvider];
}

@end

