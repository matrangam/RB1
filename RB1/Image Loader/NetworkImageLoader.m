#import "NetworkImageLoader.h"
#import "IncrementalImageAdapter.h"


static NSString* const kImageKey    = @"image";
static NSString* const kBlocksKey   = @"blocks";
static NSString* const kQueryKey    = @"query";

@interface NetworkImageLoader () <IncrementalImageAdapterDelegate>
@end



#pragma mark -
@implementation NetworkImageLoader


+ (NetworkImageLoader*) sharedImageLoader
{
    static NetworkImageLoader* instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[NetworkImageLoader alloc] init]; 
    });
    return instance;
}

- (void) dealloc
{
    dispatch_release(_queue), _queue = NULL;
    _infoByURL = nil;
}

- (id) init
{
    if (self = [super init]) {
        _infoByURL = [[NSMutableDictionary alloc] init];
        _queue = dispatch_queue_create("com.dmgctrl.R3.NetworkImageLoader", NULL);
    }
    return self;
}


#pragma mark -

- (void) cancelCompletionBlock:(void (^)(UIImage*, BOOL))block forURL:(NSURL*)url
{
    dispatch_async(_queue, ^{
        NSMutableDictionary* info = [_infoByURL objectForKey:url];
        if (info) {
            NSMutableSet* blocks = [info objectForKey:kBlocksKey];
            [blocks removeObject:block];
            if (!blocks.count) {
                [[info objectForKey:kQueryKey] cancel];
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
            IncrementalImageAdapter* imageAdapter = [[IncrementalImageAdapter alloc] initWithQueue:_queue imageAdapterDelegate:self];
            Query* query = [Query queryWithURL:url delegate:imageAdapter startImmediately:NO];
            [_infoByURL setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableSet setWithObject:block], kBlocksKey, query, kQueryKey, nil] forKey:url];
            [query start];
        }
    });
}

- (void) incrementalImageAdapter:(IncrementalImageAdapter*)adapter didUpdateImage:(UIImage*)image forURL:(NSURL*)url isFinal:(BOOL)isFinal
{
    NSMutableDictionary* info = [_infoByURL objectForKey:url];
    if (info) {
        [info setObject:image forKey:kImageKey];
        NSMutableSet* blocks = [info objectForKey:kBlocksKey];
        if (isFinal) {
            [info removeObjectForKey:kBlocksKey];
            [_infoByURL removeObjectForKey:url];
        }
        for (void (^block)(UIImage*, BOOL isFinal) in blocks) {
            block(image, isFinal);
        }
    }
}

- (void) incrementalImageAdapter:(IncrementalImageAdapter*)adapter didFailWithError:(NSError*)error forURL:(NSURL*)url 
{
    NSMutableDictionary* info = [_infoByURL objectForKey:url];
    if (info) {
        NSMutableSet* blocks = [info objectForKey:kBlocksKey];
        [_infoByURL removeObjectForKey:url];
        for (void (^block)(UIImage*, BOOL isFinal) in blocks) {
            block(nil, YES);
        }
    }
}

@end