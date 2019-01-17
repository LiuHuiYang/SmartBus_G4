//
//  SHDeviceArgsViewController + Shade.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
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
        
        switch (index) {
        case 0:
            self.shade?.shadeName = value
            
        case 1:
            self.shade?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.shade?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.shade?.hasStop = UInt8(value) ?? 0
            
        case 4:
            self.shade?.openChannel = UInt8(value) ?? 0
            
        case 5:
            self.shade?.openingRatio = UInt8(value) ?? 0
            
        case 6:
            self.shade?.closeChannel = UInt8(value) ?? 0
            
        case 7:
            self.shade?.closingRatio = UInt8(value) ?? 0
            
        case 8:
            self.shade?.stopChannel = UInt8(value) ?? 0
            
        case 9:
            self.shade?.stoppingRatio = UInt8(value) ?? 0
            
        case 10:
            self.shade?.reserved1 = UInt(value) ?? 0
            
        case 11:
            self.shade?.reserved2 = UInt(value) ?? 0
            
        case 12:
            self.shade?.remarkForOpen = value
            
        case 13:
            self.shade?.remarkForClose = value
            
        case 14:
            self.shade?.remarkForStop = value
            
        case 15:
            self.shade?.controlType = SHShadeControlType(rawValue: UInt(value) ?? 0) ?? .defaultControl
            
        case 16:
            self.shade?.switchIDforOpen = UInt(value) ?? 0
            
        case 17:
            self.shade?.switchIDStatusforOpen = UInt(value) ?? 0
            
        case 18:
            self.shade?.switchIDforClose = UInt(value) ?? 0
            
        case 19:
            self.shade?.switchIDStatusforClose = UInt(value) ?? 0
            
        case 20:
            self.shade?.switchIDforStop = UInt(value) ?? 0
            
        case 21:
            self.shade?.switchIDStatusforStop = UInt(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateShade(inZone: shade)
    }
}
