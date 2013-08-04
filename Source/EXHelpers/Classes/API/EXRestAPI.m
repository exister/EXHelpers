#import "EXRestAPI.h"
#import "EXRestAPIClient.h"
#import "AFNetworkActivityIndicatorManager.h"

#ifndef kEXRestApiBaseUrl
    #define kEXRestApiBaseUrl @"http://127.0.0.1:8000"
#endif


@interface EXRestAPI ()

@property (nonatomic, strong) EXRestAPIClient *client;

- (void)makeGETRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePOSTRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePUTRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makeDELETERequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePATCHRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;


@end


@implementation EXRestAPI

/**
* Singleton
*
* @return id
*/
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
#warning Check that base url is defined
        _client = [[EXRestAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kEXRestApiBaseUrl]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [_client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            DDLogInfo(@"Reachability status changed: %d", status);
            
            NSDictionary *data = @{@"status": [NSNumber numberWithInt:status]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kEXReachabilityChangedNotification object:nil userInfo:data];
        }];
    }
    return self;
}

/**
* Return network status
*/
- (AFNetworkReachabilityStatus)reachabilityStatus
{
    return self.client.networkReachabilityStatus;
}

/**
* Makes actual request
*
* Adds required parameters to each request.
*
* @param params GET-parameters
* @param delegate Delegate than will be notified upon request completion
*/
- (void)makeGETRequest:(NSString *)path
                params:(NSMutableDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                  owner:(id)owner
{
    [self.client getPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"EXRestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"EXRestAPI failed");
        failure(operation, error);
    }];
}

- (void)makePOSTRequest:(NSString *)path
                 params:(NSMutableDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                  owner:(id)owner
{
    DDLogInfo(@"POST %@: %@", path, params);
    [self.client postPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"EXRestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"EXRestAPI failed");
        failure(operation, error);
    }];
}

- (void)makePUTRequest:(NSString *)path
                params:(NSMutableDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                 owner:(id)owner
{
    DDLogInfo(@"PUT %@: %@", path, params);
    [self.client putPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"EXRestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"EXRestAPI failed");
        failure(operation, error);
    }];
}

- (void)makeDELETERequest:(NSString *)path
                   params:(NSMutableDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    owner:(id)owner
{
    [self.client deletePath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"EXRestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"EXRestAPI failed");
        failure(operation, error);
    }];
}

- (void)makePATCHRequest:(NSString *)path
                  params:(NSMutableDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                   owner:(id)owner
{
    [self.client patchPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"EXRestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"EXRestAPI failed");
        failure(operation, error);
    }];
}

/**
* Cancels all requests associated with given delegate
*/
- (void)cancelAllRequestsForDelegate:(id)delegate
{
    [self.client cancelAllOperationsForDelegate:delegate];
}

- (void)registerDeviceWithSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                 owner:(id)owner
{
    DDLogInfo(@"%@", THIS_METHOD);
    
    NSMutableDictionary *params = [@{} mutableCopy];
    [self makePOSTRequest:@"v1/device-registration/" params:params success:success failure:failure owner:owner];
}

- (void)registerPushToken:(NSString *)pushToken
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    owner:(id)owner
{
    DDLogInfo(@"%@", THIS_METHOD);
    
    NSMutableDictionary *params = [@{
        @"push_id": pushToken
    } mutableCopy];
    [self makePUTRequest:@"v1/device-register-push-token/" params:params success:success failure:failure owner:owner];
}

@end
