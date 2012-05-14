

@interface URLCache : NSURLCache {
@private
    BOOL _diskCacheIsValid;
    NSString* diskCachePath;
    NSMutableDictionary* diskCacheInfo;
    BOOL diskCacheInfoDirty;
    NSUInteger diskCacheUsage;
    NSTimeInterval minCacheInterval;
    dispatch_source_t timer;
    dispatch_queue_t queue;
}

@property (nonatomic, assign) NSTimeInterval minCacheInterval;

@end