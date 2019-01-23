//
//  SHSQLiteManager + Zone.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/18.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Zone的相关操作
extension SHSQLiteManager {
    
    /// 删除区域
    func deleteZone(_ zoneID: UInt) -> Bool {
        
        return false
    }
    
    func insertZone(_ zone: SHZone) -> Bool {
        
        let sql =
            "insert into Zones(regionID, ZoneID, " +
            "ZoneName, zoneIconName) values(     " +
            "\(zone.regionID), \(zone.zoneID),   " +
            "'\(zone.zoneName ?? "New Zone")',   " +
            "'\(zone.zoneIconName ?? "Demokit")'); "
        
        return executeSql(sql)
    }
    
    /// 获取大的区域ID
    func getMaxZoneID() -> UInt {
    
        let sql = "select max(zoneID) from Zones;"
        
        guard let dict = selectProprty(sql).last,
        let zoneID = dict["max(zoneID)"] as? UInt else {
            
            return 0
        }
    
        return zoneID
    }
    
    /// 更新 zone 信息
    func updateZone(_ zone: SHZone) -> Bool {
        
        let sql =
            "update Zones set                     " +
            "ZoneName =                           " +
            "'\(zone.zoneName ?? "New Zone")',    " +
            "zoneIconName =                       " +
            "'\(zone.zoneIconName ?? "Demokit")'  " +
            "Where zoneID = \(zone.zoneID);"
        
        return executeSql(sql)
    }
    
    /// 查询指定表格中的区域ID
    func getZoneID(tableName: String) -> [UInt] {
        
        let sql = "select DISTINCT ZoneID from \(tableName);"
        
        let array = selectProprty(sql)
        
        var zoneIDs = [UInt]()
        
        for dict in array {
            
            if let id = dict["ZoneID"] as? UInt {
                
                zoneIDs.append(id)
            }
        }
        
        return zoneIDs
    }
    
    /// 获得指定的zone的详细信息
    func getZone(zoneID: UInt) -> SHZone? {
        
        let sql =
            "select regionID, ZoneID, ZoneName, " +
            "zoneIconName from Zones where      " +
            "ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last else {
            return nil
        }
        
        return SHZone(dictionary: dict)
    }
    
    /// 查询指定region的所有区域
    func getZones(regionID: UInt) -> [SHZone] {
        
        let sql =
            "select zoneID, ZoneName, zoneIconName   " +
            "from Zones where regionID = \(regionID) " +
            "order by zoneID;"
        
        let array = selectProprty(sql)
        var zones = [SHZone]()
        
        for dict in array {
            
            zones.append(SHZone(dictionary: dict))
        }
        
        return zones
        
    }
}
