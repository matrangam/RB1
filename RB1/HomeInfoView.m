#import "HomeInfoView.h"
#import "HomeInfoViewTableCell.h"

@implementation HomeInfoView {
    UITableView* _infoTable;
    NSArray* _things;

}

@synthesize selectedSubReddit = _selectedSubReddit;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (nil != (self = [super initWithCoder:aDecoder])) {
        _infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        [_infoTable setDataSource:self];
        [_infoTable setDelegate:self];
        [self addSubview:_infoTable];
    }
    return self;
}

- (void) setSelectedSubReddit:(SubReddit*)selectedSubReddit
{
    if (_selectedSubReddit != selectedSubReddit) {
        _selectedSubReddit = selectedSubReddit;
        [[self dataProvider] infoForReddit:_selectedSubReddit.url withCompletionBlock:^(NSArray *things) {
            _things = [NSArray arrayWithArray:things];
            [_infoTable reloadData];
        } failBlock:^(NSError* error) {
            //
        }];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
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
        cell = [HomeInfoViewTableCell createNewCellFromNib];
    }
    Thing* selectedThing = [_things objectAtIndex:[indexPath row]];
    [[cell titleLabel] setText:selectedThing.title];
    
    return cell;
}

- (DataProvider*) dataProvider 
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

@end
