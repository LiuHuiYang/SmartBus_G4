//
//  SHSystem.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objc enum SHSystemDeviceType: UInt {

    case undefined
    
    case light
    
    case hvac
    
    case audio
    
    case shade
    
    case tv
    
    case dvd
    
    case sat
    
    case appletv
    
    case projector
    
    case mood
    
    case fan
    
    case floorHeating
    
    case nineInOne
    
    case dryContact
    
    case temperatureSensor
    
    case dmx
    
    case sceneControl
    
    case sequenceControl
    
    case otherControl
}

@objcMembers class SHSystem: NSObject {
    
    /// 系统ID
    var systemID: UInt = 0
    
    /// 系统ID
    var zoneID: UInt = 0

    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        // ...
    }
}
