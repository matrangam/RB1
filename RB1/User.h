#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* cookie;
@property (nonatomic, strong) NSString* modhash;

@end
