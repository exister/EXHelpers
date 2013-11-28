/** Collection of application-wide constants
 */

/**
 * TestFlight
 */
#define kEXTestFlightAppToken @""

/**
 * JIRA
 */
#define kEXJIRAHost @""
#define kEXJIRAProject @"__TESTING__"
#define kEXJIRAApiKey @""

/**
 * HockeyApp
 */
#define kEXHockeyAppApiKeyBeta @""
#define kEXHockeyAppApiKeyLive @""

/**
 * Notifications
 */

#define kEXReachabilityChanged @"kEXReachabilityChanged"
#define kEXRegisteredForRemoteNotifications @"kEXRegisteredForRemoteNotifications"
#define kEXSplashScreenJobDoneNotification @"kEXSplashScreenJobDoneNotification"
#define kEXSplashScreenAllJobsDoneNotification @"kEXSplashScreenAllJobsDoneNotification"
#define kEXSplashScreenFinished @"kEXSplashScreenFinished"
#define kEXDeviceRegisteredNotification @"kEXDeviceRegisteredNotification"


#define kEXNetworkUnreachableStatus @"kEXNetworkUnreachableStatus"
#define kEXNetworkReachableViaWWANStatus @"kEXNetworkReachableViaWWANStatus"
#define kEXNetworkReachableViaWiFiStatus @"kEXNetworkReachableViaWiFiStatus"

typedef enum {
    EXNetworkUnknownStatus = -1,
    EXNetworkUnreachableStatus = 0,
    EXNetworkReachableViaWWANStatus = 1,
    EXNetworkReachableViaWiFiStatus = 2,
} EXNetworkReachabilityStatus;


/**
 * Messages
 */
#define kEXMessageServerError @"Проблемы с соединением"