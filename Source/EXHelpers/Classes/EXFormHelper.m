//
// Created by strelok on 02.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AJNotificationView/AJNotificationView.h>
#import "EXFormHelper.h"


@implementation EXFormHelper {

}

+ (NSString *)convertNonFieldErrorsToString:(NSArray *)errors
{
    if (errors == nil) {
        return @"";
    }

    return [errors componentsJoinedByString:@"\n"];
}

+ (void)handleFormErrors:(AFHTTPRequestOperation *)operation fields:(NSDictionary *)fields defaultMessage:(NSString *)message view:(UIView *)view {
    if (operation.response.statusCode == 400) {
        id JSON = operation.responseObject;
        NSArray *nonFieldErrors = JSON[@"non_field_errors"];
        if (nonFieldErrors != nil) {
            [AJNotificationView showNoticeInView:view.window
                                            type:AJNotificationTypeRed
                                           title:[self convertNonFieldErrorsToString:nonFieldErrors]
                                 linedBackground:AJLinedBackgroundTypeDisabled
                                       hideAfter:2.5f];
            return;
        }
        else {
            [JSON enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (fields[key] != nil) {
                    UITextField *editView = fields[key][@"field"];
                    if ([editView respondsToSelector:@selector(setError:)]) {
                        [editView performSelector:@selector(setError:) withObject:[self convertNonFieldErrorsToString:obj]];
                    }
                }
            }];
            return;
        }
    }
    [self handleFailure:operation message:message view:view];
}

+ (void)handleFailure:(AFHTTPRequestOperation *)operation message:(NSString *)message view:(UIView *)view {
    if (operation.response.statusCode == 401) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEXUnauthorizedFormErrorNotification object:nil];
    }
    else {
        [self showNetworkError:operation message:message view:view];
    }
}

+ (void)showNetworkError:(AFHTTPRequestOperation *)operation message:(NSString *)message view:(UIView *)view {
    if (operation != nil) {
        if (operation.response.statusCode >= 500) {
            message = NSLocalizedString(@"kEXNetworkErrorMessage", nil);
        }
    }

    [AJNotificationView showNoticeInView:view.window
                                    type:AJNotificationTypeRed
                                   title:message
                         linedBackground:AJLinedBackgroundTypeDisabled
                               hideAfter:2.5f];
}

@end