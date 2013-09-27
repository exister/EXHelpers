/** Collection of application-wide constants
 */

extern int const ddLogLevel;

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

/**
 * Rest API Configuration
 */
#ifndef kEXRestApiBaseUrl
    #define kEXRestApiBaseUrl @"http://127.0.0.1:8000/api"
#endif

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