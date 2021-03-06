//
//  SHCentralLight.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHCentralLight: NSObject {
    
    /// id号
    var id: UInt = 0
    
    /// floorID
    var floorID: UInt = 0
    
    /// floorName
    var floorName: String?
    
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
