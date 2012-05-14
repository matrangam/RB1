@class Query;

@interface QueryManager : NSObject {
    int _maxConcurrent;
    int _retryCount;
    NSMutableArray* _active;
    NSMutableArray* _backlog;
    NSThread* _thread;
}

@property (nonatomic, assign) int maxConcurrent;
@property (nonatomic, readonly) int retryCount;

+ (QueryManager*) sharedQueryManager;

- (void) cancelAll;

@end
