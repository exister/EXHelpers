#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EXSegmentedViewControllerControlPosition) {
    EXSegmentedViewControllerControlPositionNavigationBar,
    EXSegmentedViewControllerControlPositionToolbar
};


@interface EXSegmentedViewController : UIViewController

@property (nonatomic, readonly, strong) UISegmentedControl *segmentedControl;
@property (nonatomic) EXSegmentedViewControllerControlPosition position;
@property (nonatomic, strong) IBOutlet UIView *containerView;

@property (nonatomic, strong) UIViewController *currentDetailViewController;

// NSArray of UIViewController subclasses
- (id)initWithViewControllers:(NSArray *)viewControllers;

// Takes segmented control item titles separately from the view controllers
- (id)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;

- (void)setupWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;

- (void)moveControlToPosition:(EXSegmentedViewControllerControlPosition)newPosition;

- (void)updateBarsForViewController:(UIViewController *)viewController;
@end