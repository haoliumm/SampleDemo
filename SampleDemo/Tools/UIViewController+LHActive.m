//
//  UIViewController+LHActive.h
//
//  Created by liuhao on 2017/8/18.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "UIViewController+LHActive.h"

@implementation UIViewController (LYActive)

+ (UIViewController *)activeViewController {
    UIViewController *viewController = [[UIViewController alloc] init];
    id rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [viewController activeViewController:rootVC];
}
- (UIViewController *)activeViewController:(id)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)viewController;
        return [self activeViewController:tab.selectedViewController];
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        return [nav visibleViewController];
    }
    if ([viewController isKindOfClass:[UIViewController class]]) {
        UIViewController *active = viewController;
        while (active.presentedViewController) {
            active = active.presentedViewController;
        }
        return active;
    }
    return nil;
}
@end
