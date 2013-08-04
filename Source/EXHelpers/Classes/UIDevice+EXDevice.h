#import <UIKit/UIKit.h>

#define IS_IOS7 ([UIDevice deviceSystemMajorVersion] >= 7)

@interface UIDevice (EXDevice)

+ (NSInteger)deviceSystemMajorVersion;
@end
