//
//  SHDeviceArgsViewController + DryContact.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
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
        
        guard let node = self.dryContact else {
            return
        }
        
        switch (index) {
            
        case 0:
            node.remark = value
            
        case 1:
            node.subnetID = UInt8(value) ?? 0
            
        case 2:
            node.deviceID = UInt8(value) ?? 0
            
        case 3:
            node.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        _ = SHSQLiteManager.shared.updateDryContact(node)
    }
}

