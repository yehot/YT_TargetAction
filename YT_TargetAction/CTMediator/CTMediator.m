//
//  CTMediator.m
//  CTMediator
//
//  Created by casa on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTMediator.h"

@implementation CTMediator

#pragma mark - public methods

+ (instancetype)sharedInstance
{
    static CTMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[CTMediator alloc] init];
    });
    return mediator;
}

/*
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
#warning todo 修改aaa为你自己app的scheme
    if (![url.scheme isEqualToString:@"aaa"]) {
        // 这里就是针对远程app调用404的简单处理了，根据不同app的产品经理要求不同，你们可以在这里自己做需要的逻辑
        return @(NO);
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performTarget:url.host action:actionName params:params];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

// ******************** NOTE  ************************

// targetName 是 Target_XXX 类文件 的 XXX 部分
// actionName 是定义在 Target_XXX 类文件中的 select name 后半部分

// 此函数的作用：
//  传入 Target_XXX.h 文件中 xxx 的字符串； NSClassFromString 动态生成类
//  传入 Target_XXX.h 文件中 action selector 的函数名字符串； NSSelectorFromString 动态生成 函数

// ******************** NOTE  ************************


- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params {
    
    // 类名 Target_XXX.h
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    Class targetClass = NSClassFromString(targetClassString);
    id target = [[targetClass alloc] init];
    
    // 函数名 Action_XXX:
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        NSLog(@"未提供对应的 targetClassString 类");
        return nil;
    }
    
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        //TODO: Target_XXX.h 文件中，需要提供 notFound 函数
        
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            NSLog(@"targetClassString类 未提供对应的 notFound: 函数");
            return nil;
        }
    }
}

@end