#import <Foundation/Foundation.h>

@class EXInvalidTooltipImageView;


@interface EXValidatableTextField : UITextField

@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, assign) id validationDelegate;

@property (nonatomic, strong) EXInvalidTooltipImageView *tooltip;

@property (nonatomic, strong) UITapGestureRecognizer *tooltipTap;

@property (nonatomic, copy) NSString *errorMessage;

- (void)setError:(NSString *)error;
@end