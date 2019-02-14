//
//  SHRegion.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/15.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHRegion: NSObject {

    /// 地区ID(大分组)
    var regionID: UInt = 0
    
    /// 地区名称
    var regionName: String = "region"
    
    /// 地区图片名称
    var regionIconName: String = "DemoKit"
    
    override init() {
        super.init()
    }
    
    init(dictionary: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        // ...
    }
}
