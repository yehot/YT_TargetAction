//
//  NewsViewController.h
//  YT_TargetAction
//
//  Created by yehao on 16/9/14.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import <UIKit/UIKit.h>


// ******************** NOTE  ************************

//  每一个需要 路由跳转的 VC（业务组件），都需要提供两个类：
//  1. CTMediator+[XXX]Actions.h
//      - 此类是 CTMediator 的 category
//      - XXX 是 VC 的业务名，eg： NewsViewController ，XXX = News

//  2. Target_[XXX].h
//      - XXX 是 VC 的业务名，eg： NewsViewController ，XXX = News
//      - 此类.m 中需要 import 该 VC
//      - 提供一个格式如 - (UIViewController *)Action_xxxx 的函数，供 CTMediator 动态调用

// ******************** NOTE  ************************



/** 需要传入参数来初始化的 VC */
@interface NewsViewController : UIViewController

@property (nonatomic, copy) NSString *newsID;

@end
