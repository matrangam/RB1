#import "URLCache.h"
#import <CommonCrypto/CommonDigest.h>


static NSTimeInterval const kURLCacheInfoDefaultMinCacheInterval = 5 * 60; // 5 minute
static NSString* const kURLCacheInfoFileName        = @"cacheInfo.plist";
static NSString* const kURLCacheInfoDiskUsageKey    = @"diskUsage";
static NSString* const kURLCacheInfoAccessesKey     = @"accesses";
static NSString* const kURLCacheInfoSizesKey        = @"sizes";


@interface URLCache ()
@property (nonatomic, strong) NSString* diskCachePath;
@property (unsafe_unretained, nonatomic, readonly) NSMutableDictionary* diskCacheInfo;
- (void) saveCacheInfo;
- (void) balanceDiskUsage;
@end


@implementation URLCache

@synthesize diskCachePath;
@synthesize minCacheInterval;
@dynamic diskCacheInfo;

- (void) dealloc
{
    diskCacheInfo = nil;
    if (timer) {
        dispatch_source_cancel(timer);
        dispatch_release(timer), timer = nil;
    }
    if (queue) {
        dispatch_release(queue), queue = nil;
    }
}

+ (NSString*) _cacheKeyForURL:(NSURL*)url
{
    const char* str = [url.absoluteString UTF8String];
    uint8_t r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

+ (NSDate*) _expirationDateFromHeaders:(NSDictionary*)headers
{
    NSString* pragma = [headers objectForKey:@"Pragma"];
    if (pragma && [pragma isEqualToString:@"no-cache"]) {
        return nil;
    }
    
    NSString* cacheControl = [headers objectForKey:@"Cache-Control"];
    if (cacheControl) {
        NSRange foundRange = [cacheControl rangeOfString:@"no-cache"];
        if (foundRange.length > 0) {
            return nil;
        }
        
        NSInteger maxAge;
        foundRange = [cacheControl rangeOfString:@"max-age="];
        if (foundRange.length > 0) {
            NSScanner* cacheControlScanner = [NSScanner scannerWithString:cacheControl];
            [cacheControlScanner setScanLocation:foundRange.location + foundRange.length];
            if ([cacheControlScanner scanInteger:&maxAge]) {
                if (maxAge > 0) {
                    return [NSDate dateWithTimeIntervalSinceNow:maxAge];
                } else {
                    return nil;
                }
            }
        }
    }
    
    NSString* expires = [headers objectForKey:@"Expires"];
    if (expires) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, MMM d, yyyy, h:mm a"];
        NSDate* expirationDate = [dateFormatter dateFromString:expires];
        if ([expirationDate timeIntervalSinceNow] < 0) {
            return nil;
        } else {
            return expirationDate;
        }
    }
    
    return nil;
}


#pragma mark -


- (NSMutableDictionary*) diskCacheInfo
{
    NSAssert(queue == dispatch_get_current_queue(), @"");
    if (!diskCacheInfo) {
        diskCacheInfo = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[diskCachePath stringByAppendingPathComponent:kURLCacheInfoFileName]] mutabilityOption:NSPropertyListMutableContainers format:NULL errorDescription:NULL];
        if (!diskCacheInfo) {
            diskCacheInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                [NSNumber numberWithUnsignedInt:0], kURLCacheInfoDiskUsageKey,
                [NSMutableDictionary dictionary], kURLCacheInfoAccessesKey,
                [NSMutableDictionary dictionary], kURLCacheInfoSizesKey,
                nil
            ];
        }
        diskCacheInfoDirty = NO;
        
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        if (timer) {
            dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 5 * 60 * 1000000000LL, 1000000000LL);
            dispatch_set_target_queue(timer, queue);
            dispatch_source_set_event_handler(timer, ^{
                if (diskCacheUsage > self.diskCapacity) {
                    [self balanceDiskUsage];
                    [self saveCacheInfo];
                } else if (diskCacheInfoDirty) {
                    [self saveCacheInfo];
                }
            });
            dispatch_resume(timer);
        }
    }
    return diskCacheInfo;
}

- (void) createDiskCachePath
{
    if (!_diskCacheIsValid) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:diskCachePath]) {
            [fileManager createDirectoryAtPath:diskCachePath
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:NULL];
        }
        _diskCacheIsValid = YES;
    }
}

- (void) saveCacheInfo
{
    dispatch_async(queue, ^{ 
        [self createDiskCachePath];
        [[NSPropertyListSerialization dataWithPropertyList:self.diskCacheInfo format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL] writeToFile:[diskCachePath stringByAppendingPathComponent:kURLCacheInfoFileName] atomically:YES];
    });
}

- (void) removeCachedResponseForCachedKeys:(NSArray*)cacheKeys
{
    @autoreleasepool {
    
        NSMutableDictionary* accesses = [self.diskCacheInfo objectForKey:kURLCacheInfoAccessesKey];
        NSMutableDictionary* sizes = [self.diskCacheInfo objectForKey:kURLCacheInfoSizesKey];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        for (NSString* cacheKey in cacheKeys) {
            NSUInteger cacheItemSize = [[sizes objectForKey:cacheKey] unsignedIntegerValue];
            [accesses removeObjectForKey:cacheKey];
            [sizes removeObjectForKey:cacheKey];
            [fileManager removeItemAtPath:[diskCachePath stringByAppendingPathComponent:cacheKey] error:NULL];
            [fileManager removeItemAtPath:[diskCachePath stringByAppendingPathComponent:[cacheKey stringByAppendingPathExtension:@"data"]] error:NULL];
            diskCacheUsage -= cacheItemSize;
            diskCacheInfoDirty = YES;
        }
        if (diskCacheInfoDirty) {
            [self.diskCacheInfo setObject:[NSNumber numberWithUnsignedInteger:diskCacheUsage] forKey:kURLCacheInfoDiskUsageKey];
        }

    }
}

- (void) balanceDiskUsage
{
    if (diskCacheUsage >= self.diskCapacity) {
        NSMutableArray* keysToRemove = nil;
        NSDictionary* sizes = [self.diskCacheInfo objectForKey:kURLCacheInfoSizesKey];
        NSInteger capacityToSave = diskCacheUsage - self.diskCapacity;
        for (NSString* cacheKey in [[self.diskCacheInfo objectForKey:kURLCacheInfoAccessesKey] keysSortedByValueUsingSelector:@selector(compare:)]) {
            if (!keysToRemove) {
                keysToRemove = [NSMutableArray array];
            }
            [keysToRemove addObject:cacheKey];
            capacityToSave -= [[sizes objectForKey:cacheKey] unsignedIntegerValue];
            if (capacityToSave < 0) {
                break;
            }
        }
        if (keysToRemove) {
            [self removeCachedResponseForCachedKeys:keysToRemove];
        }
    }
}


#pragma mark -


- (id) initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString*)path
{
    if ((self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path])) {
        self.minCacheInterval = kURLCacheInfoDefaultMinCacheInterval;
        self.diskCachePath = path;
        queue = dispatch_queue_create("", NULL);
    }
    
    return self;
}

- (void) storeCachedResponse:(NSCachedURLResponse*)cachedResponse forRequest:(NSURLRequest*)request
{
    if (request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData
        || request.cachePolicy == NSURLRequestReloadIgnoringLocalAndRemoteCacheData
        || request.cachePolicy == NSURLRequestReloadIgnoringCacheData)
    {
        // When cache is ignored for read, it's a good idea not to store the result as well as this option
        // have big chance to be used every times in the future for the same request.
        // NOTE: This is a change regarding default URLCache behavior
        return;
    }
    
    [super storeCachedResponse:cachedResponse forRequest:request];
    
    if (cachedResponse.storagePolicy == NSURLCacheStorageAllowed
        && [cachedResponse.response isKindOfClass:[NSHTTPURLResponse self]]
        && cachedResponse.data.length < self.diskCapacity)
    {
        NSDate* expirationDate = [URLCache _expirationDateFromHeaders:[(NSHTTPURLResponse*)cachedResponse.response allHeaderFields]];
        if (!expirationDate || [expirationDate timeIntervalSinceNow] - minCacheInterval <= 0) {
            // This response is not cacheable, headers said
            return;
        }
        
        dispatch_async(queue, ^{
            NSString* cacheKey = [URLCache _cacheKeyForURL:request.URL];
            NSString* cacheFilePath = [diskCachePath stringByAppendingPathComponent:cacheKey];
            
            [self createDiskCachePath];
            
            if (![NSKeyedArchiver archiveRootObject:cachedResponse.response toFile:cacheFilePath]) {
                return;
            }
            if (![cachedResponse.data writeToFile:[cacheFilePath stringByAppendingPathExtension:@"data"] atomically:NO]) {
                return;
            }
            
            NSNumber* cacheItemSize = [NSNumber numberWithUnsignedInteger:cachedResponse.data.length];
            diskCacheUsage += [cacheItemSize unsignedIntegerValue];
            NSMutableDictionary* _diskCacheInfo = self.diskCacheInfo;
            [_diskCacheInfo setObject:[NSNumber numberWithUnsignedInteger:diskCacheUsage] forKey:kURLCacheInfoDiskUsageKey];
            [[_diskCacheInfo objectForKey:kURLCacheInfoAccessesKey] setObject:[NSDate date] forKey:cacheKey];
            [[_diskCacheInfo objectForKey:kURLCacheInfoSizesKey] setObject:cacheItemSize forKey:cacheKey];
            
            [self saveCacheInfo];
        });
    }
}

- (NSCachedURLResponse*) cachedResponseForRequest:(NSURLRequest*)request
{
    NSCachedURLResponse* memoryResponse = [super cachedResponseForRequest:request];
    if (memoryResponse) {
        return memoryResponse;
    }
    NSString* cacheKey = [URLCache _cacheKeyForURL:request.URL];
    __block NSCachedURLResponse* response = nil;
    dispatch_sync(queue, ^{ 
        NSMutableDictionary* accesses = [self.diskCacheInfo objectForKey:kURLCacheInfoAccessesKey];
        if ([accesses objectForKey:cacheKey]) {
            NSString* cacheFilePath = [diskCachePath stringByAppendingPathComponent:cacheKey];
            NSURLResponse* diskResponse = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheFilePath];
            if (diskResponse) {
                [accesses setObject:[NSDate date] forKey:cacheKey];
                diskCacheInfoDirty = YES;
                response = [[NSCachedURLResponse alloc] initWithResponse:diskResponse data:[NSData dataWithContentsOfFile:[cacheFilePath stringByAppendingPathExtension:@"data"]]];
            }
        }
    });
    if (response) {
        [super storeCachedResponse:response forRequest:request];
    }
    return response;
}

- (NSUInteger) currentDiskUsage
{
    return diskCacheUsage;
}

- (void) removeCachedResponseForRequest:(NSURLRequest*)request
{
    dispatch_async(queue, ^{
        [super removeCachedResponseForRequest:request];
        [self removeCachedResponseForCachedKeys:[NSArray arrayWithObject:[URLCache _cacheKeyForURL:request.URL]]];
        [self saveCacheInfo];
    });
}

- (void) removeAllCachedResponses
{
    [super removeAllCachedResponses];
}

@end