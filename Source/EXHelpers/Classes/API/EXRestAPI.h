#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "AFNetworking.h"

#define kEXReachabilityChangedNotification @"kEXReachabilityChangedNotification"

@interface EXRestAPI : NSObject

+ (id)sharedInstance;

- (AFNetworkReachabilityStatus)reachabilityStatus;

- (void)cancelAllRequestsForDelegate:(id)delegate;

- (void)registerDeviceWithSuccessBlock:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)registerPushToken:(NSString *)pushToken success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

@end