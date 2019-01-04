//
//  SHMediaSATCategory.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMediaSATCategory: NSObject {

    /// 分类ID
    var categoryID: UInt = 0
    
    /// 场景序号
    var sequenceNo: UInt = 0
    
    /// 区域ID (没有什么用, 全是0 )
    var zoneID: UInt = 0
    
    /// 分类名称
    var categoryName: String?
    
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
