//
// Created by strelok on 28.11.13.
//


#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "EXJSONRequestSerializer.h"
#import "EXRegistrationHelper.h"


@implementation EXJSONRequestSerializer {

}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    [self setValue:[EXRegistrationHelper deviceId] forHTTPHeaderField:@"Device-ID"];
    [self setValue:[EXRegistrationHelper pushToken] forHTTPHeaderField:@"Push-ID"];

    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters];

    return request;
}


@end