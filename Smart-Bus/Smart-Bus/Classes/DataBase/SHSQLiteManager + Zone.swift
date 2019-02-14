//
//  SHSQLiteManager + Zone.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/18.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Zone的相关操作
extension SHSQLiteManager {
    
    /// 删除区域
    func deleteZone(_ zoneID: UInt) -> Bool {
        
        let systems = getSystemIDs(zoneID)
        
        // 1.删除每种设备数据
        for deviceType in systems {
            
            switch deviceType {
                
            case SHSystemDeviceType.light.rawValue:
                _ = deleteLights(zoneID: zoneID)
                
            case SHSystemDeviceType.hvac.rawValue:
                _ = deleteHVACs(zoneID)
                
            case SHSystemDeviceType.audio.rawValue:
                _ = deleteAudios(zoneID)
                
            case SHSystemDeviceType.shade.rawValue:
                _ = deleteShades(zoneID)
                
            case SHSystemDeviceType.tv.rawValue:
                _ = deleteTVs(zoneID)
                
            case SHSystemDeviceType.dvd.rawValue:
                _ = SHSQLiteManager.shared.deleteDVDs(zoneID)
            
            case SHSystemDeviceType.sat.rawValue:
                _ = SHSQLiteManager.shared.deleteSats(zoneID)
                
            case SHSystemDeviceType.appletv.rawValue:
               _ = deleteAppleTVs(zoneID)
                
            case SHSystemDeviceType.projector.rawValue:
                
                _ = SHSQLiteManager.shared.deleteProjectors(
                    zoneID
                )
                
            case SHSystemDeviceType.mood.rawValue:
                _ = SHSQLiteManager.shared.deleteMoods(zoneID)
                
            case SHSystemDeviceType.fan.rawValue:
                _ = deleteFans(zoneID)
                
            case SHSystemDeviceType.floorHeating.rawValue:
                _ = deleteFloorHeatings(zoneID)
                
            case SHSystemDeviceType.nineInOne.rawValue:
                
                _ = SHSQLiteManager.shared.deleteNineInOnes(
                    zoneID
                )
                
            case SHSystemDeviceType.dryContact.rawValue:
                _ = deleteDryContacts(zoneID)
                
            case SHSystemDeviceType.temperatureSensor.rawValue:
                _ = deleteTemperatureSensors(zoneID)
                
            case SHSystemDeviceType.dmx.rawValue:
                _ = deleteDmxs(zoneID)
                
            case SHSystemDeviceType.sceneControl.rawValue:
                _ = deleteScenes(zoneID)
                
            case SHSystemDeviceType.sequenceControl.rawValue:
                _ = deleteSequences(zoneID)
                
            case SHSystemDeviceType.otherControl.rawValue:
                _ = deleteOtherControls(zoneID)
            
            default:
                break
            }
        }
        
        // 2.删除设置类型配置
        let systemSQL =
            "delete from SystemInZone " +
            "where zoneID = \(zoneID);"
        
        if executeSql(systemSQL) == false {
            
            return false
        }
        
        // 3. 删除区域
        let zoneSQL =
            "delete from Zones where zoneID = \(zoneID);"
        
        if executeSql(zoneSQL) == false {
            
            return false
        }
        
        return true
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
    
    /// 依据类型获得区域
    func getZones(deviceType: UInt) -> [SHZone] {
        
        let typeSQL =
            "select distinct ZoneID from SystemInZone " +
            "where SystemID = \(deviceType) order by zoneID;"
        
        let array = selectProprty(typeSQL)
        
        var zones = [SHZone]()
        
        for dict in array {
            
            if let zoneID = dict["ZoneID"] as? UInt {
                
                let zoneSQL =
                    "select zoneID, ZoneName, zoneIconName " +
                    "from Zones where zoneID = \(zoneID)   " +
                    "order by zoneID;"
                
                if let dict = selectProprty(zoneSQL).last {
                    
                    zones.append(SHZone(dictionary: dict))
                }
            }
            
        }
        
        return zones
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
