//
//  SHFloorHeating.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/18.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

// MARK: - 操作相关的枚举

// 开关
@objc enum SHFloorHeatingSwitchType: UInt8 {
    case off = 0
    case on = 1
}

/// 控制类型
@objc enum SHFloorHeatingControlType: UInt8 {
    
    case onAndOff = 0x14         // 开关
    case modelSet = 0x15         // 模式切换
    case temperatureSet = 0x17   // 手动温度设置
}

/// 工作模式
@objc enum SHFloorHeatingModeType: UInt8 {
    
    case manual  = 1
    case day     = 2
    case night   = 3
    case away    = 4
    case timer   = 5
}

//// 温度范围  地热先是固定死了，如果配置可调，则参考HVAC来进行增加属性
@objc enum SHFloorHeatingManualTemperatureRange: UInt8 {
    
    case centigradeMinimumValue = 5
    case centigradeMaximumValue = 32
    
    case fahrenheitMinimumValue = 41
    case fahrenheitMaximumValue = 90
}

@objcMembers class SHFloorHeating: NSObject {
    
    /// 启动配置计划
    var schedualEnable = false
    
    /// 计划执行的手动模式温度 
    var schedualTemperature: Int = 0
    
    /// 计划执行的模式
    var schedualModeType: SHFloorHeatingModeType = .manual
  
    /// 计划执行的打开与关闭
    var schedualIsTurnOn = false
    
    // MARK: - =========
    
    /// 录制状态标示
    var recordSuccess = false

    /// 打开状态
    var isTurnOn: Bool = false
    
    /// 地热模式
    var floorHeatingModeType: SHFloorHeatingModeType = .manual
    
    /// 定时器使能
    var timerEnable: Bool = false
    
    /// 手动模式下的温度  -- 代码统一使用摄氏度
    var manualTemperature: Int = 0
    
    /// 自天模式下的温度  -- 代码统一使用摄氏度
    var dayTemperature: Int = 0
    
    /// 夜间模式下的温度  -- 代码统一使用摄氏度
    var nightTemperature: Int = 0
    
    /// 离开模式下的温度  -- 代码统一使用摄氏度
    var awayTemperature: Int = 0
    
    /// 室内温度传感器的子网ID
    var insideSensorSubNetID: UInt8 = 0
    
    /// 室内温度传感器的设备ID
    var insideSensorDeviceID: UInt8 = 0
    
    /// 室内温度传感器的通道号
    var insideSensorChannelNo: UInt8 = 0
    
    // MARK: - 定时器的时间段
    
    /// 白天开始时间的时
    var dayTimeHour: UInt8 = 0
    
    /// 白天开始时间的分
    var dayTimeMinute: UInt8 = 0
    
    /// 白天结束时间的时
    var nightTimeHour: UInt8 = 0
    
    /// 白天结束时间的分
    var nightTimeMinute: UInt8 = 0
    
    // 室内温度 (有正负)
    var insideTemperature: Int = 0
    
    // 室外温度 (有正负)
    var outsideTemperature: Int = 0
    
    // MARK: - 数据库信息
    
    /// 主键
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// FloorHeatingID (默认使用1，用来更新参数的时候，确定是哪一个地热，尽量不使用id)
    var floorHeatingID: UInt = 0
    
    /// FloorHeatingID备注
    var floorHeatingRemark: String = "floor heating"
    
    /// FloorHeatingID子网ID
    var subnetID: UInt8 = 0
    
    /// FloorHeatingID设备ID
    var deviceID: UInt8 = 0
    
    /// FloorHeatingID通道
    var channelNo: UInt8 = 0
    
    /// 室外温度传感器的子网ID
    var outsideSensorSubNetID: UInt8 = 0
    
    /// 室外温度传感器的设备ID
    var outsideSensorDeviceID: UInt8 = 0
    
    /// 室外温度传感器的通道号
    var outsideSensorChannelNo: UInt8 = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ...
        
        if key == "ID" {
            
            id = (value as? UInt) ?? 0
        }
    }
}
