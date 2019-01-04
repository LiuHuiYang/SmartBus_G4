//
//  SHCentralHVACCommand.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHCentralHVACCommand: NSObject {

    /// ID
    var id: UInt = 0
    
    /// floorID
    var floorID: UInt = 0
    
    /// subnetID
    var subnetID: UInt8 = 0
    
    /// deviceID
    var deviceID: UInt8 = 0
    
    /// remark
    var remark: String?
    
    /// commandID (这个还有发现有什么用)
    var commandID: UInt = 0
    
    /// commandTypeID
    var commandTypeID: UInt = 0
    
    /// parameter1
    var parameter1: UInt = 0
    
    /// parameter2
    var parameter2: UInt = 0
    
    /// delayMillisecondAfterSend
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
