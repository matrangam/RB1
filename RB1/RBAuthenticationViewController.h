@class RBAuthenticationViewController;

@protocol RBAuthenticationViewControllerDelegate <NSObject>

- (void) authenticationViewController:(RBAuthenticationViewController*)authenticationViewController authenticatedUser:(RBUser*)user;

@end

@interface RBAuthenticationViewController : UIViewController <UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) id <RBAuthenticationViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction) loginButtonPressed:(id)sender;
- (IBAction) dismisButtonPressed:(id)sender;

@end
