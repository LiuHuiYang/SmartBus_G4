//
//  SHSecurityZone.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHSecurityZone: NSObject {

    var id: UInt = 0
    
    var zoneID: UInt = 0
    
    var subnetID: UInt8 = 0
    
    var deviceID: UInt8 = 0
    
    var zoneNameOfSecurity: String?
    
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
