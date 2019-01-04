//
//  SHMood.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMood: NSObject {
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 场景ID
    var moodID: UInt = 0
    
    /// 场景名称
    var moodName: String?
    
    /// 场景图片名称
    var moodIconName: String?
    
    /// 是否是系统场景模式(不知道它有什么用, 保留旧代码中的参数, 【新版本弃用】)
    var  isSystemMood: UInt = 0

    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
