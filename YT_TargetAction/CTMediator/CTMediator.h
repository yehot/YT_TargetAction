//
//  CTMediator.h
//  CTMediator
//
//  Created by casa on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CTMediator : NSObject

+ (instancetype)sharedInstance;

// 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;


// 本地组件调用入口

/**
 *  CTMediator 执行 xx target 的 xx action 后，return
 *
 *  @param targetName Target_XXX.h
 *  @param actionName Action_XXX 函数
 *  @param params     参数
 *
 *  @return some instance
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;

@end
