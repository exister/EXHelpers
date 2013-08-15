#import "EXLocalNotificationView.h"
#import <QuartzCore/QuartzCore.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface EXLocalNotificationView ()

@property (nonatomic, assign) float moveFactor;
@property (nonatomic, copy) void (^responseBlock)(void);
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) float offset;
@property (nonatomic, assign) NSTimeInterval hideInterval;

- (id)initWithFrame:(CGRect)frame andResponseBlock:(void (^)(void))response;

- (void)_drawBackgroundInRect:(CGRect)rect;
- (void) showAfterDelay:(NSTimeInterval)delayInterval;

- (void)hide;
@end

#define PANELHEIGHT  50.0f

static NSMutableArray *notificationQueue = nil;       // Global notification queue

@implementation EXLocalNotificationView

////////////////////////////////////////////////////////////////////////
#pragma mark - View LifeCycle
////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andResponseBlock:nil];
}

- (id)initWithFrame:(CGRect)frame andResponseBlock:(void (^)(void))response
{
    self = [super initWithFrame:frame];
    if (self) {
        self.responseBlock = response;
    }
    return self;
}

+ (instancetype)showNotice:(UIView *)notificationView
                      inView:(UIView *)parentView {
    return [self showNotice:notificationView inView:parentView hideAfter:2.5f];
}

+ (instancetype)showNotice:(UIView *)notificationView
                    inView:(UIView *)parentView
                 hideAfter:(NSTimeInterval)hideInterval {
    return [self showNotice:notificationView inView:parentView hideAfter:hideInterval offset:0.0];
}

+ (instancetype)showNotice:(UIView *)notificationView
                    inView:(UIView *)parentView
                 hideAfter:(NSTimeInterval)hideInterval
                    offset:(float)offset {
    return [self showNotice:notificationView inView:parentView hideAfter:hideInterval offset:offset delay:0.0];
}

+ (instancetype)showNotice:(UIView *)notificationView
                    inView:(UIView *)parentView
                 hideAfter:(NSTimeInterval)hideInterval
                    offset:(float)offset
                     delay:(NSTimeInterval)delayInterval {
    return [self showNotice:notificationView inView:parentView hideAfter:hideInterval offset:offset height:PANELHEIGHT delay:delayInterval response:nil];
}

+ (instancetype)showNotice:(UIView *)notificationView
                    inView:(UIView *)parentView
                 hideAfter:(NSTimeInterval)hideInterval
                    offset:(float)offset
                    height:(float)height
                     delay:(NSTimeInterval)delayInterval
                  response:(void (^)(void))response {
    EXLocalNotificationView *noticeView = [[self alloc] initWithFrame:CGRectMake(0.0, -height + offset, parentView.bounds.size.width, height) andResponseBlock:response];
    noticeView.backgroundColor = [UIColor clearColor];

    noticeView.contentView = notificationView;
    noticeView.contentView.alpha = 0.0;
    [noticeView addSubview:noticeView.contentView];

    noticeView.parentView = parentView;
    noticeView.offset = offset;
    noticeView.hideInterval = hideInterval;

    if(notificationQueue == nil) {
        notificationQueue = [[NSMutableArray alloc] init];
    }

    [notificationQueue addObject:noticeView];

    if([notificationQueue count] == 1) {
        // Since this notification is the only one in the queue, it can be shown and its delay interval can be honored.
        [noticeView showAfterDelay:delayInterval];
    }

    return noticeView;
}

- (void)showAfterDelay:(NSTimeInterval)delayInterval {
    [self.parentView addSubview:self];

    [self setNeedsDisplay];

    //if parent view is a UIWindow, check if the status bar is showing (and offset the view accordin
    double statusBarOffset = ([self.parentView isKindOfClass:[UIWindow class]] && (! [[UIApplication sharedApplication] isStatusBarHidden])) ? [[UIApplication sharedApplication] statusBarFrame].size.height : 0.0;

    //In landscape orientation height and width are swapped, because the status bar frame is in the screen's coordinate space.
    if ((int)statusBarOffset == 1024 && ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)){
        statusBarOffset = 0.0;
    }

    if ([self.parentView isKindOfClass:[UIView class]] && ![self.parentView isKindOfClass:[UIWindow class]]) {
        statusBarOffset = 0.0;
    }
    self.offset = (float)fmax(self.offset, statusBarOffset);

    //Animation
    [UIView animateWithDuration:0.5f
                          delay:delayInterval
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.alpha = 1.0;
                         self.frame = CGRectMake(0.0,
                                 0.0 + self.offset,
                                 self.frame.size.width,
                                 self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished){
                             //Hide
                             if (self.hideInterval > 0) {
                                 [self performSelector:@selector(hide) withObject:self.parentView afterDelay:self.hideInterval];
                             }
                         }
                     }];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Hide
////////////////////////////////////////////////////////////////////////

- (void)hide {
    [UIView animateWithDuration:0.4f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.alpha = 0.0;
                         self.frame = CGRectMake(0.0,
                                 -self.frame.size.height + self.offset,
                                 self.frame.size.width,
                                 self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished){
                             [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1f];

                             // Remove this notification from the queue
                             [notificationQueue removeObjectIdenticalTo:self];

                             // Show the next notification in the queue
                             if([notificationQueue count] > 0) {
                                 EXLocalNotificationView *nextNotification = [notificationQueue objectAtIndex:0];
                                 [nextNotification showAfterDelay:0];
                             }
                         }
                     }];
}

+ (void)hideCurrentNotificationView
{
    if([notificationQueue count] > 0)
    {
        EXLocalNotificationView *currentNotification = [notificationQueue objectAtIndex:0];
        [currentNotification hide];
    }
}

+ (void)hideCurrentNotificationViewAndClearQueue
{
    NSUInteger numberOfNotification = [notificationQueue count];

    if(numberOfNotification > 1)
    {
        // remove all notification except the current notification
        [notificationQueue removeObjectsInRange:NSMakeRange(1, numberOfNotification -1)];
    }

    [EXLocalNotificationView hideCurrentNotificationView];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Touch events
////////////////////////////////////////////////////////////////////////

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hide];
    if(self.responseBlock != nil) {
        self.responseBlock();
    }
}

- (void)drawRect:(CGRect)rect
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self _drawBackgroundInRect:(CGRect)rect];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)_drawBackgroundInRect:(CGRect)rect{

    self.moveFactor = self.moveFactor > 14.0f ? 0.0f : ++self.moveFactor;

    UIColor *firstColor = nil;
    UIColor *secondColor = nil;
    UIColor *toplineColor = nil;

    firstColor = RGBA(210, 210, 210, 1.0);
    secondColor = RGBA(180, 180, 180, 1.0);
    toplineColor = RGBA(230, 230, 230, 1.0);

    //gradient
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint1 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint1 = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, rect);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint1, endPoint1, 0);
    CGContextRestoreGState(ctx);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    //top line
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    if ([toplineColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [toplineColor getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *components = CGColorGetComponents(toplineColor.CGColor);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    CGContextSaveGState(ctx);
    CGContextSetRGBFillColor(ctx, 0.9f, 0.9f, 0.9f, 1.0f);
    CGContextFillRect(ctx, CGRectMake(0, 0, self.bounds.size.width, 1));
    CGContextSetLineWidth(ctx, 1.5f);
    CGContextSetRGBStrokeColor(ctx, red, green, blue, alpha);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);

    //bottom line
    CGContextSaveGState(ctx);
    CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
    CGContextFillRect(ctx, CGRectMake(0, PANELHEIGHT, self.bounds.size.width, 1));
    CGContextSetLineWidth(ctx, 1.5f);
    CGContextSetRGBStrokeColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, PANELHEIGHT);
    CGContextAddLineToPoint(ctx, rect.size.width, PANELHEIGHT);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);

    //shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.layer.shadowRadius = 2.0f;
}
@end