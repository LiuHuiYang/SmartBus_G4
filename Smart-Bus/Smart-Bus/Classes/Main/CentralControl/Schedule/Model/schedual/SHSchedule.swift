//
//  SHSchedule.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/20.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit


/// 计划执行类型
enum SHSchdualControlItemType: UInt {
    
    case none
    case marco
    case mood
    case light
    case hvac
    case audio
    case shade
    case floorHeating
}


/// 执行的频率
///
/// - oneTime: 执行一次
/// - dayily: 每天执行
/// - weekly: 按星期执行
enum SHSchdualFrequency: UInt {
    
    case oneTime
    case dayily
    case weekly
}


/// 星期
enum SHSchdualWeek: UInt8 {
    
    case none
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

@objcMembers class SHSchedule: NSObject {

    /// 命令集合
    lazy var commands = [SHSchedualCommand]()
    
    /// 记录的序号
    var id: UInt = 0
    
    /// 计划的序号
    var scheduleID: UInt = 0
    
    /// 计划的名称
    var scheduleName: String = "schedule"
    
    /// 是否开启计划
    var enabledSchedule: Bool = false
    
    /// 控制类型 (这个参数也没有什么用, 兼容旧版本, 类型控制会在command中体现)
    var controlledItemID: SHSchdualControlItemType = .none
    
    /// 区域ID (数据库使用的是 TEXT, 兼容旧版本, 这个参数没有什么用)
    var zoneID: UInt = 0
    
    /// 执行频率 (数据库使用的是 TEXT)
    var frequencyID: SHSchdualFrequency = .oneTime
    
    /// 执行的是星期天
    var withSunday: Bool = false
    
    /// 执行的是星期一
    var withMonday: Bool = false
    
    /// 执行的是星期二
    var withTuesday: Bool = false
    
    /// 执行的是星期三
    var withWednesday: Bool = false
    
    /// 执行的是星期四
    var withThursday: Bool = false
    
    /// 执行的是星期五
    var withFriday: Bool = false
    
    /// 执行的是星期六
    var withSaturday: Bool = false
    
    /// 执行的小时 [TEXT]
    var executionHours: UInt8 = 0
    
    /// 执行的分钟 [TEXT]
    var executionMins: UInt8 = 0
    
    /// 执行的日期
    var executionDate: String = ""
    
    /// 是否配置了声音
    var haveSound: Bool = false
    
    override init() {
        super.init()
    }
    
    /// 字体创建
    init(dictionary: [String: Any]) {
        super.init()
        setValuesForKeys(dictionary)
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        switch key {
        case "ExecutionHours":
            executionHours =
                UInt8(value as? String ?? "") ?? 0
            
        case "ExecutionMins":
            executionMins =
                UInt8(value as? String ?? "") ?? 0
            
        case "ZoneID":
            zoneID = value as? UInt ?? 0
            
        case "FrequencyID":
              
           frequencyID =
            SHSchdualFrequency(rawValue:
                UInt(value as? String ?? "") ?? 0
            ) ?? .oneTime
            
        default:
            super.setValue(value, forKey: key)
        }
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        print("没有设置 \(key) - \(value)")
    }
}


// MARK: - 获得执行的星期
extension SHSchedule {
    
    /// 获得需要执行的具体星期日期
    ///
    /// - Returns: 星期枚举数组
    func getExecutWeekDays() -> [SHSchdualWeek] {
        
        var weeks = [SHSchdualWeek]()
        
        if withSunday {
            
            weeks.append(.sunday)
        }
        
        if withMonday {
            
            weeks.append(.monday)
        }
        
        if withTuesday {
            
            weeks.append(.tuesday)
        }
        
        if withWednesday {
            
            weeks.append(.wednesday)
        }
        
        if withThursday {
            
            weeks.append(.thursday)
        }
        
        if withFriday {
            
            weeks.append(.friday)
        }
        
        if withSaturday {
            
            weeks.append(.saturday)
        }
        
        return weeks
    }
}
