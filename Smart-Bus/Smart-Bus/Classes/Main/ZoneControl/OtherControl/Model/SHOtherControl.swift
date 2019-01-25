//
//  SHOtherControl.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

@objc enum SHOtherControlType: UInt8 {
    
    case singleChannelControl
    case interLockControl
    case logicControl
}

@objcMembers class SHOtherControl: NSObject {
    
    /// 主键
    var id : UInt8 = 0
    
    /// 当前区域第几个
    var otherControlID : UInt = 0
    
    /// 区域 ID
    var zoneID : UInt = 0
    
    /// 别名
    var remark : String = "OtherControl"
    
    /// 控制类型
    var controlType : SHOtherControlType
        = .singleChannelControl
    
    /// 子网ID
    var subnetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 可变参数1 (单通道控制的通道号， 逻辑控制的开通道)
    var parameter1: UInt8 = 0
    
    /// 可变参数2 逻辑控制的关通道)
    var parameter2: UInt8 = 0
    
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
