//
//  HomeViewController.m
//  YT_TargetAction
//
//  Created by yehao on 16/9/15.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import "HomeViewController.h"

//  不使用 Router 或 target action 时的用法
#import "OneViewController.h"

//  使用 target action 跳转
#import "CTMediator+NewsActions.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//  使用 target action 跳转
- (IBAction)btnOne:(UIButton *)sender {
    
    // 这里 param dict 的 value 也可以 传 model
    UIViewController *viewController = [[CTMediator sharedInstance] yt_mediator_newsViewControllerWithParams:@{@"newsID":@"123456"}];
    [self.navigationController pushViewController:viewController animated:YES];
}

//  不使用 Router 或 target action 时的用法
- (IBAction)btnTwo:(UIButton *)sender {
    OneViewController *viewController = [[OneViewController alloc] init];
    viewController.name = @"普通用法";
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
