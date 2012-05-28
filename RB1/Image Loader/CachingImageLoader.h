#import "ImageLoader.h"


@interface CachingImageLoader : NSObject <ImageLoader> {
    NSString* _diskPath;
    id<ImageLoader> _backingImageLoader;
    dispatch_queue_t _queue;
    NSMutableDictionary* _infoByURL;
}

- (id) initWithBackingImageLoader:(id<ImageLoader>)imageLoader diskPath:(NSString*)diskPath;

@end
