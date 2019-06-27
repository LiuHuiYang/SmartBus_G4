//
//  SHConstraint.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/15.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#include "SHConstraint.h"

// =================UI相关 ====
 
/// 导航栏高度
const CGFloat navigationBarHeight = 64;

/// 底部tabBar高度
const CGFloat tabBarHeight = 49;

/// 底部iPhoneX tabBar高度
const CGFloat tabBarHeight_iPhoneX_more = 83; // 34 + 49, 导航栏

/// 控件的默认高度
const CGFloat defaultHeight = 44;

/// 状态栏的高度
const CGFloat statusBarHeight = 20;


/// 所有设备网卡地址路径
NSString * const allDeviceMacAddressListPath =
    @"AllDeviceList.plist";

/// 命令执行完成
NSString * const commandExecutionComplete =
    @"SHCommandExecutionComplete";

/// 后台任务标示
NSString * const UIAPPLICATION_BACKGROUND_TASK_KEY =  @"UIApplicationBackgroundTaskKey";


/// App成为焦点的通知
NSString * const
    SHBecomeFocusNotification = @"SHBecomeFocusNotification";
