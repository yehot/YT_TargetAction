//
//  Target_News.h
//  YT_TargetAction
//
//  Created by yehao on 16/9/14.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**  */
@interface Target_News : NSObject

#warning 如果 Target_XXX 中的 Action_XXX 方法名变了。 CTMediator+XXXActions.m 中的字符串也必须得一起变


/**
 *  返回 NewsViewController 实例
 *
 *  @param params 要传给 NewsViewController 的参数
 */
- (UIViewController *)Action_NativeToNewsViewController:(NSDictionary *)params;

@end
