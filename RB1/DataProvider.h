#import <Foundation/Foundation.h>

@interface DataProvider : NSObject <QueryDelegate>

-(void) authenticateUser:(User*)user withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError *))failedWithError;

@end
