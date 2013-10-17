#import "EXRestAPI.h"
#import "EXRestAPIClient.h"
#import "AFNetworkActivityIndicatorManager.h"

#ifndef kEXRestApiBaseUrl
    #define kEXRestApiBaseUrl @"http://127.0.0.1:8000"
#endif


@implementation EXRestAPI

+ (NSString *)clientClass {
    return @"EXRestAPIClient";
}

/**
* Singleton
*
* @return id
*/
+ (id)sharedInstance
{
    static id sharedInstance = nil;
    static NSMutableDictionary *_sharedInstances = nil;
    @synchronized(self) {
        if (_sharedInstances == nil) {
            _sharedInstances = [NSMutableDictionary dictionary];
        }
        NSString *instanceClass = NSStringFromClass(self);
        
        sharedInstance = [_sharedInstances objectForKey:instanceClass];
        if (sharedInstance == nil) {
            sharedInstance = [[[self class] alloc] initWithClientClass:[self clientClass]];
            [_sharedInstances setObject:sharedInstance forKey:instanceClass];
        }
    }
    
    return sharedInstance;
}

- (id)initWithClientClass:(NSString *)clientClass
{
    if (self = [super init]) {
#warning Check that base url is defined
        _client = [[NSClassFromString(clientClass) alloc] initWithBaseURL:[NSURL URLWithString:kEXRestApiBaseUrl]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [_client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
#ifdef DDLogInfo
            DDLogInfo(@"Reachability status changed: %d", status);
#else
            NSLog(@"Reachability status changed: %d", status);
#endif
            
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
#ifdef DDLogInfo
        DDLogInfo(@"EXRestAPI finished");
#else
        NSLog(@"EXRestAPI finished");
#endif
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
#ifdef DDLogInfo
        DDLogInfo(@"EXRestAPI finished");
#else
        NSLog(@"EXRestAPI finished");
#endif
        failure(operation, error);
    }];
}

- (void)makePOSTRequest:(NSString *)path
                 params:(NSMutableDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                  owner:(id)owner
{
#ifdef DDLogInfo
    DDLogInfo(@"POST %@: %@", path, params);
#else
    NSLog(@"POST %@: %@", path, params);
#endif
    [self.client postPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
#ifdef DDLogInfo
        DDLogInfo(@"EXRestAPI finished");
#else
        NSLog(@"EXRestAPI finished");
#endif
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
#ifdef DDLogError
        DDLogError(@"EXRestAPI failed");
#else
        NSLog(@"EXRestAPI failed");
#endif
        failure(operation, error);
    }];
}

- (void)makePUTRequest:(NSString *)path
                params:(NSMutableDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                 owner:(id)owner
{
#ifdef DDLogInfo
    DDLogInfo(@"PUT %@: %@", path, params);
#else
    NSLog(@"PUT %@: %@", path, params);
#endif
    [self.client putPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
#ifdef DDLogInfo
        DDLogInfo(@"EXRestAPI finished");
#else
        NSLog(@"EXRestAPI finished");
#endif
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
#ifdef DDLogError
        DDLogError(@"EXRestAPI failed");
#else
        NSLog(@"EXRestAPI failed");
#endif
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
#ifdef DDLogInfo
        DDLogInfo(@"EXRestAPI finished");
#else
        NSLog(@"EXRestAPI finished");
#endif
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
#ifdef DDLogError
        DDLogError(@"EXRestAPI failed");
#else
        NSLog(@"EXRestAPI failed");
#endif
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
#ifdef DDLogInfo
        DDLogInfo(@"EXRestAPI finished");
#else
        NSLog(@"EXRestAPI finished");
#endif
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
#ifdef DDLogError
        DDLogError(@"EXRestAPI failed");
#else
        NSLog(@"EXRestAPI failed");
#endif
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
#ifdef DDLogInfo
    DDLogInfo(@"%@", @"registerDeviceWithSuccessBlock");
#else
    NSLog(@"%@", @"registerDeviceWithSuccessBlock");
#endif
    
    NSMutableDictionary *params = [@{} mutableCopy];
    [self makePOSTRequest:@"v1/device-registration/" params:params success:success failure:failure owner:owner];
}

- (void)registerPushToken:(NSString *)pushToken
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    owner:(id)owner
{
#ifdef DDLogInfo
    DDLogInfo(@"%@", @"registerPushToken");
#else
    NSLog(@"%@", @"registerPushToken");
#endif
    
    NSMutableDictionary *params = [@{
        @"push_id": pushToken
    } mutableCopy];
    [self makePUTRequest:@"v1/device-register-push-token/" params:params success:success failure:failure owner:owner];
}

@end
