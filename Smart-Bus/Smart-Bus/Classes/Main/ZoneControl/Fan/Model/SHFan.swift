//
//  SHFan.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/**
 风速
 
 - SHFanSpeedOFF: 关闭风扇
 - SHFanSpeedLow: 低风速
 - SHFanSpeedMiddle: 中风速
 - SHFanSpeedHigh: 高风速
 - SHFanSpeedFull: 全速
 */
@objc enum SHFanSpeed: UInt8 {
    
    case off = 0
    case low = 1
    case middle = 2
    case high = 3
    case full = 100
}

/// 风扇类型
@objc enum SHFanType: UInt {
    case unknow
    case one
    case two
    case three
    case four
}

@objcMembers class SHFan: NSObject {

    // ========  动态变化 && 不需要存储于数据库的内容
    
    /// 风速档位
    var fanSpeed: SHFanSpeed = .off
    
    // ========== 数据库需要存储的东西 =================
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 风扇ID
    var fanID: UInt = 0
    
    /// 风扇名称
    var fanName: String?
    
    /// 风扇子网ID
    var subnetID: UInt8 = 0
    
    /// 风扇设备ID
    var deviceID: UInt8 = 0
    
    /// 风扇 通道
    var channelNO: UInt8 = 0
    
    /// 风扇 类型
    var fanTypeID: SHFanType = .unknow
    
    /// 风扇备注
    var remark: String?
    
    /// 风扇 保留参数
    var reserved1: UInt = 0
    
    /// 风扇 保留参数
    var reserved2: UInt = 0
    
    /// 风扇 保留参数
    var reserved3: UInt = 0
    
    /// 风扇 保留参数
    var reserved4: UInt = 0
    
    /// 风扇 保留参数
    var reserved5: UInt = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key.isEqual("Reserved1") {
            
            reserved1 = (value as? UInt) ?? 0
        
        } else if key.isEqual("Reserved2") {
            
            reserved2 = (value as? UInt) ?? 0
        
        } else if key.isEqual("Reserved3") {
            
            reserved3 = (value as? UInt) ?? 0
        
        } else if key.isEqual("Reserved4") {
            
            reserved4 = (value as? UInt) ?? 0
        
        } else if key.isEqual("Reserved5") {
            
            reserved5 = (value as? UInt) ?? 0
        
        } else {
            
             super.setValue(value, forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        // ...
    }
}
