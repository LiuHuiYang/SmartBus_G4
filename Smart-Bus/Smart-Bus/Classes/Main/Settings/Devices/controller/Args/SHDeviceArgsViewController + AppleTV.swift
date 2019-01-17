//
//  SHDeviceArgsViewController + AppleTV.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
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
        
        switch (index) {
            
        case 0:
            self.mediaAppleTV?.remark = value
            
        case 1:
            self.mediaAppleTV?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.mediaAppleTV?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.mediaAppleTV?.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            self.mediaAppleTV?.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            self.mediaAppleTV?.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            self.mediaAppleTV?.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            self.mediaAppleTV?.universalSwitchIDforUp = UInt(value) ?? 0
            
        case 8:
            self.mediaAppleTV?.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 9:
            self.mediaAppleTV?.universalSwitchIDforLeft = UInt(value) ?? 0
            
        case 10:
            self.mediaAppleTV?.universalSwitchIDforRight = UInt(value) ?? 0
            
        case 11:
            self.mediaAppleTV?.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 12:
            self.mediaAppleTV?.universalSwitchIDforMenu = UInt(value) ?? 0
            
        case 13:
            self.mediaAppleTV?.universalSwitchIDforPlayPause = UInt(value) ?? 0
            
        case 14:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart0 = UInt(value) ?? 0
            
        case 15:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart1 = UInt(value) ?? 0
            
        case 16:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart2 = UInt(value) ?? 0
            
        case 17:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart3 = UInt(value) ?? 0
            
        case 18:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart4 = UInt(value) ?? 0
            
        case 19:
            self.mediaAppleTV?.iRMacroNumberForAppleTVStart5 = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateMediaAppleTV(inZone: mediaAppleTV)
    }
}


