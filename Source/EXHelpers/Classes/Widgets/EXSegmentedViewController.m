#import "EXSegmentedViewController.h"

#define DEFAULT_SELECTED_INDEX 0

@interface EXSegmentedViewController ()
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic) NSInteger currentSelectedIndex;
@end

@implementation EXSegmentedViewController {

}

- (CGRect)frameForDetailController {
    return self.containerView.bounds;
}

- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:self.titles];
        _segmentedControl.selectedSegmentIndex = DEFAULT_SELECTED_INDEX;
        _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

        [_segmentedControl addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)setPosition:(EXSegmentedViewControllerControlPosition)position {
    _position = position;
    [self moveControlToPosition:position];
}

- (id)initWithViewControllers:(NSArray *)viewControllers {
    return [self initWithViewControllers:viewControllers titles:[viewControllers valueForKeyPath:@"@unionOfObjects.title"]];
}

- (id)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles {
    self = [super init];

    if (self) {
        [self setupWithViewControllers:viewControllers titles:titles];

        if ([_viewControllers count] == 0 || [_viewControllers count] != [_titles count]) {
            self = nil;
            NSLog(@"EXSegmentedViewController: Invalid configuration of view controllers and titles.");
        }
    }

    return self;
}

- (void)setupWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles {
    _viewControllers = [NSMutableArray array];
    _titles = [NSMutableArray array];

    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        if ([obj isKindOfClass:[UIViewController class]] && index < [titles count]) {
            UIViewController *viewController = obj;

            [_viewControllers addObject:viewController];
            [_titles addObject:titles[index]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.containerView.accessibilityIdentifier = @"containerView";

    self.currentSelectedIndex = DEFAULT_SELECTED_INDEX;
    [self observeViewController:self.viewControllers[self.currentSelectedIndex]];

    [self presentDetailController:self.viewControllers[self.currentSelectedIndex]];
    [self updateBarsForViewController:self.currentDetailViewController];
}

- (void)viewDidUnload {
    [self stopObservingViewController:self.viewControllers[self.currentSelectedIndex]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.currentDetailViewController.view.frame = self.frameForDetailController;
}

- (void)presentDetailController:(UIViewController *)detailVC {
    //0. Remove the current Detail View Controller showed
    if (self.currentDetailViewController){
        [self removeCurrentDetailViewController];
    }

    //1. Add the detail controller as child of the container
    [self addChildViewController:detailVC];

    //2. Define the detail controller's view size
    detailVC.view.frame = [self frameForDetailController];

    //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
    [self.containerView addSubview:detailVC.view];
    self.currentDetailViewController = detailVC;

    //4. Complete the add flow calling the function didMoveToParentViewController
    [detailVC didMoveToParentViewController:self];
}

- (void)removeCurrentDetailViewController{
    //1. Call the willMoveToParentViewController with nil
    //   This is the last method where your detailViewController can perform some operations before being removed
    [self.currentDetailViewController willMoveToParentViewController:nil];

    //2. Remove the DetailViewController's view from the Container
    [self.currentDetailViewController.view removeFromSuperview];

    //3. Update the hierarchy"
    //   Automatically the method didMoveToParentViewController: will be called on the detailViewController)
    [self.currentDetailViewController removeFromParentViewController];
}

- (void)moveControlToPosition:(EXSegmentedViewControllerControlPosition)newPosition {

    switch (newPosition) {
        case EXSegmentedViewControllerControlPositionNavigationBar:
            self.navigationItem.titleView = self.segmentedControl;
            break;
        case EXSegmentedViewControllerControlPositionToolbar: {
            UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
            UIBarButtonItem *control = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];
            self.toolbarItems = @[flexible, control, flexible];
            break;
        }
    }

    UIViewController *currentViewController = self.viewControllers[self.segmentedControl.selectedSegmentIndex];
    [self updateBarsForViewController:currentViewController];
}

- (void)changeViewController:(UISegmentedControl *)segmentedControl {
    //1. The current controller is going to be removed
    [self stopObservingViewController:self.currentDetailViewController];
    [self.currentDetailViewController willMoveToParentViewController:nil];

    //2. The new controller is a new child of the container
    UIViewController *viewController = self.viewControllers[segmentedControl.selectedSegmentIndex];
    [self addChildViewController:viewController];

    //3. Setup the new controller's frame depending on the animation you want to obtain
    viewController.view.frame = self.currentDetailViewController.view.frame;

    //3b. Attach the new view to the views hierarchy
    [self.containerView addSubview:viewController.view];

    [UIView animateWithDuration:1.3
            //4. Animate the views to create a transition effect
                     animations:nil
            //5. At the end of the animations we remove the previous view and update the hierarchy.
                     completion:^(BOOL finished) {
                         //Remove the old Detail Controller view from superview
                         [self.currentDetailViewController.view removeFromSuperview];

                         //Remove the old Detail controller from the hierarchy
                         [self.currentDetailViewController removeFromParentViewController];

                         //Set the new view controller as current
                         self.currentDetailViewController = viewController;
                         [self.currentDetailViewController didMoveToParentViewController:self];

                         [self updateBarsForViewController:self.currentDetailViewController];
                         [self observeViewController:self.currentDetailViewController];

                         self.currentSelectedIndex = segmentedControl.selectedSegmentIndex;
                     }];
}

- (void)updateBarsForViewController:(UIViewController *)viewController {
    if (self.position == EXSegmentedViewControllerControlPositionToolbar)
        self.title = viewController.title;
    else if (self.position == EXSegmentedViewControllerControlPositionNavigationBar)
        self.toolbarItems = viewController.toolbarItems;
}

#pragma mark - KVO

- (void)observeViewController:(UIViewController *)viewController {
    [viewController addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [viewController addObserver:self forKeyPath:@"toolbarItems" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)stopObservingViewController:(UIViewController *)viewController {
    [self.viewControllers[self.currentSelectedIndex] removeObserver:self forKeyPath:@"title"];
    [self.viewControllers[self.currentSelectedIndex] removeObserver:self forKeyPath:@"toolbarItems"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateBarsForViewController:object];
}

- (void)dealloc {
    @try{
        [self stopObservingViewController:self.viewControllers[self.currentSelectedIndex]];
    }
    @catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

@end