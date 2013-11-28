//
// Created by strelok on 28.11.13.
//


#import <Foundation/Foundation.h>

@protocol EXRestAPIClientProtocol
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
@property (readonly, nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
@end

@interface EXRestAPIHelper : NSObject
+ (void)setupFor:(id)client;

+ (void)setTimeOutForRequest:(NSMutableURLRequest *)request client:(id)client;
@end