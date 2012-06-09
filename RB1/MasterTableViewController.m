#import "MasterTableViewController.h"

@interface MasterTableViewController ()

@end

@implementation MasterTableViewController {
    NSArray* _subReddits;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self dataProvider] redditsForAnonymousUserWithCompletionBlock:^(NSArray *subReddits) {
        _subReddits = [subReddits sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        //
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

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
//    [_homeInfoView setSelectedSubReddit:[_subReddits objectAtIndex:[indexPath row]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


- (DataProvider*) dataProvider
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

@end
