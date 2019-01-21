//
//  SHSQLiteManager + Security.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - 安防操作
extension SHSQLiteManager {
    
    /// 更新 securityZone
    func updateSecurityZone(_ securityZone: SHSecurityZone) -> Bool {
        
        let sql =
            "update CentralSecurity set " +
            "zoneNameOfSecurity = '\(securityZone.zoneNameOfSecurity ?? "Security" )', " +
                
            "SubnetID = \(securityZone.subnetID), " +
            "DeviceID = \(securityZone.deviceID), " +
            "ZoneID = \(securityZone.zoneID) "      +
            "where ID = \(securityZone.id);"
        
        return executeSql(sql)
    }
    
    /// 增加 securityZone
    func insertSecurityZone(_ securityZone: SHSecurityZone) -> Bool {
        
        let sql =
            "insert into CentralSecurity (ID, SubnetID, " +
            "DeviceID, ZoneID, zoneNameOfSecurity) "      +
            "values(\(securityZone.id), "                 +
            "\(securityZone.subnetID), "                  +
            "\(securityZone.deviceID), "                  +
            "\(securityZone.zoneID), "                    +
            "'\(securityZone.zoneNameOfSecurity ?? "Security" )');"
        
        
        return executeSql(sql)
    }
    
    /// 获得最大 SecurityID
    func getMaxSecurityID() -> UInt {
        
        let sql = "select max(ID) from CentralSecurity"
        
        guard let dict = selectProprty(sql).last,
            let securityID = dict["max(ID)"] as? UInt else {
            
            return 0
        }
        return securityID
    }
    
    /// 删除 Security Zone
    func deleteSecurityZone(_ securityZone: SHSecurityZone) -> Bool {
        
        let sql =
            "delete from CentralSecurity where " +
            "ID = \(securityZone.id);"
        
        return executeSql(sql)
    }
    
    /// 所有的安防区域设备
    func getSecurityZones() -> [SHSecurityZone] {
        
        let sql =
            "select id, SubnetID, DeviceID, ZoneID, " +
            "zoneNameOfSecurity from CentralSecurity;"
        
        let array = selectProprty(sql)
        
        var securityZones = [SHSecurityZone]()
        
        for dict in array {
            
            securityZones.append(SHSecurityZone(dict: dict))
        }
        
        return securityZones
    }
}
