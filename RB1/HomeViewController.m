#import "HomeViewController.h"
#import "HomeInfoView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSArray* _subReddits;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
        
    [[self dataProvider] redditsForAnonymousUserWithCompletionBlock:^(NSArray *subReddits) {
        _subReddits = [subReddits sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
        [_selectionListTable reloadData];
    } failBlock:^(NSError *error) {
        //
    }];
}

- (CGFloat) tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _subReddits.count;
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    if (nil == cell) {
        //XXX: set up the cell
    }
    SubReddit* subReddit = [_subReddits objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:subReddit.displayName];
    return cell;
}

-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [_homeInfoView setSelectedSubReddit:[_subReddits objectAtIndex:[indexPath row]]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (DataProvider*) dataProvider
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

@end
