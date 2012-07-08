@class RBAuthenticationViewController;

@protocol AuthenticationViewControllerDelegate <NSObject>

- (void) authenticationViewController:(RBAuthenticationViewController*)authenticationViewController authenticatedUser:(User*)user;

@end

@interface RBAuthenticationViewController : UIViewController <UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) id <AuthenticationViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction) loginButtonPressed:(id)sender;
- (IBAction) dismisButtonPressed:(id)sender;

@end
