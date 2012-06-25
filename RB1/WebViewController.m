#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize thing = _thing;
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

@end
