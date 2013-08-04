#import <UIKit/UIKit.h>

@interface UITableViewCell (EXMessageRouter)

+ (instancetype)cellForTableView:(UITableView *)tv target:(id)target;

- (id)actionTarget;

- (UITableView *)owningTableView;

- (void)routeAction:(SEL)act fromObject:(id)obj;
@end
