//
//  SHDeviceArgsViewController + Projector.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - Projector
extension SHDeviceArgsViewController {
    
    func refreshMediaProjector() {
        
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
            "Source",
            
            "IRReserved_0",
            "IRReserved_1",
            "IRReserved_2",
            "IRReserved_3",
            "IRReserved_4",
            "IRReserved_5"
        ]
        
        argsValues = [
            
            mediaProjector?.remark ?? "projector",
            "\(mediaProjector?.subnetID ?? 1)",
            "\(mediaProjector?.deviceID ?? 0)",
            
            "\(mediaProjector?.universalSwitchIDforOn ?? 0)",
            "\(mediaProjector?.universalSwitchStatusforOn ?? 0)",
            "\(mediaProjector?.universalSwitchIDforOff ?? 0)",
            "\(mediaProjector?.universalSwitchStatusforOff ?? 0)",
            
            "\(mediaProjector?.universalSwitchIDfoUp ?? 0)",
            "\(mediaProjector?.universalSwitchIDforDown ?? 0)",
            "\(mediaProjector?.universalSwitchIDforLeft ?? 0)",
            "\(mediaProjector?.universalSwitchIDforRight ?? 0)",
            "\(mediaProjector?.universalSwitchIDforOK ?? 0)",
            "\(mediaProjector?.universalSwitchIDfoMenu ?? 0)",
            "\(mediaProjector?.universalSwitchIDforSource ?? 0)",
            
            "\(mediaProjector?.iRMacroNumberForProjectorSpare0 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare1 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare2 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare3 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare4 ?? 0)",
            "\(mediaProjector?.iRMacroNumberForProjectorSpare5 ?? 0)"
        ]
    }
    
    /// 保存投影仪
    func updateMediaProjector(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.mediaProjector?.remark = value
            
        case 1:
            self.mediaProjector?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.mediaProjector?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.mediaProjector?.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            self.mediaProjector?.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            self.mediaProjector?.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            self.mediaProjector?.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            self.mediaProjector?.universalSwitchIDfoUp = UInt(value) ?? 0
            
        case 8:
            self.mediaProjector?.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 9:
            self.mediaProjector?.universalSwitchIDforLeft = UInt(value) ?? 0
            
        case 10:
            self.mediaProjector?.universalSwitchIDforRight = UInt(value) ?? 0
            
        case 11:
            self.mediaProjector?.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 12:
            self.mediaProjector?.universalSwitchIDfoMenu = UInt(value) ?? 0
            
        case 13:
            self.mediaProjector?.universalSwitchIDforSource = UInt(value) ?? 0
            
        case 14:
            self.mediaProjector?.iRMacroNumberForProjectorSpare0 = UInt(value) ?? 0
            
        case 15:
            self.mediaProjector?.iRMacroNumberForProjectorSpare1 = UInt(value) ?? 0
            
        case 16:
            self.mediaProjector?.iRMacroNumberForProjectorSpare2 = UInt(value) ?? 0
            
        case 17:
            self.mediaProjector?.iRMacroNumberForProjectorSpare3 = UInt(value) ?? 0
            
        case 18:
            self.mediaProjector?.iRMacroNumberForProjectorSpare4 = UInt(value) ?? 0
            
        case 19:
            self.mediaProjector?.iRMacroNumberForProjectorSpare5 = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.saveMediaProjector(inZone: mediaProjector)
    }
}

