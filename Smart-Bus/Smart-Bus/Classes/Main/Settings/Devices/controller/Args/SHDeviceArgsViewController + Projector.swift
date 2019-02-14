//
//  SHDeviceArgsViewController + Projector.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
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
        
        guard let projector = self.mediaProjector else {
            return
        }
        
        switch (index) {
            
        case 0:
            projector.remark = value
            
        case 1:
            projector.subnetID = UInt8(value) ?? 1
            
        case 2:
            projector.deviceID = UInt8(value) ?? 0
            
        case 3:
            projector.universalSwitchIDforOn = UInt(value) ?? 0
            
        case 4:
            projector.universalSwitchStatusforOn = UInt(value) ?? 0
            
        case 5:
            projector.universalSwitchIDforOff = UInt(value) ?? 0
            
        case 6:
            projector.universalSwitchStatusforOff = UInt(value) ?? 0
            
        case 7:
            projector.universalSwitchIDfoUp = UInt(value) ?? 0
            
        case 8:
            projector.universalSwitchIDforDown = UInt(value) ?? 0
            
        case 9:
            projector.universalSwitchIDforLeft = UInt(value) ?? 0
            
        case 10:
            projector.universalSwitchIDforRight = UInt(value) ?? 0
            
        case 11:
            projector.universalSwitchIDforOK = UInt(value) ?? 0
            
        case 12:
            projector.universalSwitchIDfoMenu = UInt(value) ?? 0
            
        case 13:
            projector.universalSwitchIDforSource = UInt(value) ?? 0
            
        case 14:
            projector.iRMacroNumberForProjectorSpare0 = UInt(value) ?? 0
            
        case 15:
            projector.iRMacroNumberForProjectorSpare1 = UInt(value) ?? 0
            
        case 16:
            projector.iRMacroNumberForProjectorSpare2 = UInt(value) ?? 0
            
        case 17:
            projector.iRMacroNumberForProjectorSpare3 = UInt(value) ?? 0
            
        case 18:
            projector.iRMacroNumberForProjectorSpare4 = UInt(value) ?? 0
            
        case 19:
            projector.iRMacroNumberForProjectorSpare5 = UInt(value) ?? 0
            
        default:
            break
        }
         
        _ = SHSQLiteManager.shared.updateProjector(projector)
    }
}

