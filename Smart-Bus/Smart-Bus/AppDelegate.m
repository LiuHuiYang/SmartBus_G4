//
//  AppDelegate.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/5.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()

/// 后台任务标记
@property (nonatomic, assign) UIBackgroundTaskIdentifier task;


/// 定位管理器
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate

/// 程序加载完成
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.准备语言适配文件
    [[SHLanguageTools shareLanguageTools] copyLanguagePlist];
    
    [[SHLanguageTools shareLanguageTools] setLanguage];
    
    // 3. 初始化计划执行的定时器
    [[SHSchedualExecuteTools shared] initSchedualTimer];
    
    // 启动界面
    self.window =
        [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController =
    [[SHMainViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    [self setupSVProgressHUD];

    // 从 iOS 13 开始 获取wifi需要定位授权
    if (@available(iOS 13.0, *)) {
    
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
            self.locationManager =
                [[CLLocationManager alloc] init];
            
            [self.locationManager requestWhenInUseAuthorization];
    }
}
     
    
    //     用于测试重发机制的测试代码
    //    SHMacroCommand *command = [[SHMacroCommand alloc] init];
    //    command.subnetID = 1;
    //    command.deviceID = 163;
    //    command.commandTypeID = 4;
    //
    //    for (Byte i = 0; i < 24; i++) {
    //
    //        command.macroID = 1;
    //        command.remark = @"开";
    //        command.firstParameter = i + 1;
    //        command.secondParameter = 100;
    //
    //        [SHSQLiteManager.shared insertMacroCommand:command];
    //    }
    //
    //    for (Byte i = 0; i < 24; i++) {
    //
    //        command.macroID = 2;
    //        command.remark = @"关";
    //        command.firstParameter = i + 1;
    //        command.secondParameter = 0;
    //
    //       [SHSQLiteManager.shared insertMacroCommand:command];
    //    }
    
    
    return YES;
}

- (void) startMonitoringNetWorkStatus {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 网络状态发生变化, 都关闭socket
        [SHSocketTools.shared.socket close];
        SHSocketTools.shared.socket = nil;
       
        if (status == AFNetworkReachabilityStatusNotReachable ||
            status == AFNetworkReachabilityStatusUnknown) {
            
            printLog(@"网络不可用");
            
            return ;
        }
        
        // 重新初始化soket
        SHSocketTools.shared.socket =
            [SHSocketTools.shared setupSocket];
    }];
}

//// 设置指示器
- (void)setupSVProgressHUD {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0x726B6E alpha:1.0]];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"showSuccess"]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"showError"]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"showInfo"]];
    
    [SVProgressHUD setForegroundColor:[UIView textWhiteColor]];
    
    [SVProgressHUD setCornerRadius:statusBarHeight];
    
    BOOL isIPAD = [UIDevice is_iPad];
    
    CGFloat scale = isIPAD ? 0.35 : 0.25;
    
    UIFont *font =
        isIPAD ?
            [UIView suitFontForPad] :
            [UIFont preferredFontForTextStyle: UIFontTextStyleTitle3
        ];
    
    CGFloat imageSize =
        isIPAD ? navigationBarHeight : defaultHeight;
    
    CGFloat width =  UIView.frame_screenWidth * scale;
    CGFloat height = UIView.frame_screenHeight * scale;
    
    CGFloat size = width > height ? width : height;
    
    [SVProgressHUD setMinimumSize: CGSizeMake(size, size)];
    
    [SVProgressHUD setFont: font];
    
    [SVProgressHUD setImageViewSize:
        CGSizeMake(imageSize, imageSize)
    ];
}

/// 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
      
    // 开启后台任务
    if ([[NSUserDefaults standardUserDefaults]
         integerForKey:UIAPPLICATION_BACKGROUND_TASK_KEY] ==
        SHApplicationBackgroundTaskOpen) {
        
        self.task =
            [[UIApplication sharedApplication]
                beginBackgroundTaskWithExpirationHandler:nil
            ];
    }
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
    [SHSocketTools.shared.socket close];
    SHSocketTools.shared.socket = nil;
}

/// 程序已经回到前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // 开启网络临近状态
    [self startMonitoringNetWorkStatus];
    
    // App 成为活跃状态 创建 socket
//    [SHSocketTools shared];
    
    // 发出通知 主动读取状态
    [NSNotificationCenter.defaultCenter postNotificationName:SHBecomeFocusNotification object:nil];
    
    if ([[NSUserDefaults standardUserDefaults]
         integerForKey:UIAPPLICATION_BACKGROUND_TASK_KEY] ==
        SHApplicationBackgroundTaskOpen) {
        
        [[UIApplication sharedApplication] endBackgroundTask:self.task];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
