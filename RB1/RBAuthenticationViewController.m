#import "RBAuthenticationViewController.h"

@interface RBAuthenticationViewController ()

@end

@implementation RBAuthenticationViewController

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
    
    [[self dataProvider] authenticateUser:user 
        withCompletionBlock:^(User *user) {
            [[self delegate] authenticationViewController:self authenticatedUser:user];
            [self dismissModalViewControllerAnimated:YES];
        } 
        failBlock:^(NSError *error) {
            //
        }
    ];
}

- (IBAction) dismisButtonPressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
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
