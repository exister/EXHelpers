#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "AFNetworking.h"

#define kEXReachabilityChangedNotification @"kEXReachabilityChangedNotification"

@class EXRestAPIClient;

@interface EXRestAPI : NSObject

@property (nonatomic, strong) EXRestAPIClient *client;

- (id)initWithClientClass:(NSString *)clientClass;

+ (NSString *)clientClass;

+ (id)sharedInstance;

- (void)makeGETRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePOSTRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePUTRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makeDELETERequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePATCHRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (AFNetworkReachabilityStatus)reachabilityStatus;

- (void)cancelAllRequestsForDelegate:(id)delegate;

- (void)registerDeviceWithSuccessBlock:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)registerPushToken:(NSString *)pushToken success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

@end