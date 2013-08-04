//
// Created by strelok on 01.07.13.
// Copyright (c) 2013 adwz. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIImage+EXImage.h"
#import "UIDevice+EXDevice.h"


@implementation UIImage (EXImage)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageNamed7:(NSString *)name {
    if (!IS_IOS7) {
        return [self imageNamed:name];
    }
    else {
        NSString *baseName = [name stringByDeletingPathExtension];
        NSString *ext = [name pathExtension];
        NSString *name7 = [NSString stringWithFormat:@"%@-ios7.%@", baseName, ext];
        UIImage *image = [self imageNamed:name7];
        if (image) {
            return image;
        }
        return [self imageNamed:name];
    }
}

@end