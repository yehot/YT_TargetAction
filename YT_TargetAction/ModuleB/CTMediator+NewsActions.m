//
//  CTMediator+NewsActions.m
//  YT_TargetAction
//
//  Created by yehao on 16/9/14.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import "CTMediator+NewsActions.h"

// ******************** NOTE  ************************

//TODO: 这里的两个字符串必须 hard code

//  1. 字符串 是类名 Target_xxx.h 中的 xxx 部分
NSString * const kCTMediatorTarget_News = @"News";

//  2. 字符串是 Target_xxx.h 中 定义的 Action_xxxx 函数名的 xxx 部分
NSString * const kCTMediatorActionNativTo_NewsViewController = @"NativeToNewsViewController";

// ******************** NOTE  ************************


@implementation CTMediator (NewsActions)

- (UIViewController *)yt_mediator_newsViewControllerWithParams:(NSDictionary *)dict {
    
    UIViewController *viewController = [self performTarget:kCTMediatorTarget_News
                                                    action:kCTMediatorActionNativTo_NewsViewController
                                                    params:dict];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        NSLog(@"%@ 未能实例化页面", NSStringFromSelector(_cmd));
        return [[UIViewController alloc] init];
    }
}

@end
