#import "ImageLoader.h"
@interface RBDataProvider : NSObject <QueryDelegate>

@property (nonatomic, copy) void(^didComplete)(NSURLResponse* response, id object);
@property (nonatomic, copy) void(^didFailWithError)(NSError* error);

- (void) authenticateUser:(RBUser*)user withCompletionBlock:(void(^)(RBUser*))completionBlock failBlock:(void(^)(NSError *))failedWithError;
- (void) redditsForAnonymousUserWithCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError *))failedWithError;
- (void) redditsForUser:(RBUser*)user withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError;
- (void) thingsForRedditNamed:(NSString*)reddit withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError;
- (void) commentsForThing:(RBThing*)thing withCompletionBlock:(void(^)(NSArray*))completionBlock failBlock:(void(^)(NSError*))failedWithError;

+ (id<ImageLoader>) sharedImageLoader;

@end
