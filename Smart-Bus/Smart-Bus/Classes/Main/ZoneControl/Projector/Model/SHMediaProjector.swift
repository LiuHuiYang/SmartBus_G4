//
//  SHMediaProjector.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMediaProjector: NSObject {

    /// 唯一ID
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 标记
    var remark: String?
    
    /// 子网ID
    var subnetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 打开ID
    var universalSwitchIDforOn: UInt = 0
    
    /// 开启状态
    var universalSwitchStatusforOn: UInt = 0
    
    /// 关闭ID
    var universalSwitchIDforOff: UInt = 0
    
    /// 关闭状态
    var universalSwitchStatusforOff: UInt = 0
    
    /// 上
    var universalSwitchIDfoUp: UInt = 0
    
    /// 下
    var universalSwitchIDforDown: UInt = 0
    
    /// 左
    var universalSwitchIDforLeft: UInt = 0
    
    ///  右
    var universalSwitchIDforRight: UInt = 0
    
    /// 确定
    var universalSwitchIDforOK: UInt = 0
    
    /// 源
    var universalSwitchIDforSource: UInt = 0
    
    /// 菜单
    var universalSwitchIDfoMenu: UInt = 0
    
    /// IR0
    var iRMacroNumberForProjectorSpare0: UInt = 0
    
    /// IR1
    var iRMacroNumberForProjectorSpare1: UInt = 0
    
    /// IR2
    var iRMacroNumberForProjectorSpare2: UInt = 0
    
    /// IR3
    var iRMacroNumberForProjectorSpare3: UInt = 0
    
    /// IR4
    var iRMacroNumberForProjectorSpare4: UInt = 0
    
    /// IR5
    var iRMacroNumberForProjectorSpare5: UInt = 0
    
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
