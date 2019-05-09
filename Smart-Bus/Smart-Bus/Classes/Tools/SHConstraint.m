//
//  SHConstraint.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/15.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#include "SHConstraint.h"

// =================UI相关 ====


/// UIPickerView的默认高度(216)
const CGFloat pickerViewHeight = 216;

/// 灯泡的最大亮度值
const Byte lightMaxBrightness = 100;

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
 
/// 远程登录的开关
NSString * const remoteControlKey =
    @"SHTurnOnRemoteControlKey";

/// 远程登录用户名
NSString * const loginAccout =
    @"SHRemoteTelnetAccount";

/// 远程登录服务名
NSString * const loginServices =
    @"SHRemoteTelnetServices";

/// 用户指定发送数据的IP地址，没有指定使用 255
NSString * const socketRealIP =
    @"SHUdpSocketSendDataRealIPAddress";

/// 选择的设备网卡地址
NSString * const selectMacAddress =
    @"SHSelectDeviceMacAddress.data";

/// 所有设备网卡地址路径
NSString * const allDeviceMacAddressListPath =
    @"AllDeviceList.plist";

/// 命令执行完成
NSString * const commandExecutionComplete =
    @"SHCommandExecutionComplete";

/// 安防密码的key
NSString * const securityPasswordKey =
    @"SHSecurityPasswordKey";

/// 允许修改区域设备是否允许的key
NSString * const authorChangeDeviceisAllow = @"SHAuthorChangeDeviceisAllow";

/// 启与关闭修改设备配置的密码的key
NSString * const authorChangeDevicePasswordKey =
    @"SHAuthorChangeDevicePasswordKey";

/// 计划执行的通知
NSString * const SHSchedualPrepareExecuteNotification =
    @"SHSchedualPrepareExecuteNotification";


/// 后台任务标示
NSString * const UIAPPLICATION_BACKGROUND_TASK_KEY =  @"UIApplicationBackgroundTaskKey";


/// App成为焦点的通知
NSString * const
    SHBecomeFocusNotification = @"SHBecomeFocusNotification";

