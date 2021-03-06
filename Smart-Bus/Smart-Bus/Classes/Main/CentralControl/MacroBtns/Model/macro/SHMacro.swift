//
//  SHMacro.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import Foundation

@objcMembers class SHMacro: NSObject {
    
    /// 启动配置计划
    var scheduleEnable = false
    
    /// id号
    var id: UInt = 0
    
    /// macroID
    var macroID: UInt = 0
    
    /// macroName
    var macroName: String?
    
    /// macroIconName
    var macroIconName: String? {
        
        didSet {
            
            if macroIconName == "MacroIconName" {
                
                macroIconName = "Romatic"
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ...
        
        if key == "ID" {
           
            id = value as? UInt ?? 0
        }
    }
}
