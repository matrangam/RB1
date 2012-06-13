@class AuthenticationViewController;

@protocol AuthenticationViewControllerDelegate <NSObject>

- (void) authenticationViewController:(AuthenticationViewController*)authenticationViewController authenticatedUser:(User*)user;

@end

@interface AuthenticationViewController : UIViewController <UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction) loginButtonPressed:(id)sender;
- (IBAction) dismisButtonPressed:(id)sender;

@end
