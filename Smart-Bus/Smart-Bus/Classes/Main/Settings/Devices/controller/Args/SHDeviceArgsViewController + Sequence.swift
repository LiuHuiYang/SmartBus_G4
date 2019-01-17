//
//  SHDeviceArgsViewController + Sequence.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - Sequence 控制
extension SHDeviceArgsViewController {
    
    /// 刷新 Sequence
    func refreshSequence() {
        
        argsNames = [
            "Remark",
            "Subnet ID",
            "Device ID",
            "Area No.",
            "Sequence No."
        ]
        
        argsValues = [
            
            sequence?.remark ?? "Sequence",
            "\(sequence?.subnetID ?? 0)",
            "\(sequence?.deviceID ?? 0)",
            "\(sequence?.areaNo ?? 0)",
            "\(sequence?.sequenceNo ?? 0)"
        ]
    }
    
    /// 保存 Sequence
    func updateSequence(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.sequence?.remark = value
            
        case 1:
            self.sequence?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.sequence?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.sequence?.areaNo = UInt8(value) ?? 0
            
        case 4:
            self.sequence?.sequenceNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.updateSequence(
            inZone: sequence
        )
    }
}
