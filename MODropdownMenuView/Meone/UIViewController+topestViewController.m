//
//  UIViewController+topestViewController.m
//  下拉式导航
//
//  Created by admin on 15/11/2.
//  Copyright (c) 2015年 Meone. All rights reserved.
//

#import "UIViewController+topestViewController.h"

@implementation UIViewController (topestViewController)

- (UIViewController *)topestViewController
{
    if (self.presentedViewController)
    {
        return [self.presentedViewController topestViewController];
    }
    if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tab = (UITabBarController *)self;
        return [[tab selectedViewController] topestViewController];
    }
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)self;
        return [[nav visibleViewController] topestViewController];
    }
    return self;
}

@end
