# [Target-Action 实现组件解耦](http://www.jianshu.com/p/76132c91be47)

# CTMediator 的使用


## 一、普通页面跳转用法

假设我们有个页面叫 `OneViewController`，当前页面为 `HomeViewController`，普通情况下页面的间的跳转方式如下：

```
#import "HomeViewController.h"
#import "OneViewController.h"

@implementation HomeViewController

- (void)aButtonClick:(UIButton *)sender {
    OneViewController *viewController = [[OneViewController alloc] init];
    viewController.name = @"普通用法";  //传递必要参数
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
```

这样做看上去没什么问题，实际也没什么问题。
但是，考虑以下情况：

1. 如果 `HomeViewController` 里有 N 个这样的 button 事件，每个点击后的跳转都是不同的页面，那么则 `HomeViewController` 里，需要导入 N 个这样的 `OneViewController.h`;
2. 如果 `HomeViewController` 是一个可以移植到其它项目的业务模块，在拖出首页 `HomeVC` 相关的业务代码时，难道还要把 'HomeViewController.m' 导入的 N 个其它 `XxxViewController.h` 都一块拖到新项目中么？

这点就是因为代码的耦合导致了首页 `HomeVC` 没法方便的移植。

说这样没有问题，是因为普通情况下，我们并没有移植 `HomeVC` 到其它项目的需求。

至于什么时候会有这样的问题，以及，这样的问题如果解决，在 [iOS组件化方案调研](http://www.jianshu.com/p/34f23b694412) 这篇中，已经做过简单的讨论，这篇主要是选取了我个人较偏向的 `Target-Action` 这套方案，简单讲一下实现方式。

## 二、Target-Action 实现页面跳转

采用的是 `CTMediator` 这套方案
[Demo地址](https://github.com/yehot/YT_TargetAction)

还是假设我们有个页面叫 `NewsViewController`, 当前页面为`HomeViewController`
那么，我们按照`CTMediator`设计的架构来写一遍这个流程

### 1.创建Target-Action

创建一个 `Target_News` 类，在这个文件里，我们主要生成 NewsViewController 实例并为其进行一些必要的赋值。例如:

```
// Target_News.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Target_News : NSObject

- (UIViewController *)Action_NativeToNewsViewController:(NSDictionary *)params;

@end

```

这个类需要直接 `#import "NewsViewController.h"`

```
// Target_News.m

#import "Target_News.h"
#import "NewsViewController.h"

@implementation Target_News

- (UIViewController *)Action_NativeToNewsViewController:(NSDictionary *)params {
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    
    if ([params valueForKey:@"newsID"]) {
        newsVC.newsID = params[@"newsID"];
    }
    
    return newsVC;
}

@end
```


### 2.创建 CTMediator 的Category.

CTMediator+NewsActions.这个Category利用Runtime调用我们刚刚生成的Target_News。

由于利用了Runtime，导致我们完全不用#import刚刚生成的Target_News即可执行里面的方法，所以这一步，两个类是完全解耦的。也即是说，我们在完全解耦的情况下获取到了我们需要的NewsViewController。例如：

```
// CTMediator+NewsActions.h

#import "CTMediator.h"
#import <UIKit/UIKit.h>

@interface CTMediator (NewsActions)

- (UIViewController *)yt_mediator_newsViewControllerWithParams:(NSDictionary *)dict;

@end
```


```
// CTMediator+NewsActions.m

#import "CTMediator+NewsActions.h"

NSString * const kCTMediatorTarget_News = @"News";
NSString * const kCTMediatorActionNativTo_NewsViewController = @"NativeToNewsViewController";

@implementation CTMediator (NewsActions)

- (UIViewController *)yt_mediator_newsViewControllerWithParams:(NSDictionary *)dict {
    
    UIViewController *viewController = [self performTarget:kCTMediatorTarget_News
                                                    action:kCTMediatorActionNativTo_NewsViewController
                                                    params:dict];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        NSLog(@"%@ 未能实例化页面", NSStringFromSelector(_cmd));
        return [[UIViewController alloc] init];
    }
}

@end
```

### 3.最终使用

由于在Target中，传递值得方式采用了去Model化得方式，导致我们在整个过程中也没有#import任何Model。所以，我们的每个类都与Model解耦。

```
// HomeViewController.m

#import "HomeViewController.h"
#import "CTMediator+NewsActions.h"

@implementation HomeViewController

- (void)bButtonClick:(UIButton *)sender {    
    UIViewController *viewController = [[CTMediator sharedInstance] yt_mediator_newsViewControllerWithParams:@{@"newsID":@"123456"}];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
```

### 4.不足

这里其实唯一的问题就是，Target_Action里不得不填入一些 Hard Code，就是对创建的VC的赋值语句。不过这也是为了达到最大限度的解耦和灵活度而做的权衡。

```
//  1. kCTMediatorTarget_News字符串 是 Target_xxx.h 中的 xxx 部分
NSString * const kCTMediatorTarget_News = @"News";

//  2. kCTMediatorActionNativTo_NewsViewController 是 Target_xxx.h 中 定义的 Action_xxxx 函数名的 xxx 部分
NSString * const kCTMediatorActionNativTo_NewsViewController = @"NativeToNewsViewController";
```

## 三、参考

### 相关技术博客：

1、[iOS应用架构谈 组件化方案](http://casatwy.com/iOS-Modulization.html?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)

2、[蘑菇街 App 的组件化之路](http://limboy.me/ios/2016/03/10/mgj-components.html)

[蘑菇街 App 的组件化之路·续](http://limboy.me/ios/2016/03/14/mgj-components-continued.html)

3、[iOS 组件化方案探索](http://blog.cnbang.net/tech/3080/)

4、[《iOS应用架构谈 组件化方案》和《蘑菇街 App 的组件化之路》的阅读指导](http://www.reviewcode.cn/article.html?reviewId=20)

5、[浅析 iOS 应用组件化设计](https://skyline75489.github.io/post/2016-3-16_ios_module_design.html)

6、[糯米移动组件架构演进之路](http://chuansong.me/n/320688951236)

7、[饿了么移动APP的架构演进](https://www.sdk.cn/news/2023)

8、[滴滴出行iOS客户端架构演进之路](https://mp.weixin.qq.com/s?__biz=MzA3ODg4MDk0Ng%3D%3D&idx=1&mid=402854111&sn=5876e615fabd6d921285d904e16670fb)

9、[ios业务模块间互相跳转的解耦方案](http://www.aliog.com/101363.html)

10、[iOS组件化思路－大神博客研读和思考](http://cdn0.jianshu.io/p/afb9b52143d4)

11、[模块化与解耦](https://blog.cnbluebox.com/blog/2015/11/28/module-and-decoupling/)

### 相关解决方案：

1、[casatwy/CTMediator](https://github.com/casatwy/CTMediator) 

2、[mogujie/MGJRouter](https://github.com/mogujie/MGJRouter) 

3、[joeldev/JLRoutes](https://github.com/joeldev/JLRoutes)

4、[Huohua/HHRouter](https://github.com/Huohua/HHRouter)

5、[clayallsopp/routable-ios](https://github.com/clayallsopp/routable-ios)

6、[Lede-Inc/LDBusBundle_IOS](https://github.com/Lede-Inc/LDBusBundle_IOS)







