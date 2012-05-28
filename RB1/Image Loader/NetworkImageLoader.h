#import "ImageLoader.h"


@interface NetworkImageLoader : NSObject <ImageLoader> {
    dispatch_queue_t _queue;
    NSMutableDictionary* _infoByURL;
}

+ (NetworkImageLoader*) sharedImageLoader;

- (id) init;

@end
