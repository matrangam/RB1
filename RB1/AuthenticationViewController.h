@interface AuthenticationViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction) loginButtonPressed:(id)sender;

@end
