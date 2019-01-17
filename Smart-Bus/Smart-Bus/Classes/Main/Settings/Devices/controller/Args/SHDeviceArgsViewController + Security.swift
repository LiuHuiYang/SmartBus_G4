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
        
        // 更新每一个参数
        switch index {
            
        case 0:
            self.securityZone?.zoneNameOfSecurity = value
            
        case 1:
            self.securityZone?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.securityZone?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.securityZone?.zoneID = UInt(value) ?? 0
            
        default:
            break
        }
        
        // 保存到数据库
        SHSQLManager.share()?.update(securityZone)
    }
}
