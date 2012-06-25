#import "ImageLoader.h"
@interface DataProvider : NSObject <QueryDelegate>

@property (nonatomic, copy) void(^didComplete)(NSURLResponse* response, id object);
@property (nonatomic, copy) void(^didFailWithError)(NSError* error);

- (void) authenticateUser:(User*)user withCompletionBlock:(void(^)(User*))completionBlock failBlock:(void(^)(NSError *))failedWithError;
- (void) redditsForAnonymousUserWithCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError *))failedWithError;
- (void) redditsForUser:(User*)user withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError;
- (void) infoForReddit:(NSString*)reddit withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError;
- (void) commentsForThing:(Thing*)thing withCompletionBlock:(void(^)(void))completionBlock failBlock:(void(^)(NSError*))failedWithError;

+ (id<ImageLoader>) sharedImageLoader;

@end
