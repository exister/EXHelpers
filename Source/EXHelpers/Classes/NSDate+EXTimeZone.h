#import <Foundation/Foundation.h>

@interface NSDate (EXTimeZone)
- (NSDate *)toGlobalTime;

+ (NSDate *)dateFromISO8601StringStrippingPrecision:(NSString *)iso8601;
- (NSDate *)toLocalTime;


@end