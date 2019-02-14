//
//  SHDeviceArgsViewController + AppleTV.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - AppleTV
extension SHDeviceArgsViewController {
    
    func refreshMediaAppleTV() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            
            "turnOn ID",
            "StatusforOn",
            "turnOff ID",
            "StatusforOff",
            
            "turn Up",
            "turn Down",
            "turn Left",
            "turn Right",
            "OK",
            "Menu",
            "Pause",
            
            "IRReserved_0",
            "IRReserved_1",
            "IRReserved_2",
            "IRReserved_3",
            "IRReserved_4",
            "IRReserved_5"
        ]
        
        argsValues = [
            
            mediaAppleTV?.remark ?? "Apple TV",
            "\(mediaAppleTV?.subnetID ?? 1)",
            "\(mediaAppleTV?.deviceID ?? 0)",
            
            "\(mediaAppleTV?.universalSwitchIDforOn ?? 0)",
            "\(mediaAppleTV?.universalSwitchStatusforOn ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforOff ?? 0)",
            "\(mediaAppleTV?.universalSwitchStatusforOff ?? 0)",
            
            "\(mediaAppleTV?.universalSwitchIDforUp ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforDown ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforLeft ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforRight ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforOK ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforMenu ?? 0)",
            "\(mediaAppleTV?.universalSwitchIDforPlayPause ?? 0)",
            
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart0 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart1 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart2 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart3 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart4 ?? 0)",
            "\(mediaAppleTV?.iRMacroNumberForAppleTVStart5 ?? 0)",
        ]
    }
    
    /// 保存AppleTV
    func updateMediaAppleTV(value: String, index: Int) {
        
        guard let tv = self.mediaAppleTV else {
            return
        }
        
        switch (index) {
            
        case 0:
            tv.remark = value
            
        case 1:
            tv.subnetID = UInt8(value) ?? 1
            
        case 2:
            tv.deviceID = UInt8(value) ?? 0
            
        case 3:
            tv.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            tv.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            tv.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            tv.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            tv.universalSwitchIDforUp = UInt(value) ?? 0
            
        case 8:
            tv.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 9:
            tv.universalSwitchIDforLeft = UInt(value) ?? 0
            
        case 10:
            tv.universalSwitchIDforRight = UInt(value) ?? 0
            
        case 11:
            tv.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 12:
            tv.universalSwitchIDforMenu = UInt(value) ?? 0
            
        case 13:
            tv.universalSwitchIDforPlayPause = UInt(value) ?? 0
            
        case 14:
            tv.iRMacroNumberForAppleTVStart0 = UInt(value) ?? 0
            
        case 15:
            tv.iRMacroNumberForAppleTVStart1 = UInt(value) ?? 0
            
        case 16:
            tv.iRMacroNumberForAppleTVStart2 = UInt(value) ?? 0
            
        case 17:
            tv.iRMacroNumberForAppleTVStart3 = UInt(value) ?? 0
            
        case 18:
            tv.iRMacroNumberForAppleTVStart4 = UInt(value) ?? 0
            
        case 19:
            tv.iRMacroNumberForAppleTVStart5 = UInt(value) ?? 0
            
        default:
            break
        }
         
        _ = SHSQLiteManager.shared.updateAppleTV(tv)
    }
}


