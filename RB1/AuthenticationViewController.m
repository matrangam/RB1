#import "AuthenticationViewController.h"

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

@synthesize delegate = _delegate;
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
        [self dismissViewControllerAnimated:YES completion:^{
            [[self delegate] authenticationViewControllerDidAuthenticate:self];
        }];
    } failBlock:^(NSError *error) {
        //
    }];
}

- (IBAction) dismisButtonPressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (DataProvider*) dataProvider
{
    return [[AppDelegate sharedAppDelegate] dataProvider];
}



@end
