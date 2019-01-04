//
//  SHMediaTV.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMediaTV: NSObject {

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
    
    
    /// 增加(频道)
    var universalSwitchIDforCHAdd: UInt = 0
    
    /// 减小(频道)
    var universalSwitchIDforCHMinus: UInt = 0
    
    /// 声音加大
    var universalSwitchIDforVOLUp: UInt = 0
    
    /// 声音降低
    var universalSwitchIDforVOLDown: UInt = 0
    
    /// 静音
    var universalSwitchIDforMute: UInt = 0
    
    /// 菜单
    var universalSwitchIDforMenu: UInt = 0
    
    /// 源
    var universalSwitchIDforSource: UInt = 0
    
    /// 确定
    var universalSwitchIDforOK: UInt = 0
    
    
    /// 数字按键0
    var universalSwitchIDfor0: UInt = 0
    
    /// 数字按键1
    var universalSwitchIDfor1: UInt = 0
    
    /// 数字按键2
    var universalSwitchIDfor2: UInt = 0
    
    /// 数字按键3
    var universalSwitchIDfor3: UInt = 0
    
    /// 数字按键4
    var universalSwitchIDfor4: UInt = 0
    
    /// 数字按键5
    var universalSwitchIDfor5: UInt = 0
    
    /// 数字按键6
    var universalSwitchIDfor6: UInt = 0
    
    /// 数字按键7
    var universalSwitchIDfor7: UInt = 0
    
    /// 数字按键8
    var universalSwitchIDfor8: UInt = 0
    
    /// 数字按键9
    var universalSwitchIDfor9: UInt = 0
    
    
    /// IR0
    var iRMacroNumberForTVStart0: UInt = 0
    
    /// IR1
    var iRMacroNumberForTVStart1: UInt = 0
    
    /// IR2
    var iRMacroNumberForTVStart2: UInt = 0
    
    /// IR3
    var iRMacroNumberForTVStart3: UInt = 0
    
    /// IR4
    var iRMacroNumberForTVStart4: UInt = 0
    
    /// IR5
    var iRMacroNumberForTVStart5: UInt = 0

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
