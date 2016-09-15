//
//  Target_News.m
//  YT_TargetAction
//
//  Created by yehao on 16/9/14.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import "Target_News.h"
#import "NewsViewController.h"

@implementation Target_News

/**
 *  返回 NewsViewController 实例
 *
 *  @param params 要传给 NewsViewController 的参数
 */
- (UIViewController *)Action_NativeToNewsViewController:(NSDictionary *)params {
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    
    if ([params valueForKey:@"newsID"]) {
        newsVC.newsID = params[@"newsID"];
    }
    
    return newsVC;
}

@end
