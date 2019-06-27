
//
//  SHConstraint.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/15.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#ifndef SHConstraint_h
#define SHConstraint_h

#import <UIKit/UIKit.h>

// ================= UI相关 ====
 
 
/// 导航栏高度
UIKIT_EXTERN const CGFloat navigationBarHeight;

/// 底部tabBar高度
UIKIT_EXTERN const CGFloat tabBarHeight;

/// 底部iPhoneX系统 tabBar高度
UIKIT_EXTERN const CGFloat tabBarHeight_iPhoneX_more;

/// 控件的默认高度
UIKIT_EXTERN const CGFloat defaultHeight;

/// 状态栏的高度
UIKIT_EXTERN const CGFloat statusBarHeight;

   
/// 所有设备网卡地址路径
UIKIT_EXTERN NSString * const allDeviceMacAddressListPath;

/// 命令执行完成
UIKIT_EXTERN NSString * const commandExecutionComplete;

/// 后台任务标示
UIKIT_EXTERN NSString * const UIAPPLICATION_BACKGROUND_TASK_KEY;

/// App成为焦点的通知
UIKIT_EXTERN NSString * const
    SHBecomeFocusNotification;

#endif /* SHConstraint_h */


