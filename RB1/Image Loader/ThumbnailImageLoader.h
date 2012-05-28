#import "ImageLoader.h"


@interface ThumbnailImageLoader : NSObject <ImageLoader> {
    id<ImageLoader> _backingImageLoader;
    CGFloat _thumbnailSize;
    dispatch_queue_t _queue;
    NSMutableDictionary* _infoByURL;
}

- (id) initWithBackingImageLoader:(id<ImageLoader>)imageLoader thumbnailSize:(CGFloat)thumbnailSize;

@end
