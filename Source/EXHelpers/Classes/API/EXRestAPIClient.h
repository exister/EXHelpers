#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "EXRestAPIHelper.h"

@class AFHTTPRequestOperation;

@interface EXRestAPIClient : AFHTTPRequestOperationManager <EXRestAPIClientProtocol>

- (NSTimeInterval)onlineTimeout;

- (NSTimeInterval)offlineTimeout;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters;

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

- (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters delegate:(id)delegate success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString parameters:(NSDictionary *)parameters delegate:(id)delegate success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters delegate:(id)delegate success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters delegate:(id)delegate constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters delegate:(id)delegate success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString parameters:(NSDictionary *)parameters delegate:(id)delegate success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters delegate:(id)delegate success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)cancelAllOperationsForDelegate:(id)delegate;

@end
