//
//  SHZone.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHZone: NSObject {
    
    /// 地区ID(大分组)
    var regionID: UInt = 0
    
    /// 区域ID(小分组，类似于房间编号)
    var zoneID: UInt = 0
    
    /// 区域名称
    var zoneName: String?
    
    /// 区域图标名称
    var zoneIconName: String?
    
    override var description: String {
        
        return "zoneID: \(zoneID), zoneName: \(zoneName ?? ""),  zoneIconName: \(zoneIconName ?? "")"
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
        
    }
}
