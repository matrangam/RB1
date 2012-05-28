#import "CachingImageLoader.h"
#import <CommonCrypto/CommonDigest.h>


static NSString* const kImageKey            = @"image";
static NSString* const kBlocksKey           = @"blocks";
static NSString* const kCompletionBlockKey  = @"completionBlock";
static NSString* const kCancelledKey        = @"cancelled";


@implementation CachingImageLoader

- (void) dealloc
{
    dispatch_release(_queue), _queue = NULL;
    _backingImageLoader = nil;
    _infoByURL = nil;
    _diskPath = nil;
}

- (id) initWithBackingImageLoader:(id <ImageLoader>)backingImageLoader diskPath:(NSString*)diskPath
{
    NSAssert(backingImageLoader, @"wtf?");
    NSAssert(diskPath, @"wtf?");
    if (self = [super init]) {
        _diskPath = diskPath;
        _backingImageLoader = backingImageLoader;
        _infoByURL = [[NSMutableDictionary alloc] init];
        _queue = dispatch_queue_create("com.dmgctrl.R3.CachingImageLoader", NULL);
    }
    return self;
}

+ (NSString*) _cacheKeyForURL:(NSURL*)url
{
    const char* str = [url.absoluteString UTF8String];
    uint8_t r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

- (void) loadImageForURL:(NSURL*)url completionBlock:(void (^)(UIImage*, BOOL))block
{
    dispatch_sync(_queue, ^{
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

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSString* pathToCachedData = [[_diskPath stringByAppendingPathComponent:[CachingImageLoader _cacheKeyForURL:url]] stringByAppendingPathExtension:@"jpeg"];
                UIImage* image = [UIImage imageWithContentsOfFile:pathToCachedData];
                
                /* Force the image to be loaded now -- not lazily.
                 */
                [image CGImage];
                
                if (image) {
                    dispatch_async(_queue, ^{
                        [_infoByURL removeObjectForKey:url];
                        for (void (^block)(UIImage*, BOOL isFinal) in blocks) {
                            block(image, YES);
                        }
                    });
                } else {
                    dispatch_async(_queue, ^{
                        void (^completionBlock)(UIImage*, BOOL) = [^(UIImage* image, BOOL isFinal) {
                            dispatch_async(_queue, ^{
                                [info setObject:image forKey:kImageKey];
                                for (void (^block)(UIImage*, BOOL isFinal) in blocks) {
                                    block(image, isFinal);
                                }
                            });
                            if (isFinal) {
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                    NSData* bytes = UIImageJPEGRepresentation(image, 0.7);
                                    if (![bytes writeToFile:pathToCachedData atomically:YES]) {
                                        if ([[NSFileManager defaultManager] createDirectoryAtPath:[pathToCachedData stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL]) {
                                            [bytes writeToFile:pathToCachedData atomically:YES];
                                        }
                                    }
                                    dispatch_async(_queue, ^{
                                        [_infoByURL removeObjectForKey:url];
                                    });
                                });
                            }
                        } copy];
                        [info setObject:completionBlock forKey:kCompletionBlockKey];
                        [_backingImageLoader loadImageForURL:url completionBlock:completionBlock];
                    });
                }
            });
        }
    });
}

- (void) cancelCompletionBlock:(void (^)(UIImage*, BOOL))block forURL:(NSURL*)url
{
    dispatch_async(_queue, ^{
        NSMutableDictionary* info = [_infoByURL objectForKey:url];
        if (info) {
            NSMutableSet* blocks = [info objectForKey:kBlocksKey];
            [blocks removeObject:block];
            if (!blocks.count) {
                [info setObject:(id)kCFBooleanTrue forKey:kCancelledKey];
                [_backingImageLoader cancelCompletionBlock:[info objectForKey:kCompletionBlockKey] forURL:url];
                [_infoByURL removeObjectForKey:url];
            }
        }
    });
}

@end
