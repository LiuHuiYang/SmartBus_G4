//
//  SHCurrentTransformer.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
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
    var remark: String = "CT24"
    
    /// 电源电压
    var voltage: UInt = 0 {
        
        didSet {
            
            if voltage <= 1 {
                
                voltage = 1
            }
        }
    }
    
    var channel1: String  = "CH1"
    var channel2: String  = "CH2"
    var channel3: String  = "CH3"
    var channel4: String  = "CH4"
    var channel5: String  = "CH5"
    var channel6: String  = "CH6"
    var channel7: String  = "CH7"
    var channel8: String  = "CH8"
    var channel9: String  = "CH9"
    var channel10: String = "CH10"
    var channel11: String = "CH11"
    var channel12: String = "CH12"
    var channel13: String = "CH13"
    var channel14: String = "CH14"
    var channel15: String = "CH15"
    var channel16: String = "CH16"
    var channel17: String = "CH17"
    var channel18: String = "CH18"
    var channel19: String = "CH19"
    var channel20: String = "CH20"
    var channel21: String = "CH21"
    var channel22: String = "CH22"
    var channel23: String = "CH23"
    var channel24: String = "CH24"
    
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
