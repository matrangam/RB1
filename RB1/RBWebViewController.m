#import "RBWebViewController.h"

@interface RBWebViewController ()

@end

@implementation RBWebViewController

@synthesize delegate = _delegate;
@synthesize thing = _thing;
@synthesize toolbar = _toolbar;
@synthesize toolbarTitleLabel = _toolbarTitleLabel;
@synthesize webView = _webView;

- (void) viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setTitle:_thing.title];
    [[self.navigationItem leftBarButtonItem] setTitle:@"BACK"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    NSURL* url = [NSURL URLWithString:_thing.url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void) viewDidUnload 
{
    [self setToolbar:nil];
    [self setToolbarTitleLabel:nil];
    [super viewDidUnload];
}

- (IBAction) backButtonPressed:(id)sender
{
    [_delegate webViewControllerShouldDismiss:self];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
