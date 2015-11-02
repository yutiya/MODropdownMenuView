//
//  MODropdownMenuView.h
//  下拉式导航
//
//  Created by admin on 15/11/2.
//  Copyright (c) 2015年 Meone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MODropdownMenuView : UIView

// 默认绿色
@property (nonatomic, strong) UIColor *cellColor;
// 默认白色
@property (nonatomic, strong) UIColor *cellSeparatorColor;
// 默认 44
@property (nonatomic, assign) CGFloat cellHeight;
// 动画时间 0.4
@property (nonatomic, assign) CGFloat animationDuration;
// 默认白色
@property (nonatomic, strong) UIColor *textColor;
// 字体大小默认 17
@property (nonatomic, strong) UIFont *textFont;
// 背景透明度默认 0.3
@property (nonatomic, assign) CGFloat backgroundAlpha;
// 默认选择项 0
@property (nonatomic, assign) NSUInteger selectedIndex;
// 显示菜单
@property (nonatomic, assign) BOOL isMenuShow;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;


@end
