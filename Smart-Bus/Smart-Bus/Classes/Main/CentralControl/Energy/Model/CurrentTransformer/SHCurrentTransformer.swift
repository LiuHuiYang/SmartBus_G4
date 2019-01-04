//
//  SHCurrentTransformer.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHCurrentTransformer: NSObject {

    /// id号
    var id: UInt = 0
    
    /// 传感器ID
    var  currentTransformerID: UInt = 0
    
    /// 风扇子网ID
    var subnetID: UInt8 = 0
    
    /// 风扇设备ID
    var deviceID: UInt8 = 0
    
    /// 设备标示
    var remark: String?
    
    /// 电源电压
    var voltage: UInt = 0 {
        
        didSet {
            
            if voltage <= 1 {
                
                voltage = 1
            }
        }
    }
    
    var channel1: String?
    var channel2: String?
    var channel3: String?
    var channel4: String?
    var channel5: String?
    var channel6: String?
    var channel7: String?
    var channel8: String?
    var channel9: String?
    var channel10: String?
    var channel11: String?
    var channel12: String?
    var channel13: String?
    var channel14: String?
    var channel15: String?
    var channel16: String?
    var channel17: String?
    var channel18: String?
    var channel19: String?
    var channel20: String?
    var channel21: String?
    var channel22: String?
    var channel23: String?
    var channel24: String?
    
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
