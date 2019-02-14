//
//  SHMacroCommand.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMacroCommand: NSObject {

    /// id号
    var id: UInt = 0
    
    /// macroID
    var macroID: UInt = 0
    
    /// remark
    var remark: String?

    /// subnetID
    var subnetID: UInt8 = 0
    
    /// deviceID
    var deviceID: UInt8 = 0
    
    /// commandTypeID
    var commandTypeID: UInt = 0
    
    /// 第一个参数
    var firstParameter: UInt = 0
    
    /// 第二个参数
    var secondParameter: UInt = 0
    
    /// 第三个参数
    var thirdParameter: UInt = 0
    
    /// 延时发送
    var delayMillisecondAfterSend: UInt = 0 {
        
        didSet {
            
            if (delayMillisecondAfterSend < 100) {
                
                delayMillisecondAfterSend = 100
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
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ...
        
        if key == "ID" {
            
            id = (value as? UInt) ?? 0
        }
    }
}
