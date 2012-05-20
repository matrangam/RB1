#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSArray* _subReddits;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [[self dataProvider] redditsForAnonymousUserWithCompletionBlock:^(NSArray *subReddits) {        
        _subReddits = [subReddits sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
        [_tableView reloadData];
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
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    SubReddit* subReddit = [_subReddits objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:subReddit.title];
    return cell;
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
