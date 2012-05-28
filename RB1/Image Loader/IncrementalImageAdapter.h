#import <ImageIO/ImageIO.h>
@protocol IncrementalImageAdapterDelegate;

@interface IncrementalImageAdapter : NSObject <QueryDelegate> {
    NSMutableData* _bytes;
    CGImageSourceRef _imageSource;
    dispatch_queue_t _queue;
    id<IncrementalImageAdapterDelegate> _delegate;
    CGImageRef _lastImage;
    NSUInteger _height;
}

@property (nonatomic, assign) dispatch_queue_t queue;
@property (nonatomic, retain) id<IncrementalImageAdapterDelegate> delegate;

- (id) initWithQueue:(dispatch_queue_t)queue imageAdapterDelegate:(id<IncrementalImageAdapterDelegate>)delegate;

@end

@protocol IncrementalImageAdapterDelegate <NSObject>
@required
- (void) incrementalImageAdapter:(IncrementalImageAdapter*)adapter didUpdateImage:(UIImage*)image forURL:(NSURL*)url isFinal:(BOOL)isFinal;
- (void) incrementalImageAdapter:(IncrementalImageAdapter*)adapter didFailWithError:(NSError*)error forURL:(NSURL*)url;
@end
