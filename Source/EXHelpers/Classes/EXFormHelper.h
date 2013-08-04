//
// Created by strelok on 02.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define kEXUnauthorizedFormErrorNotification @"kEXUnauthorizedFormErrorNotification"

@interface EXFormHelper : NSObject
+ (NSString *)convertNonFieldErrorsToString:(NSArray *)errors;

+ (void)handleFormErrors:(AFHTTPRequestOperation *)operation fields:(NSDictionary *)fields defaultMessage:(NSString *)message view:(UIView *)view;

+ (void)handleFailure:(AFHTTPRequestOperation *)operation message:(NSString *)message view:(UIView *)view;

+ (void)showNetworkError:(AFHTTPRequestOperation *)operation message:(NSString *)message view:(UIView *)view;
@end