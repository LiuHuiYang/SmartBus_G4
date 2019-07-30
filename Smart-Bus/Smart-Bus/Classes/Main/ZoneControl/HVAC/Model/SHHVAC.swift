//
//  SHHVAC.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/24.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

@objc enum SHAirConditioningType: UInt8 {
    
    case hvac = 1   // HVAC
    case ir         // IR
    case relay      // 继电器控制
    case coolMaster // RS232桥接模块
}

/// 温度的默认范围
@objc enum SHAirConditioningTemperatureDefaultRange: UInt8 {
    
    case centigradeMinimumValue = 0
    case centigradeMaximumValue = 40
    
    case fahrenheitMinimumValue = 32
    case fahrenheitMaximumValue = 86
}

/// 空调的控制方式
@objc enum SHAirConditioningControlType: UInt8 {
    
    case none               = 0
    case onAndOff           = 0x03
    case coolTemperatureSet = 0x04
    case fanSpeedSet        = 0x05
    case acModeSet          = 0x06
    case heatTemperatureSet = 0x07
    case autoTemperatureSet = 0x08
}

/// 空调的开与关
@objc enum SHAirConditioningSwitchType: UInt8 {
    case off
    case on
}

/// 风速等级
@objc enum SHAirConditioningFanSpeedType: UInt8 {
    
    case auto
    case high
    case medial
    case low
}

/// 工作模式
@objc enum SHAirConditioningModeType: UInt8 {
    
    case cool
    case heat
    case fan
    case auto
}

@objcMembers class SHHVAC: NSObject {
    
    /// 是否同步scheduleCommand (这个参数是为了在页面切换的时间保持更新)
    var isUpdateSchedualCommand = true

    /// 启动配置计划
    var schedualEnable = false

    /// 计划执行的温度 (Schedual中需要的参数，模式是什么，就是设置哪个模式的温度)
    var schedualTemperature: Int = 0

    /// 计划执行的模式
    var schedualMode: SHAirConditioningModeType = .cool

    /// 计划执行的风速等级
    var schedualFanSpeed: SHAirConditioningFanSpeedType = .auto

    /// 计划执行的打开与关闭
    var schedualIsTurnOn = false

    // ============模型中的只存于内存的部分 ========
    
    /// 录制成功标示
    var recordSuccess = false
    
    /// 当前是华氏还是摄氏
    var isCelsius = true
    
    /// 打开状态
    var isTurnOn = false
    
    /// 环境温度
    var indoorTemperature: Int = 0
    
    /// 传感器温度
    var sensorTemperature: Int = 0
    
    /// 目标风速
    var fanSpeed: SHAirConditioningFanSpeedType = .auto
    
    /// 目标工作模式
    var acMode: SHAirConditioningModeType = .cool
    
    /// 通风模式的温度
    var coolTemperture: Int = 0
    
    /// 制热模式的温度
    var heatTemperture: Int = 0
    
    /// 自动模式的温度
    var autoTemperture: Int = 0

    // ====== 温度范围 有正负 (统一给定与smartcloud一样的默认值)
    
    // 制冷模式
    var startCoolTemperatureRange: Int = -9
    var endCoolTemperatureRange: Int = 99
    
    // 制热温度范围
    var startHeatTemperatureRange: Int = -9
    var endHeatTemperatureRange: Int = 99
    
    // 自动模式温度范围
    var startAutoTemperatureRange: Int = -9
    var endAutoTemperatureRange: Int = 99

    // ============模型中的存储数据库的部分 ========
    
    /// ID
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 区域子网ID
    var subnetID: UInt8 = 0
    
    /// 区域设备ID
    var deviceID: UInt8 = 0
    
    /// acNum(区分同一子网ID&&设备ID中的不同空调)
    var acNumber: UInt = 0
    
    /// 控制空调的类型(HVAC, IR ...)
    var acTypeID: SHAirConditioningType = .hvac
    
    /// 通道号(继电器控制空调需要用到， 其它类型一律置0)
    var channelNo: UInt8 = 0
    
    /// remark
    var acRemark: String = "ac"
    
    /// 室温传感器的通用子网ID
    var temperatureSensorSubNetID: UInt8 = 0
    
    /// 室温传感器的通用子网ID
    var temperatureSensorDeviceID: UInt8 = 0
    
    /// 室温传感器的通用子网ID
    var temperatureSensorChannelNo: UInt8 = 0

    
    // MARK: - 方法
    override init() {
        super.init()
    }
    
    init(dictionary: [String: Any]) {
        
        super.init()
        setValuesForKeys(dictionary)
        
//        hvac.id = [dictionary[@"id"] integerValue];
//        hvac.zoneID = [dictionary[@"ZoneID"] integerValue];
//        hvac.subnetID = [dictionary[@"SubnetID"] integerValue];
//        hvac.deviceID = [dictionary[@"DeviceID"] integerValue];
//        
//        hvac.acNumber = [dictionary[@"ACNumber"] integerValue];
//        hvac.acTypeID = [dictionary[@"ACTypeID"] integerValue];
//        
//        hvac.acRemark = (dictionary[@"ACRemark"] == [NSNull null]) ? @"HVAC" : dictionary[@"ACRemark"];
//        
//        hvac.channelNo = [dictionary[@"channelNo"] integerValue];
//        
//        hvac.temperatureSensorSubNetID = [[dictionary objectForKey:@"temperatureSensorSubNetID"] integerValue];
//        hvac.temperatureSensorDeviceID = [[dictionary objectForKey:@"temperatureSensorDeviceID"] integerValue];
//        hvac.temperatureSensorChannelNo = [[dictionary objectForKey:@"temperatureSensorChannelNo"] integerValue];
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "ACRemark" {
            
            acRemark = value as? String ?? "ac"
            return
        }
        
        if key == "ACTypeID" {
            
            acTypeID =
                SHAirConditioningType(
                    rawValue: value as? UInt8 ?? 0
                ) ?? .hvac
            
            return
        }
        
        if key == "ACNumber" {
            
            acNumber = (value as? UInt) ?? 0
            
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        // ...
    }
    
    
    // MARK: - 获得模式相关
    
    /// 获得HVAC的模式名称
    class func getModeName(_ acMode: SHAirConditioningModeType) -> String {
        
        let modes =
            SHLanguageTools.share()?.getTextFromPlist(
                "HVAC_IN_ZONE",
                withSubTitle: "MODE_BUTTON_NAMES"
            ) as! [String]
        
        switch acMode {
        
        case .cool:
            return modes[0]
            
        case .heat:
            return modes[1]
            
        case .fan:
            return modes[2]
        
        case .auto:
            return modes[3]
        default:
            break
        }
        
        return "N/A"
    }
    
    /// 获得风速的名称
    class func getFanSpeedName(_ fanSpeed: SHAirConditioningFanSpeedType) -> String {
        
        let fanNames =
            SHLanguageTools.share()?.getTextFromPlist(
                "HVAC_IN_ZONE",
                withSubTitle: "FAN_BUTTON_NAMES"
            ) as! [String]
        
        switch fanSpeed {
        
        case .low:
            return fanNames[0]
            
        case .medial:
            return fanNames[1]
            
        case .high:
            return fanNames[2]
            
        case .auto:
            return fanNames[3]
        
        default:
            break
        }
        
        return "N/A"
    }


    // MARK: - 温度转换
    
    /// 将获取到的温度转换为真实温度(表示负数的温度值)
    class func realTemperature(_ temperature: Int = 0) -> Int {

        return
            (temperature & 0x80) == 0 ?
                temperature :
                (0xFF - temperature + 1)
    }
    
    /// 摄像温度转换为华氏温度
    class func centigradeConvert(toFahrenheit temperature: Int) -> Int {
        
        return  Int(Double(temperature) * 1.8 + 32)
    }


}
