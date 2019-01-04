//
//  SHTabBarController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/13.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHTabBarController.h"

@interface SHTabBarController ()

/// 背景视图
@property (strong, nonatomic) UIImageView *backgroundView;

@end

@implementation SHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!self.childViewControllers.count) {
     
        [self.view addSubview:self.backgroundView];
    }
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    if (!self.childViewControllers.count) {
        self.backgroundView.frame = self.view.bounds;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - getter && setter
- (UIImageView *)backgroundView {
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizeImage:@"background"]];
        _backgroundView.userInteractionEnabled = YES;
    }
    
    return _backgroundView;
}

@end
