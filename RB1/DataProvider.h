#import <Foundation/Foundation.h>

@interface DataProvider : NSObject <QueryDelegate>

@property (nonatomic, copy) void(^didComplete)(NSURLResponse* response, id object);
@property (nonatomic, copy) void(^didFailWithError)(NSError* error);

-(void) authenticateUser:(User*)user withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError *))failedWithError;

@end
