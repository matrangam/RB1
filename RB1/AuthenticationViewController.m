#import "AuthenticationViewController.h"
#import "MainSplitViewController.h"

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

@synthesize userNameField = _userNameField;
@synthesize passwordField = _passwordField;


- (void) viewDidUnload 
{
    [self setUserNameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}

- (IBAction)loginButtonPressed:(id)sender 
{
    User* user = [[User alloc] init];
    [user setUsername:_userNameField.text];
    [user setPassword:_passwordField.text];
    
    [[self dataProvider] authenticateUser:user withCompletionBlock:^(User *user) {
        //
    } failBlock:^(NSError *error) {
        //
    }];
}

- (DataProvider*) dataProvider
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
