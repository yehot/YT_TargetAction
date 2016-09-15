//
//  OneViewController.m
//  YT_TargetAction
//
//  Created by yehao on 16/9/14.
//  Copyright © 2016年 yehot. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@property (nonatomic, strong) UILabel *newsLabel;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSLog(@"OneViewController name = %@", self.name);
    [self.view addSubview:self.newsLabel];

}

- (void)setName:(NSString *)name {
    self.newsLabel.text = [NSString stringWithFormat:@"name = %@", name];
}

- (UILabel *)newsLabel {
    if (!_newsLabel) {
        _newsLabel = [[UILabel alloc] init];
        _newsLabel.textColor = [UIColor redColor];
        _newsLabel.frame = self.view.frame;
        _newsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _newsLabel;
}


@end
