//
// Created by strelok on 28.11.13.
//


#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@class EXRestAPISessionClient;


@interface EXSessionRestAPI : NSObject

@property (nonatomic, strong) EXRestAPISessionClient *client;

+ (NSString *)clientClass;

+ (NSString *)baseUrl;

+ (id)sharedInstance;

- (id)initWithClientClass:(NSString *)clientClass;

- (AFNetworkReachabilityStatus)reachabilityStatus;

- (void)makeGETRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure owner:(id)owner;

- (void)makePOSTRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure owner:(id)owner;

- (void)makePUTRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure owner:(id)owner;

- (void)makeDELETERequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure owner:(id)owner;

- (void)makePATCHRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure owner:(id)owner;

- (void)registerDeviceWithSuccessBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure owner:(id)owner;

- (void)registerPushToken:(NSString *)pushToken success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure owner:(id)owner;
@end