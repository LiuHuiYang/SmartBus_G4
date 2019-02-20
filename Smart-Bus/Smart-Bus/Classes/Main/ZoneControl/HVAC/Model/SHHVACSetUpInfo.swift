//
//  SHHVACSetUpInfo.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHHVACSetUpInfo: NSObject {

    /// id
    var id: UInt = 0
    
    /// 采用摄氏温度
    var isCelsius: Bool = false
    
    /// 制冷温度
    var tempertureOfCold: UInt = 0
    
    /// 凉快温度
    var tempertureOfCool: UInt = 0
    
    /// 暖和温度
    var tempertureOfWarm: UInt = 0
    
    /// 制热温度
    var tempertureOfHot: UInt = 0
    
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
