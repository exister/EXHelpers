#import <Foundation/Foundation.h>


@interface EXValidatableTextField : UITextField

@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, assign) id validationDelegate;

- (void)setError:(NSString *)error;
@end