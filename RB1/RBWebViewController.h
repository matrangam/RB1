@class RBWebViewController;
@protocol RBWebViewControllerDelegate <NSObject>
- (void) webViewControllerShouldDismiss:(RBWebViewController*)webViewController;
@end

@interface RBWebViewController : UIViewController

@property (strong, nonatomic) id <RBWebViewControllerDelegate> delegate;
@property (strong, nonatomic) RBThing* thing;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UILabel *toolbarTitleLabel;
@property (strong, nonatomic) IBOutlet UIWebView* webView;

- (IBAction) backButtonPressed:(id)sender;

@end
