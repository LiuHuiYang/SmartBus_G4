//
//  SHSchedualCommand.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/27.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHSchedualCommand: NSObject {

    /// 序号
    var id: UInt = 0
    
    /// 计划编号
    var scheduleID: UInt = 0
    
    /// 控制类型
    var typeID: SHSchdualControlItemType = .none 
    
    // MARK: - 6个可变参数，因场景而异
    
    /// Macro:(宏命令ID) MoodID  HVAC的子网ID
    var parameter1: UInt = 0
    
    ///  HVAC的设备ID
    var parameter2: UInt = 0
    
    /// HVAC的开关
    var parameter3: UInt = 0
    
    /// HVAC的风速等级
    var parameter4: UInt = 0
    
    /// HVAC的模式
    var parameter5: UInt = 0
    
    /// HVAC的模式温度
    var parameter6: UInt = 0
    
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
