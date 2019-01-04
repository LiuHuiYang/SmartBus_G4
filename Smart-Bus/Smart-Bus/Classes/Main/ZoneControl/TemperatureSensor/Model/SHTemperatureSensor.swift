//
//  SHTemperatureSensor.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHTemperatureSensor: NSObject {

  
    /// 主键
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 备注
    var remark: String?
    
    /// 子网ID
    var subnetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 通道号码
    var channelNo: UInt8 = 0
    
    /// 当前区域的第几个
    var temperatureID: UInt = 0
    
    /// 当前的温度值，注意这个值有正负。
    var currentValue: Int = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ...
        
        if key.isEqual("ID") {
            
            id = value as? UInt ?? 0
        }
    }
}
