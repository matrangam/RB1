@class WebViewController;
@protocol WebViewControllerDelegate <NSObject>
- (void) webViewControllerShouldDismiss:(WebViewController*)webViewController;
@end

@interface WebViewController : UIViewController

@property (strong, nonatomic) id <WebViewControllerDelegate> delegate;
@property (strong, nonatomic) Thing* thing;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UILabel *toolbarTitleLabel;
@property (strong, nonatomic) IBOutlet UIWebView* webView;

- (IBAction) backButtonPressed:(id)sender;

@end
