//
//  SHDeviceArgsViewController +  OtherControl.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/25.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Other Control 控制
extension SHDeviceArgsViewController {
    
    /// 刷新 OtherControl
    func refreshOtherControl() {
        
        argsNames = [
            "Remark",
            "Control Type",
            "Subnet ID",
            "Device ID",
            "Parameter1",
            "Parameter2"
        ]
        
        argsValues = [
            
            otherControl?.remark ?? "other control",
            "\(otherControl?.controlType.rawValue ?? 0)",
            "\(otherControl?.subnetID ?? 0)",
            "\(otherControl?.deviceID ?? 0)",
            "\(otherControl?.parameter1 ?? 0)",
            "\(otherControl?.parameter2 ?? 0)"
        ]
    }
    
    /// 保存 OtherControl
    func updateOtherControl(value: String, index: Int) {
        
        guard let other = self.otherControl else {
            return
        }
        
        switch (index) {
            
        case 0:
            other.remark = value
            
        case 1:
            other.controlType =
                SHOtherControlType(rawValue:
                    (UInt8(value) ?? 0)) ?? .singleChannelControl
            
        case 2:
            other.subnetID = UInt8(value) ?? 0
            
        case 3:
            other.deviceID = UInt8(value) ?? 0
            
        case 4:
            other.parameter1 = UInt8(value) ?? 0
            
        case 5:
            other.parameter2 = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        _ = SHSQLiteManager.shared.updateOtherControl(other)
    }
    
}
