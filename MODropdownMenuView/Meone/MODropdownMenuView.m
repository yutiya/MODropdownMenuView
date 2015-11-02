//
//  MODropdownMenuView.m
//  下拉式导航
//
//  Created by admin on 15/11/2.
//  Copyright (c) 2015年 Meone. All rights reserved.
//

#import "MODropdownMenuView.h"
#import "Masonry.h"
#import "UIViewController+topestViewController.h"
#import "AppDelegate.h"

@interface MODropdownMenuView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *wrapperView;

@end

static const CGFloat kMODropdownMenuViewHeaderHeight = 300;

@implementation MODropdownMenuView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if ((self = [super initWithFrame:frame]))
    {
        _animationDuration = 0.4;
        _backgroundAlpha = 0.3;
        _cellHeight = 44;
        _selectedIndex = 0;
        _titles = titles;
        
        [self addSubview:self.titleButton];
        [self addSubview:self.arrowImageView];
        
        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleButton.mas_right).offset(5);
            make.centerY.equalTo(self.titleButton.mas_centerY);
        }];
        
        UIWindow *keyWindow = [self showWindow];
        UIViewController *viewController = [keyWindow.rootViewController topestViewController];
        UINavigationBar *navBar = viewController.navigationController.navigationBar;
        [viewController.navigationController.view addSubview:self.wrapperView];
        [self.wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(viewController.navigationController.view);
            make.top.equalTo(navBar.mas_bottom);
        }];
        [self.wrapperView addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.wrapperView);
        }];
        
        CGFloat tableCellsHeight = _cellHeight * _titles.count;
        [self.wrapperView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.wrapperView);
            make.top.equalTo(self.wrapperView.mas_top).offset(-tableCellsHeight - kMODropdownMenuViewHeaderHeight);
            make.bottom.equalTo(self.wrapperView.mas_bottom).offset(tableCellsHeight + kMODropdownMenuViewHeaderHeight);
        }];
        [self.tableView layoutIfNeeded];
        self.wrapperView.hidden = YES;
    }
    return self;
}

#pragma mark - Get Window
- (UIWindow *)showWindow
{
    UIWindow *showWindow = nil;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            showWindow = window;
            break;
        }
    }
    return showWindow;
}

#pragma mark -- getter and setter
- (UIColor *)cellColor
{
    if (!_cellColor)
    {
        _cellColor = [UIColor greenColor];
    }
    return _cellColor;
}
- (UIColor *)cellSeparatorColor
{
    if (!_cellSeparatorColor)
    {
        _cellSeparatorColor = [UIColor whiteColor];
    }
    return _cellSeparatorColor;
}
- (UIColor *)textColor
{
    if (!_textColor)
    {
        _textColor = [UIColor whiteColor];
    }
    return _textColor;
}
- (UIFont *)textFont
{
    if (!_textFont)
    {
        _textFont = [UIFont systemFontOfSize:17.f];
    }
    return _textFont;
}
- (UIButton *)titleButton
{
    if (!_titleButton)
    {
        _titleButton = [[UIButton alloc] init];
        [_titleButton setTitle:[[self titles] objectAtIndex:0] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(handleTapOnTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_titleButton.titleLabel setFont:self.textFont];
        [_titleButton setTitleColor:self.textColor forState:UIControlStateNormal];
    }
    return _titleButton;
}
- (UIImageView *)arrowImageView
{
    if (!_arrowImageView)
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MODropdownMenuView" ofType:@"bundle"];
        NSString *imgPath = [bundlePath stringByAppendingPathComponent:@"arrow_down_icon.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
        _arrowImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _arrowImageView;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = self.cellSeparatorColor;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    }
    return _tableView;
}
- (UIView *)wrapperView
{
    if (!_wrapperView)
    {
        _wrapperView = [[UIView alloc] init];
        _wrapperView.clipsToBounds = YES;
    }
    return _wrapperView;
}
- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = self.backgroundAlpha;
    }
    return _backgroundView;
}
- (void)setIsMenuShow:(BOOL)isMenuShow
{
    if (_isMenuShow != isMenuShow)
    {
        _isMenuShow = isMenuShow;
        if (isMenuShow)
        {
            [self showMenu];
        }
        else
        {
            [self hideMenu];
        }
    }
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        [_titleButton setTitle:[_titles objectAtIndex:selectedIndex] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
    self.isMenuShow = NO;
}

#pragma mark - handle actions
- (void)handleTapOnTitleButton:(UIButton *)sender
{
    self.isMenuShow = !self.isMenuShow;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    if (self.selectedIndex == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = self.cellColor;
    cell.textLabel.font = self.textFont;
    cell.textLabel.textColor = self.textColor;
    return cell;
}


#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Show Menu

- (void)showMenu
{
    self.titleButton.enabled = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 300)];
    headerView.backgroundColor = self.cellColor;
    self.tableView.tableHeaderView = headerView;
    [self.tableView layoutIfNeeded];
    
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wrapperView.mas_top).offset(-kMODropdownMenuViewHeaderHeight);
        make.bottom.equalTo(self.wrapperView.mas_bottom).offset(kMODropdownMenuViewHeaderHeight);
    }];
    self.wrapperView.hidden = NO;
    self.backgroundView.alpha = 0.0;
    //箭头旋转180度
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                        self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
    }];
    //表视图显示动画
    [UIView animateWithDuration:self.animationDuration * 1.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.tableView layoutIfNeeded];
                         self.backgroundView.alpha = self.backgroundAlpha;
    } completion:nil];
}
- (void)hideMenu
{
    self.titleButton.enabled = YES;
    CGFloat tableCellsHeight = _cellHeight * _titles.count;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wrapperView.mas_top).offset(-tableCellsHeight-kMODropdownMenuViewHeaderHeight);
        make.bottom.equalTo(self.wrapperView.mas_bottom).offset(tableCellsHeight+kMODropdownMenuViewHeaderHeight);
    }];
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, -M_PI);
                     }];
    [UIView animateWithDuration:self.animationDuration * 1.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.tableView layoutIfNeeded];
                         self.backgroundView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.wrapperView.hidden = YES;
                     }];
}
@end
















