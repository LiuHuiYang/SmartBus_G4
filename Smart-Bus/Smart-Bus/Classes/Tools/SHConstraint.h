
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

/// UIPickerView的默认高度(216)
UIKIT_EXTERN const CGFloat pickerViewHeight;

/// 灯泡的最大亮度值
UIKIT_EXTERN const Byte lightMaxBrightness;

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

/// 远程登录的开关
UIKIT_EXTERN NSString * const remoteControlKey;

/// 远程登录用户名
UIKIT_EXTERN NSString * const loginAccout;

/// 远程登录服务名
UIKIT_EXTERN NSString * const loginServices;

/// 用户指定发送数据的IP地址，没有指定使用 255
UIKIT_EXTERN NSString * const socketRealIP;

/// 选择的设备网卡地址
UIKIT_EXTERN NSString * const selectMacAddress;

/// 所有设备网卡地址路径
UIKIT_EXTERN NSString * const allDeviceMacAddressListPath;

/// 命令执行完成
UIKIT_EXTERN NSString * const commandExecutionComplete;

/// 安防密码的key
UIKIT_EXTERN NSString * const securityPasswordKey;

/// 允许修改区域设备是否允许的key
UIKIT_EXTERN NSString * const authorChangeDeviceisAllow;

/// 启与关闭修改设备配置的密码的key
UIKIT_EXTERN NSString * const authorChangeDevicePasswordKey;


/// 计划执行的通知
UIKIT_EXTERN NSString * const SHSchedualPrepareExecuteNotification;

/// 编辑卫星电视分类名称的结束通知
UIKIT_EXTERN NSString * const SHMediaSATCategoryEditCategoryFinishedNotification;


/// 后台任务标示
UIKIT_EXTERN NSString * const UIAPPLICATION_BACKGROUND_TASK_KEY;

#endif /* SHConstraint_h */


