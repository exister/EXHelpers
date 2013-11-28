//
// Created by strelok on 28.11.13.
//
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "EXRestAPIHelper.h"
#import "EXJSONRequestSerializer.h"
#import "EXRegistrationHelper.h"


@implementation EXRestAPIHelper {

}

+ (void)setupFor:(id)client {
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    NSString *applicationVersion = (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSString *screenSize = [NSString stringWithFormat:@"%dx%d", (NSInteger)([UIScreen mainScreen].bounds.size.width * scale), (NSInteger)([UIScreen mainScreen].bounds.size.height * scale)];

    ((id <EXRestAPIClientProtocol>)client).requestSerializer = [EXJSONRequestSerializer serializer];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:[EXRegistrationHelper deviceId] forHTTPHeaderField:@"Device-ID"];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:[EXRegistrationHelper pushToken] forHTTPHeaderField:@"Push-ID"];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:@"iOS" forHTTPHeaderField:@"Device-OS"];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"Device-OS-Version"];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:[[UIDevice currentDevice] model] forHTTPHeaderField:@"Device-Model"];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:screenSize forHTTPHeaderField:@"Device-Screen-Size"];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:applicationName forHTTPHeaderField:@"Application"];
    [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:applicationVersion forHTTPHeaderField:@"Application-Version"];

    if ([EXRegistrationHelper authToken]) {
        [((id <EXRestAPIClientProtocol>)client).requestSerializer setValue:[NSString stringWithFormat:@"Token %@", [EXRegistrationHelper authToken]] forHTTPHeaderField:@"Authorization"];
    }
}

+ (void)setTimeOutForRequest:(NSMutableURLRequest *)request client:(id)client {
    if (((id <EXRestAPIClientProtocol>)client).reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [request setTimeoutInterval:((id <EXRestAPIClientProtocol>)client).onlineTimeout];
    }
    else {
        [request setTimeoutInterval:((id <EXRestAPIClientProtocol>)client).offlineTimeout];
    }
}

@end