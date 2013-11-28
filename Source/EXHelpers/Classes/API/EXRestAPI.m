#import "EXRestAPI.h"
#import "EXRestAPIClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "LogConfig.h"


@implementation EXRestAPI

+ (NSString *)clientClass {
    return @"EXRestAPIClient";
}

+ (NSString *)baseUrl {
    return @"http://127.0.0.1:8000";
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
        NSURL *baseUrl = [NSURL URLWithString:[[self class] baseUrl]];

        _client = [[NSClassFromString(clientClass) alloc] initWithBaseURL:baseUrl];

        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

        [_client.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            DDLogInfo(@"(%@, %d, %@): Reachability status changed: %d", THIS_FILE, __LINE__, THIS_METHOD, status);

            NSDictionary *data = @{@"status": [NSNumber numberWithInt:status], @"baseUrl": baseUrl};

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
    return self.client.reachabilityManager.networkReachabilityStatus;
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
    DDLogInfo(@"(%@, %d, %@): ", THIS_FILE, __LINE__, THIS_METHOD);

    [self.client GET:path parameters:params delegate:owner success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI GET %@ finished", THIS_FILE, __LINE__, THIS_METHOD, path);
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI GET %@ failed", THIS_FILE, __LINE__, THIS_METHOD, path);
        failure(operation, error);
    }];
}

- (void)makePOSTRequest:(NSString *)path
                 params:(NSMutableDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                  owner:(id)owner
{
    DDLogInfo(@"(%@, %d, %@): ", THIS_FILE, __LINE__, THIS_METHOD);

    [self.client POST:path parameters:params delegate:owner success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI POST %@ finished", THIS_FILE, __LINE__, THIS_METHOD, path);
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI POST %@ failed", THIS_FILE, __LINE__, THIS_METHOD, path);
        failure(operation, error);
    }];
}

- (void)makePUTRequest:(NSString *)path
                params:(NSMutableDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                 owner:(id)owner
{
    DDLogInfo(@"(%@, %d, %@): ", THIS_FILE, __LINE__, THIS_METHOD);

    [self.client PUT:path parameters:params delegate:owner success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI PUT %@ finished", THIS_FILE, __LINE__, THIS_METHOD, path);
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI PUT %@ failed", THIS_FILE, __LINE__, THIS_METHOD, path);
        failure(operation, error);
    }];
}

- (void)makeDELETERequest:(NSString *)path
                   params:(NSMutableDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    owner:(id)owner
{
    DDLogInfo(@"(%@, %d, %@): ", THIS_FILE, __LINE__, THIS_METHOD);

    [self.client DELETE:path parameters:params delegate:owner success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI DELETE %@ finished", THIS_FILE, __LINE__, THIS_METHOD, path);
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI DELETE %@ failed", THIS_FILE, __LINE__, THIS_METHOD, path);
        failure(operation, error);
    }];
}

- (void)makePATCHRequest:(NSString *)path
                  params:(NSMutableDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                   owner:(id)owner
{
    DDLogInfo(@"(%@, %d, %@): ", THIS_FILE, __LINE__, THIS_METHOD);

    [self.client PATCH:path parameters:params delegate:owner success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI PATCH %@ finished", THIS_FILE, __LINE__, THIS_METHOD, path);
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogInfo(@"(%@, %d, %@): EXRestAPI PATCH %@ failed", THIS_FILE, __LINE__, THIS_METHOD, path);
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
    DDLogInfo(@"(%@, %d, %@): ", THIS_FILE, __LINE__, THIS_METHOD);

    NSMutableDictionary *params = [@{} mutableCopy];
    [self makePOSTRequest:@"v1/device-registration/" params:params success:success failure:failure owner:owner];
}

- (void)registerPushToken:(NSString *)pushToken
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    owner:(id)owner
{
    DDLogInfo(@"(%@, %d, %@): ", THIS_FILE, __LINE__, THIS_METHOD);
    
    NSMutableDictionary *params = [@{
        @"push_id": pushToken
    } mutableCopy];
    [self makePUTRequest:@"v1/device-register-push-token/" params:params success:success failure:failure owner:owner];
}

@end
