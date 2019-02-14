//
//  SHDeviceArgsViewController + Shade.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - Shade
extension SHDeviceArgsViewController {
    
    func refreshShade() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            
            "HasStop",
            "Open Channel",
            "Opening Ratio",
            "Close Channel",
            "Closing Ratio",
            "Stop Channel",
            "Stopping Ratio",
            
            "Reserved1",
            "Reserved2",
            
            "Open Remark",
            "Close Remark",
            "Stop Remark",
            
            "controlType",
            "switchID for Open",
            "switchID Status for Open",
            "switchID for Close",
            "switchID Status for Close",
            "switchID for Stop",
            "switchID Status for Stop"
        ]
        
        argsValues = [
            shade?.shadeName ?? "curtain",
            "\(shade?.subnetID ?? 1)",
            "\(shade?.deviceID ?? 0)",
            "\(shade?.hasStop ?? 0)",
            
            "\(shade?.openChannel ?? 0)",
            "\(shade?.openingRatio ?? 0)",
            "\(shade?.closeChannel ?? 0)",
            "\(shade?.closingRatio ?? 0)",
            "\(shade?.stopChannel ?? 0)",
            "\(shade?.stoppingRatio ?? 0)",
            
            "\(shade?.reserved1 ?? 0)",
            "\(shade?.reserved2 ?? 0)",
            
            "\(shade?.remarkForOpen ?? "open")",
            "\(shade?.remarkForClose ?? "close")",
            "\(shade?.remarkForStop ?? "stop")",
            
            "\(shade?.controlType.rawValue ?? 0)",
            
            "\(shade?.switchIDforOpen ?? 0)",
            "\(shade?.switchIDStatusforOpen ?? 0)",
            "\(shade?.switchIDforClose ?? 0)",
            "\(shade?.switchIDStatusforClose ?? 0)",
            "\(shade?.switchIDforStop ?? 0)",
            "\(shade?.switchIDStatusforStop ?? 0)"
        ]
    }
    
    
    func updateShade(value: String, index: Int) {
        
        guard let curtain = self.shade else {
            return
        }
        
        switch (index) {
        case 0:
            curtain.shadeName = value
            
        case 1:
            curtain.subnetID = UInt8(value) ?? 1
            
        case 2:
            curtain.deviceID = UInt8(value) ?? 0
            
        case 3:
            curtain.hasStop = UInt8(value) ?? 0
            
        case 4:
            curtain.openChannel = UInt8(value) ?? 0
            
        case 5:
            curtain.openingRatio = UInt8(value) ?? 0
            
        case 6:
            curtain.closeChannel = UInt8(value) ?? 0
            
        case 7:
            curtain.closingRatio = UInt8(value) ?? 0
            
        case 8:
            curtain.stopChannel = UInt8(value) ?? 0
            
        case 9:
            curtain.stoppingRatio = UInt8(value) ?? 0
            
        case 10:
            curtain.reserved1 = UInt(value) ?? 0
            
        case 11:
            curtain.reserved2 = UInt(value) ?? 0
            
        case 12:
            curtain.remarkForOpen = value
            
        case 13:
            curtain.remarkForClose = value
            
        case 14:
            curtain.remarkForStop = value
            
        case 15:
            curtain.controlType = SHShadeControlType(rawValue: UInt(value) ?? 0) ?? .defaultControl
            
        case 16:
            curtain.switchIDforOpen = UInt(value) ?? 0
            
        case 17:
            curtain.switchIDStatusforOpen = UInt(value) ?? 0
            
        case 18:
            curtain.switchIDforClose = UInt(value) ?? 0
            
        case 19:
            curtain.switchIDStatusforClose = UInt(value) ?? 0
            
        case 20:
            curtain.switchIDforStop = UInt(value) ?? 0
            
        case 21:
            curtain.switchIDStatusforStop = UInt(value) ?? 0
            
        default:
            break
        }
         
        _ = SHSQLiteManager.shared.updateShade(curtain)
    }
}
