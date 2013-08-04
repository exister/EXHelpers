#import "UITableViewCell+EXMessageRouter.h"
#import <objc/runtime.h>

static char kEXActionTargetKey;
static char kEXOwningTableViewKey;

@implementation UITableViewCell (EXMessageRouter)

+ (instancetype)cellForTableView:(UITableView *)tv target:(id)target
{
    NSString *className = NSStringFromClass([self class]);

    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:className];

    if(!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }

    cell.actionTarget = target;
    cell.owningTableView = tv;

    return cell;
}

- (void)setActionTarget:(id)target
{
    objc_setAssociatedObject(self, &kEXActionTargetKey, target, OBJC_ASSOCIATION_ASSIGN);
}

- (id)actionTarget
{
    return objc_getAssociatedObject(self, &kEXActionTargetKey);
}

- (void)setOwningTableView:(UITableView *)tableView
{
    objc_setAssociatedObject(self, &kEXOwningTableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);
}

- (UITableView *)owningTableView
{
    return objc_getAssociatedObject(self, &kEXOwningTableViewKey);
}

#pragma mark - Message routing

- (void)routeAction:(SEL)act fromObject:(id)obj
{
    [self dispatchMessage:act toObject:[self actionTarget] fromObject:obj];
}

- (void)dispatchMessage:(SEL)msg toObject:(id)obj fromObject:(UIControl *)ctl
{
    SEL newSel = NSSelectorFromString([NSStringFromSelector(msg) stringByAppendingFormat:@"atIndexPath:"]);
    NSIndexPath *indexPath = [self.owningTableView indexPathForCell:self];
    if (indexPath && [obj respondsToSelector:newSel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [obj performSelector:newSel withObject:ctl withObject:indexPath];
#pragma clang diagnostic pop
    }
}

@end
