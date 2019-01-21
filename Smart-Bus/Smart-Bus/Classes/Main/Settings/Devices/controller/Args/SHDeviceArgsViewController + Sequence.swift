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
        
        guard let sequence = self.sequence else {
            return
        }
        
        switch (index) {
            
        case 0:
            sequence.remark = value
            
        case 1:
            sequence.subnetID = UInt8(value) ?? 0
            
        case 2:
            sequence.deviceID = UInt8(value) ?? 0
            
        case 3:
            sequence.areaNo = UInt8(value) ?? 0
            
        case 4:
            sequence.sequenceNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        _ = SHSQLiteManager.shared.updateSequence(sequence)
    }
}
