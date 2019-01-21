//
//  SHDeviceArgsViewController + Security.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - SecurityZone
extension SHDeviceArgsViewController {
    
    /// 更新安防
    func refreshSecurityZone() {
        
        // 属性名称
        argsNames = [
            "Security Zone Name",
            "Subnet ID",
            "Device ID",
            "Zone ID"
        ]
        
        // 属性值
        argsValues = [
            securityZone?.zoneNameOfSecurity ?? "Security",
            "\(securityZone?.subnetID ?? 1)",
            "\(securityZone?.deviceID ?? 0)",
            "\(securityZone?.zoneID ?? 0)"
        ]
    }
    
    /// 更新值
    func updateSecurityZone(value: String, index: Int) {
        
        guard let security = self.securityZone else {
            return
        }
        
        // 更新每一个参数
        switch index {
            
        case 0:
            security.zoneNameOfSecurity = value
            
        case 1:
            security.subnetID = UInt8(value) ?? 1
            
        case 2:
            security.deviceID = UInt8(value) ?? 0
            
        case 3:
            security.zoneID = UInt(value) ?? 0
            
        default:
            break
        }
        
        // 保存到数据库
        _ = SHSQLiteManager.shared.updateSecurityZone(
            security
        )
    }
}
