#import <UIKit/UIKit.h>

@interface EXTooltipImageView : UIImageView {
@protected
    UILabel  *_textLabel;
    NSString *_text;
}

@property (nonatomic, copy) NSString *text;

@end
