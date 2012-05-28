#import "ThumbnailImageLoader.h"


static NSString* const kImageKey            = @"image";
static NSString* const kBlocksKey           = @"blocks";
static NSString* const kCompletionBlockKey  = @"completionBlock";


@implementation ThumbnailImageLoader

- (void) dealloc
{
    dispatch_release(_queue), _queue = NULL;
    _backingImageLoader = nil;
    _infoByURL = nil;
}

- (id) initWithBackingImageLoader:(id <ImageLoader>)backingImageLoader thumbnailSize:(CGFloat)thumbnailSize
{
    NSAssert(backingImageLoader, @"wtf?");
    NSAssert(thumbnailSize > 0.0, @"wtf?");
    if (self = [super init]) {
        _backingImageLoader = backingImageLoader;
        _thumbnailSize = thumbnailSize * [[UIScreen mainScreen] scale];
        _infoByURL = [[NSMutableDictionary alloc] init];
        _queue = dispatch_queue_create("com.dmgctrl.R3.ThumbnailImageLoader", NULL);
    }
    return self;
}

- (void) cancelCompletionBlock:(void (^)(UIImage*, BOOL))block forURL:(NSURL*)url
{
    dispatch_async(_queue, ^{
        NSMutableDictionary* info = [_infoByURL objectForKey:url];
        if (info) {
            NSMutableSet* blocks = [info objectForKey:kBlocksKey];
            [blocks removeObject:block];
            if (!blocks.count) {
                [_backingImageLoader cancelCompletionBlock:[info objectForKey:kCompletionBlockKey] forURL:url];
                [_infoByURL removeObjectForKey:url];
            }
        }
    });
}

- (void) loadImageForURL:(NSURL*)url completionBlock:(void (^)(UIImage*, BOOL))block
{
    dispatch_async(_queue, ^{
        NSMutableDictionary* info = [_infoByURL objectForKey:url];
        NSMutableSet* blocks = nil;
        if (info) {
            UIImage* image = [info objectForKey:kImageKey];
            if (block) {
                if (image) {
                    block(image, NO);
                }
                blocks = [info objectForKey:kBlocksKey];
                [blocks addObject:block];
            }
        } else if (block) {
            [_infoByURL setObject:info = [NSMutableDictionary dictionaryWithObjectsAndKeys:blocks = [NSMutableSet setWithObject:block], kBlocksKey, nil] forKey:url];
            void (^completionBlock)(UIImage*, BOOL) = [^(UIImage* image, BOOL isFinal) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    UIImage* thumbnailImage = nil;
                    if (image) {
                        CGImageRef cgimage = [image CGImage];
                        CGFloat width = CGImageGetWidth(cgimage);
                        CGFloat height = CGImageGetHeight(cgimage);
                        CGRect toRect;
                        if (width < height) {
                            toRect = CGRectMake(
                                0, 
                                0, 
                                (int)_thumbnailSize, 
                                (int)((_thumbnailSize / width) * height)
                            );
                        } else {
                            toRect = CGRectMake(
                                0, 
                                0, 
                                (int)((_thumbnailSize / height) * width), 
                                (int)_thumbnailSize
                            );
                        }
                        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
                        if (colorspace) {
                            CGContextRef c = CGBitmapContextCreate(NULL, toRect.size.width, toRect.size.height, 8, 4 * toRect.size.width, colorspace, kCGImageAlphaNoneSkipLast);
                            if (c) {
                                CGContextDrawImage(c, toRect, cgimage);
                                CGImageRef cgthumbnailImage = CGBitmapContextCreateImage(c);
                                if (cgthumbnailImage) {
                                    thumbnailImage = [UIImage imageWithCGImage:cgthumbnailImage];
                                    CFRelease(cgthumbnailImage);
                                }
                                CGContextRelease(c);
                            }
                            CGColorSpaceRelease(colorspace);
                        }
                    }
                    if (thumbnailImage) {
                        dispatch_async(_queue, ^{
                            [info setObject:thumbnailImage forKey:kImageKey];
                            if (isFinal) {
                                [_infoByURL removeObjectForKey:url];
                            }
                            for (void (^block)(UIImage*, BOOL isFinal) in blocks) {
                                block(thumbnailImage, isFinal);
                            }
                        });
                    } else if (isFinal) {
                        dispatch_async(_queue, ^{
                            [_infoByURL removeObjectForKey:url];
                        });
                    }
                });
            } copy];
            [info setObject:completionBlock forKey:kCompletionBlockKey];
            [_backingImageLoader loadImageForURL:url completionBlock:completionBlock];
        }
    });
}

@end
