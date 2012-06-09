#import "HomeInfoViewController.h"
#import "HomeInfoViewTableCell.h"
#import "NSString+TimeInterval.h"

@implementation HomeInfoViewController {
    UITableView* _infoTable;
    NSArray* _things;
}

@synthesize infoTable = _infoTable;
@synthesize toolbar = _toolbar;
@synthesize selectedSubReddit = _selectedSubReddit;

- (void) masterTableViewController:(MasterTableViewController*)tableViewController didSelectSubreddit:(SubReddit*)subreddit
{
    [[self dataProvider] infoForReddit:_selectedSubReddit.url withCompletionBlock:^(NSArray* things) {
        _things = [NSArray arrayWithArray:things];
        [_infoTable reloadData];
    } failBlock:^(NSError* error) {
        //
    }];
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _things.count;
}

- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kHomeInfoViewTableCellHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    HomeInfoViewTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kHomeInfoViewTableCellReuseIdentifier];
    if (nil == cell) {
        cell = [UIView viewWithNibNamed:kHomeInfoViewTableCellReuseIdentifier];
    }
    Thing* selectedThing = [_things objectAtIndex:[indexPath row]];
    [[cell titleLabel] setText:selectedThing.title];

    NSInteger timeInterval = [[NSDate dateWithTimeIntervalSince1970:selectedThing.createdUTC.doubleValue] timeIntervalSinceDate:[NSDate date]];
    [[cell authorLabel] setText:[NSString stringWithFormat:@"Submitted %@ by %@ to %@", [NSString stringForTimeInterval:timeInterval includeSeconds:YES], selectedThing.author, selectedThing.subreddit]];
    
    [[cell commentsButton] setTitle:[NSString stringWithFormat:@"%@", selectedThing.comments] forState:UIControlStateNormal];
    
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Thing* selectedThing = [_things objectAtIndex:[indexPath row]];
    
    NSLog(@"%@", selectedThing.createdUTC);
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

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (DataProvider*) dataProvider 
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

- (void) viewDidUnload 
{
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end
