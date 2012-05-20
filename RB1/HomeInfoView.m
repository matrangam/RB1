#import "HomeInfoView.h"

@implementation HomeInfoView {
    NSArray* _things;
}

@synthesize selectedSubReddit = _selectedSubReddit;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (nil != (self = [super initWithCoder:aDecoder])) {
        _infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        [self addSubview:_infoTable];
    }
    return self;
}

- (void) setSelectedSubReddit:(SubReddit*)selectedSubReddit
{
    if (_selectedSubReddit != selectedSubReddit) {
        _selectedSubReddit = selectedSubReddit;
        [[self dataProvider] infoForReddit:_selectedSubReddit.url withCompletionBlock:^(NSArray *array) {
            _things = [array copy];
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

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    if (nil == cell) {
        //XXX: set up the cell
    }
    
    return cell;
}

- (DataProvider*) dataProvider 
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

@end
