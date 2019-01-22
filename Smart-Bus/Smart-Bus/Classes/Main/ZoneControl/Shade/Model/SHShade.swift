//
//  SHShade.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 窗帘状态
@objc enum SHShadeStatus: UInt {
    
    case unKnow
    case open
    case close
    case stop
}

/// /// 窗帘控制命令的类型
@objc enum SHShadeCommandType: UInt {
    
    case close
    case open
    case stop
}

@objc enum SHShadeControlType: UInt {
    
    case defaultControl    // 默认是使用继电器的控制的方式
    case universalSwitch   // 通用开关
    case pushOnReleaseOff  // 按住动作，松开停下
}

@objcMembers class SHShade: NSObject {

    // ==================内存中的属性==============
    
    /// 录制成功标示
    var recordSuccess: Bool = false
    
    /// 当前的窗帘的状态
    var currentStatus: SHShadeStatus = .unKnow
    
    // ==================数据库中的属性==============
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 窗帘ID
    var shadeID: UInt = 0
    
    /// 名称
    var shadeName: String = "curtain"
    
    /// 是否有停止键
    var hasStop: UInt8 = 0
    
    /// 窗帘 子网ID
    var subnetID: UInt8 = 0
    
    /// 窗帘 设备ID
    var deviceID: UInt8 = 0
    
    /// 打开通道
    var openChannel: UInt8 = 0
    
    /// 窗帘开启比例
    var openingRatio: UInt8 = 0
    
    /// 关闭通道
    var closeChannel: UInt8 = 0
    
    /// 窗帘关闭比例
    var closingRatio: UInt8 = 0
    
    /// 停止通道
    var stopChannel: UInt8 = 0
    
    /// 窗帘停止比例
    var stoppingRatio: UInt8 = 0
    
    /// 窗帘 保留参数一 (继电器控制时的延时参数，以备将来有用)
    var reserved1: UInt = 0
    
    /// 窗帘 保留参数参数二
    var reserved2: UInt = 0
    
    /// 开启的备注名称
    var remarkForOpen: String = "open"
    
    /// 关闭的备注名称
    var remarkForClose: String = "close"
    
    /// 停止的备注名称
    var remarkForStop: String = "stop"
    
    /// 窗帘的的操作方式
    var controlType: SHShadeControlType = .defaultControl
    
    /// 使用其它方式打开窗帘的代号数字
    var switchIDforOpen: UInt = 0
    
    /// 使用其它方式打开窗帘的状态
    var switchIDStatusforOpen: UInt = 0
    
    /// 使用其它方式关闭窗帘的代号数字
    var switchIDforClose: UInt = 0
    
    /// 使用其它方式打开窗帘的状态
    var switchIDStatusforClose: UInt = 0
    
    /// 使用其它方式停止窗帘的代号数字
    var switchIDforStop: UInt = 0
    
    /// 使用其它方式停止窗帘的状态数字
    var switchIDStatusforStop: UInt = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        // ...
    }
}
