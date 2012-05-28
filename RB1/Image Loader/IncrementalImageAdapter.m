#import "IncrementalImageAdapter.h"


@interface IncrementalImageAdapter ()
- (void) _cleanup;
- (void) _updateImageSourceForURL:(NSURL*)url isFinal:(BOOL)isFinal;
@end


@implementation IncrementalImageAdapter

- (void) dealloc 
{
    dispatch_release(_queue), _queue = NULL;
    _delegate = nil;
    [self _cleanup];
}

/**/

- (id) init
{
    return [self initWithQueue:nil imageAdapterDelegate:nil];
}

- (id) initWithQueue:(dispatch_queue_t)queue imageAdapterDelegate:(id<IncrementalImageAdapterDelegate>)delegate
{
    if (self = [super init]) {
        if (queue) {
            _queue = queue;
        } else {
            _queue = dispatch_get_current_queue();
        }
        dispatch_retain(_queue);
        _delegate = delegate;
    }
    return self;
}

- (void) _cleanup 
{
    _bytes = nil;
    if (_imageSource) {
        CFRelease(_imageSource), _imageSource = NULL;
    }
    if (_lastImage) {
        CFRelease(_lastImage), _lastImage = NULL;
    }
}

- (void) _updateImageSourceForURL:(NSURL*)url isFinal:(BOOL)isFinal
{
    CGImageSourceUpdateData(_imageSource, (__bridge CFDataRef)_bytes, isFinal);
    if (!_height) {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(_imageSource, 0, NULL);
        if (properties) {
            CFTypeRef value;
            if (CFDictionaryGetValueIfPresent(properties, kCGImagePropertyPixelHeight, &value)) {
                CFNumberGetValue(value, kCFNumberNSIntegerType, &_height);
            }
            CFRelease(properties);
        }
    }
    if (_height) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(_imageSource, 0, NULL);
        if (image) {
            if (_lastImage) {
                CFRelease(_lastImage);
            }
            _lastImage = image;
            CFRetain(image);
            dispatch_async(_queue, ^{
                [_delegate incrementalImageAdapter:self didUpdateImage:[UIImage imageWithCGImage:image] forURL:url isFinal:isFinal];
                CFRelease(image);
            });
        }
    } else if (isFinal && !_lastImage) {
        dispatch_async(_queue, ^{
            [_delegate incrementalImageAdapter:self didFailWithError:[NSError errorWithDomain:@"XXX"/* FIXME */ code:0 userInfo:nil] forURL:url];
        });
        [self _cleanup];
    }
}


#pragma mark -


- (void) query:(Query*)query didFailWithError:(NSError*)error
{
    dispatch_async(_queue, ^{
        [_delegate incrementalImageAdapter:self didFailWithError:error forURL:query.request.URL];
    });
    [self _cleanup];
}

- (void) query:(Query*)query didReceiveResponse:(NSURLResponse*)response
{
    _bytes = [[NSMutableData alloc] init];
    _imageSource = CGImageSourceCreateIncremental(NULL);
}

- (void) query:(Query*)query didReceiveData:(NSData*)data
{
    [_bytes appendData:data];
    [self _updateImageSourceForURL:query.request.URL isFinal:NO];
}

- (void) queryDidFinishLoading:(Query*)query
{
    [self _updateImageSourceForURL:query.request.URL isFinal:YES];
}

- (void) setQueue:(dispatch_queue_t)queue
{
    NSAssert(queue != nil, @"wtf?");
    if (queue != _queue) {
        if (_queue) {
            dispatch_release(_queue);
        }
        if (queue) {
            dispatch_retain(queue);
        }
        _queue = queue;
    }
}

@synthesize queue = _queue;
@synthesize delegate = _delegate;
@end
