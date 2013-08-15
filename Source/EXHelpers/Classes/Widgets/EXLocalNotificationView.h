//
// Created by strelok on 11.07.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface EXLocalNotificationView : UIView
+ (instancetype)showNotice:(UIView *)notificationView inView:(UIView *)parentView;

+ (instancetype)showNotice:(UIView *)notificationView inView:(UIView *)parentView hideAfter:(NSTimeInterval)hideInterval;

+ (instancetype)showNotice:(UIView *)notificationView inView:(UIView *)parentView hideAfter:(NSTimeInterval)hideInterval offset:(float)offset;

+ (instancetype)showNotice:(UIView *)notificationView inView:(UIView *)parentView hideAfter:(NSTimeInterval)hideInterval offset:(float)offset delay:(NSTimeInterval)delayInterval;

+ (instancetype)showNotice:(UIView *)notificationView inView:(UIView *)parentView hideAfter:(NSTimeInterval)hideInterval offset:(float)offset delay:(NSTimeInterval)delayInterval response:(void (^)(void))response;

+ (void)hideCurrentNotificationView;

+ (void)hideCurrentNotificationViewAndClearQueue;
@end