//
//  SHMediaDVD.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMediaDVD: NSObject {
    
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
    
    /// 打开
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
    
    /// 快进
    var universalSwitchIDforFastForward: UInt = 0
    
    /// 快退
    var universalSwitchIDforBackForward: UInt = 0
    
    /// 确定
    var universalSwitchIDforOK: UInt = 0
    
    /// 上一章
    var universalSwitchIDforPREVChapter: UInt = 0
    
    /// 下一章
    var universalSwitchIDforNextChapter: UInt = 0
    
    /// 暂停
    var universalSwitchIDforPlayPause: UInt = 0
    
    /// 开始录影
    var universalSwitchIDforPlayRecord: UInt = 0
    
    /// 停止录影
    var universalSwitchIDforPlayStopRecord: UInt = 0
    
    /// 菜单
    var universalSwitchIDfoMenu: UInt = 0
    
    /// IR0
    var iRMacroNumberForDVDStart0: UInt = 0
    
    /// IR1
    var iRMacroNumberForDVDStart1: UInt = 0
    
    /// IR2
    var iRMacroNumberForDVDStart2: UInt = 0
    
    /// IR3
    var iRMacroNumberForDVDStart3: UInt = 0
    
    /// IR4
    var iRMacroNumberForDVDStart4: UInt = 0
    
    /// IR5
    var iRMacroNumberForDVDStart5: UInt = 0

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
