//
//  SHDeviceArgsViewController + DryContact.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - DryContact
extension SHDeviceArgsViewController {
    
    /// 刷新 干节点
    func refreshDryContact() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "Channel No."
        ]
        
        argsValues = [
            
            dryContact?.remark ?? "dry node",
            "\(dryContact?.subnetID ?? 1)",
            "\(dryContact?.deviceID ?? 0)",
            "\(dryContact?.channelNo ?? 0)"
        ]
    }
    
    /// 更新 干节点
    func updateDryContact(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.dryContact?.remark = value
            
        case 1:
            self.dryContact?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.dryContact?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.dryContact?.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.update(dryContact)
    }
}

