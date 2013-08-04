#import "EXInvalidTooltipImageView.h"
#import "EXTooltipImageViewProtectedMethods.h"

@implementation EXInvalidTooltipImageView

- (void)buildUI
{
    [super buildUI];

    self.image = [[UIImage imageNamed:@"image_tooltip_invalid.png"] stretchableImageWithLeftCapWidth:48 topCapHeight:18];
}
@end
