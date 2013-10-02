//
//  EXRegistrationHelper.h
//  EXHelpers
//
//  Created by Mikhail Kuznetsov on 04.08.13.
//
//

#import <UIKit/UIKit.h>

@interface EXRegistrationHelper : NSObject

+ (id)sharedInstance;

- (void)startObserving;

+ (NSString *)keychainServiceName;

+ (NSString *)authToken;

+ (void)setAuthToken:(NSString *)token;

+ (NSString *)deviceId;

+ (void)setDeviceId:(NSString *)deviceID;

+ (BOOL)isAuthenticated;

+ (NSString *)pushToken;

+ (void)setPushToken:(NSString *)pushToken;

+ (BOOL)deviceRegistered;

+ (void)setDeviceRegistered:(BOOL)registered;

@end
