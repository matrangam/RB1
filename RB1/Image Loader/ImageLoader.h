

@protocol ImageLoader <NSObject>
@required
- (void) loadImageForURL:(NSURL*)url completionBlock:(void (^)(UIImage*, BOOL))block;
- (void) cancelCompletionBlock:(void (^)(UIImage*, BOOL))block forURL:(NSURL*)url;
@end

#import "CachingImageLoader.h"
#import "NetworkImageLoader.h"
#import "ThumbnailImageLoader.h"
