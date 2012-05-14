@class Query;
@class QueryManager;

extern NSString* const kQueryStartNotification;
extern NSString* const kQueryCompleteNotification;


@protocol QueryDelegate <NSObject>
@optional
- (void) query:(Query*)query didReceiveResponse:(NSURLResponse*)response;
- (void) query:(Query*)query didReceiveData:(NSData*)data;
- (void) query:(Query*)query didFailWithError:(NSError*)error;
- (void) queryDidFinishLoading:(Query*)query;
- (NSURLRequest*) query:(Query*)query willSendRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)redirectResponse;

@end


@interface Query : NSObject {
@private
    int32_t _started;
    int32_t _cancelled;
    int32_t _finished;
    NSURLRequest* _request;
    /**/
    QueryManager* _queryManager;
    dispatch_queue_t _queue;
    id<QueryDelegate> _delegate;
}

@property (readonly, nonatomic) BOOL started;
@property (readonly, nonatomic) BOOL cancelled;
@property (nonatomic) BOOL didReceiveData;
@property (readonly, nonatomic) NSURLRequest* request;
/**/
@property (nonatomic, strong) QueryManager* queryManager;
@property (nonatomic, assign) dispatch_queue_t queue;
@property (nonatomic, strong) id<QueryDelegate> delegate;

+ (id) queryWithURL:(NSURL*)url delegate:(id)delegate startImmediately:(BOOL)startImmediately;
+ (id) queryWithRequest:(NSURLRequest*)request queue:(dispatch_queue_t)queue delegate:(id)delegate startImmediately:(BOOL)startImmediately;

- (id) initWithRequest:(NSURLRequest*)request;

- (void) start;
- (void) cancel;

@end
