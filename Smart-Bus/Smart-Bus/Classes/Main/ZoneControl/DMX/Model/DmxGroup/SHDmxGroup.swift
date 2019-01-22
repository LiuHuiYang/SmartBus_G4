//
//  SHDmxGroup.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHDmxGroup: NSObject {

    /// 唯一ID号
    var id: UInt = 0
    
    /// 组ID
    var groupID: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 分组标题
    var groupName: String = "dmx group"
    
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
            
            id = value as? UInt ?? 0
        }
    }
}
