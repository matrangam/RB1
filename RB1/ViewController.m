#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableData* _data;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DataProvider* provider = [[DataProvider alloc] init];    
    User* me = [[User alloc] init];
    [provider authenticateUser:me withCompletionBlock:^(NSArray *array) {
            //
        } failBlock:^(NSError *error) {
            //
        }
    ];
}

- (void)query:(Query *)query didReceiveData:(NSData *)data
{
    NSLog(@"%@", data);
    [_data appendData:data];
}

- (void)query:(Query *)query didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

- (void)query:(Query *)query didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)queryDidFinishLoading:(Query *)query
{
    NSString* jsonString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSString* result = [NSString stringWithObjectAsJSON:jsonString];
    NSLog(@"%@", result);
}

@end
