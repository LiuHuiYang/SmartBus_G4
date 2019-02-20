//
//  SHMediaSAT.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/7.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMediaSAT: NSObject {

    /// id
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    /// 标签
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
    var universalSwitchIDforUp: UInt = 0
    
    /// 下
    var universalSwitchIDforDown: UInt = 0
    
    /// 左
    var universalSwitchIDforLeft: UInt = 0
    
    /// 右
    var universalSwitchIDforRight: UInt = 0
    
    /// 确定
    var universalSwitchIDforOK: UInt = 0
    
    /// 菜单
    var universalSwitchIDfoMenu: UInt = 0
    
    /// fav
    var universalSwitchIDforFAV: UInt = 0
    
    /// 上一章
    var universalSwitchIDforPREVChapter: UInt = 0
    
    /// 下一章
    var universalSwitchIDforNextChapter: UInt = 0
    
    /// 开始录影
    var universalSwitchIDforPlayRecord: UInt = 0
    
    /// 停止录影
    var universalSwitchIDforPlayStopRecord: UInt = 0
    
    
    /// 数字0
    var universalSwitchIDfor0: UInt = 0
    
    /// 数字1
    var universalSwitchIDfor1: UInt = 0
    
    /// 数字2
    var universalSwitchIDfor2: UInt = 0
    
    /// 数字3
    var universalSwitchIDfor3: UInt = 0
    
    /// 数字4
    var universalSwitchIDfor4: UInt = 0
    
    /// 数字5
    var universalSwitchIDfor5: UInt = 0
    
    /// 数字6
    var universalSwitchIDfor6: UInt = 0
    
    /// 数字7
    var universalSwitchIDfor7: UInt = 0
    
    /// 数字8
    var universalSwitchIDfor8: UInt = 0
    
    /// 数字9
    var universalSwitchIDfor9: UInt = 0
    
    
    /// IR0
    var iRMacroNumberForSATSpare0: UInt = 0
    
    /// IR1
    var iRMacroNumberForSATSpare1: UInt = 0
    
    /// IR2
    var iRMacroNumberForSATSpare2: UInt = 0
    
    /// IR3
    var iRMacroNumberForSATSpare3: UInt = 0
    
    /// IR4
    var iRMacroNumberForSATSpare4: UInt = 0
    
    /// IR5
    var iRMacroNumberForSATSpare5: UInt = 0
    
    /// C1名称
    var switchNameforControl1: String?
    
    /// C1ID
    var switchIDforControl1: UInt = 0
    
    /// C2名称
    var switchNameforControl2: String?
    
    /// C2ID
    var switchIDforControl2: UInt = 0
    
    /// C3名称
    var switchNameforControl3: String?
    
    /// C3ID
    var switchIDforControl3: UInt = 0
    
    /// C4名称
    var switchNameforControl4: String?
    
    /// C4ID
    var switchIDforControl4: UInt = 0
    
    /// C5名称
    var switchNameforControl5: String?
    
    /// C5ID
    var switchIDforControl5: UInt = 0
    
    /// C6名称
    var switchNameforControl6: String?
    
    /// C6ID
    var switchIDforControl6: UInt = 0
    
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "ID"  {
            
            id = value as? UInt ?? 0
            return
            
        } else if key == "UniversalSwitchIDfor0" {
            
            universalSwitchIDfor0 = (value as? UInt ?? 0)
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ...
    }
}
