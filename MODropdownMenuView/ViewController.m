//
//  ViewController.m
//  下拉式导航
//
//  Created by admin on 15/11/2.
//  Copyright (c) 2015年 Meone. All rights reserved.
//

#import "ViewController.h"
#import "MODropdownMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    MODropdownMenuView *menuView = [[MODropdownMenuView alloc] initWithFrame:CGRectMake(0, 0, 100, 44) titles:@[@"首页",@"朋友圈",@"我的关注",@"明星",@"家人朋友"]];
    self.navigationItem.titleView = menuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
