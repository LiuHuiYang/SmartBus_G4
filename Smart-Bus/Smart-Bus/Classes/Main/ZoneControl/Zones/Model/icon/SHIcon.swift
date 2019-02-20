//
//  SHIcon.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHIcon: NSObject {

    /// 图标ID
    var iconID: UInt = 0
    
    /// 图标名称
    var iconName: String?
    
    /// 图片二进制
    var iconData: Data?
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        // ...
        
    }
}
