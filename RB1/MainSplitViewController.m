#import "MainSplitViewController.h"

@interface MainSplitViewController ()

@end

@implementation MainSplitViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self dataProvider] redditsForAnonymousUserWithCompletionBlock:^(NSArray* reddits) {
        //
    }  failBlock:^(NSError *error) {
        //
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (DataProvider*) dataProvider
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}    
     
@end
