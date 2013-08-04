//
//  EXRegistrationHelper.m
//  EXHelpers
//
//  Created by Mikhail Kuznetsov on 04.08.13.
//
//

/** Collection of methods to work with registration related tasks
 */

#import "SSKeychain.h"
#import "NSString+SSToolkitAdditions.h"
#import "EXRegistrationHelper.h"
#import "EXFormHelper.h"

#define kEXAuthTokenAccount @"auth_token"
#define kEXDeviceIdAccount @"device_id"
#define kEXUDPushToken @"kEXUDPushToken"
#define kEXUDDeviceRegistered @"kEXUDDeviceRegistered"

@implementation EXRegistrationHelper

static NSString *cachedDeviceId = nil;
static NSString *cachedAuthToken = nil;
static NSString *cachedPushToken = nil;
static NSNumber *cachedDeviceRegistered = nil;

+ (id)sharedInstance
{
    static EXRegistrationHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle401:) name:kEXUnauthorizedFormErrorNotification object:nil];
}

- (void)handle401:(NSNotification *)notification {
    [[self class] setAuthToken:nil];
}

+ (NSString *)keychainServiceName {
#warning Override in your project
    return @"EXkeychainServiceName";
}

+ (NSString *)authToken
{
    if (cachedAuthToken == nil) {
        cachedAuthToken = [SSKeychain passwordForService:[self keychainServiceName] account:kEXAuthTokenAccount];
    }
    return cachedAuthToken;
}

+ (void)setAuthToken:(NSString *)token
{
    cachedAuthToken = token;
    [SSKeychain setPassword:token forService:[self keychainServiceName] account:kEXAuthTokenAccount];
}

+ (NSString *)deviceId
{
    if (cachedDeviceId == nil) {
        cachedDeviceId = [SSKeychain passwordForService:[self keychainServiceName] account:kEXDeviceIdAccount];
    }
    return cachedDeviceId;
}

+ (void)setDeviceId:(NSString *)deviceID
{
    cachedDeviceId = deviceID;
    [SSKeychain setPassword:deviceID forService:[self keychainServiceName] account:kEXDeviceIdAccount];
}

+ (BOOL)isAuthenticated
{
    return cachedAuthToken != nil;
}

+ (NSString *)pushToken
{
    if (cachedPushToken == nil) {
        cachedPushToken = [[NSUserDefaults standardUserDefaults] stringForKey:kEXUDPushToken];
        if (cachedPushToken == nil) {
            cachedPushToken = @"";
        }
    }
    return cachedPushToken;
}

+ (void)setPushToken:(NSString *)pushToken {
    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:kEXUDPushToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (pushToken == nil) {
        cachedPushToken = @"";
    }
    else {
        cachedPushToken = pushToken;
    }
}

+ (BOOL)deviceRegistered
{
    if (cachedDeviceRegistered == nil) {
        cachedDeviceRegistered = [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] boolForKey:kEXUDDeviceRegistered]];
    }
    return [cachedDeviceRegistered boolValue];
}

+ (void)setDeviceRegistered:(BOOL)registered
{
    cachedDeviceRegistered = [NSNumber numberWithBool:registered];
    [[NSUserDefaults standardUserDefaults] setBool:registered forKey:kEXUDDeviceRegistered];
}

@end
