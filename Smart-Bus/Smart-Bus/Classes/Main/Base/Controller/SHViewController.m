//
//  SHViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/5.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHViewController.h"

@interface SHViewController () <SHSocketToolsReceiveDataProtocol>

@end

@implementation SHViewController

/// 当前控制器成为焦点
- (void)becomeFocus {
   
//    SHSocketTools.shared.delegate = self;
    
}

 

// MARK: - UI相关的的设置

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    // 记录当前是否横竖屏
    self.isPortrait = (self.view.frame_height > self.view.frame_width);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    SHSocketTools.shared.delegate = self;
    
    // 解决导航栏比较难按的问题 (设置导航item的大小, 固定大小，直接加载时写上)
    
    UIView *leftCustomView = self.navigationItem.leftBarButtonItem.customView;
    UIView *rightCustomView = self.navigationItem.rightBarButtonItem.customView;
    
    CGFloat itemSize =
        [UIDevice is_iPad] ? (navigationBarHeight + statusBarHeight) :
        tabBarHeight;
    
    leftCustomView.bounds = CGRectMake(0, 0, itemSize, itemSize);
    rightCustomView.bounds = CGRectMake(0, 0, itemSize, itemSize);
    
//    leftCustomView.backgroundColor = [UIColor orangeColor];
//    rightCustomView.backgroundColor = [UIColor greenColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 这句话不要少
    self.navigationController.navigationBar.translucent = NO ;
   
    // 1.屏幕旋转
    [self viewWillTransitionToSize:self.view.bounds.size withTransitionCoordinator:self.transitionCoordinator];
    
    // 接收数据广播
//    [[NSNotificationCenter defaultCenter]
//        addObserver:self
//           selector:@selector(receiveBroadcastMessages:)
//               name:SHSocketTools.broadcastNotificationName
//             object:nil
//    ];
    
    // 接收实时的数据
    [NSNotificationCenter.defaultCenter
     addObserver:self
     selector:@selector(becomeFocus)
     name:SHBecomeFocusNotification
     object:nil
     ];
}

- (void)receiveData:(SHSocketData *)socketData {
    
    [self analyzeReceivedSocketData:socketData];
}

/// 接收到了数据
- (void)receiveBroadcastMessages:(NSNotification *)notification {
    
//    SHSocketData *socketData = notification.userInfo[SHSocketTools.broadcastNotificationName];
//    
//    if (!socketData) {
//        return;
//    }
//    
    // 通知子类调用
//    [self analyzeReceivedSocketData:socketData];
}

/// 解析数据
- (void )analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    // 由子类来实现
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - 手机不横屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if ([UIDevice is_iPad]) {
        return [super supportedInterfaceOrientations];
    }
    
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
// MARK: - 状态栏的管理
    
- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}
    
- (BOOL)prefersStatusBarHidden {

    return NO;
}
    
@end
