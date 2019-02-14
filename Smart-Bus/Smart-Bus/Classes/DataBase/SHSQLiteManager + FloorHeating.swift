//
//  SHSQLiteManager + FloorHeating.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/22.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - FloorHeating 操作
extension SHSQLiteManager {
    
    /// 增加 floorHeating
    func insertFloorHeating(_ floorHeating: SHFloorHeating) -> Bool {
        
        let sql =
            "insert into FloorHeatingInZone (ZoneID, " +
            "FloorHeatingID, FloorHeatingRemark, "     +
            "SubnetID, DeviceID, ChannelNo, "          +
            "outsideSensorSubNetID, "                  +
            "outsideSensorDeviceID, "                  +
            "outsideSensorChannelNo) values( "         +
            "\(floorHeating.zoneID), "                 +
            "\(floorHeating.floorHeatingID), "         +
            "'\(floorHeating.floorHeatingRemark)', "   +
            "\(floorHeating.subnetID), "               +
            "\(floorHeating.deviceID), "               +
            "\(floorHeating.channelNo), "              +
            "\(floorHeating.outsideSensorSubNetID), "  +
            "\(floorHeating.outsideSensorDeviceID), "  +
            "\(floorHeating.outsideSensorChannelNo));"
        
        
        return executeSql(sql)
    }
    
    /// 获得当前区域中的最大的FloorHeatingID
    func getMaxFloorHeatingID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(FloorHeatingID) from " +
            "FloorHeatingInZone where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
        let floorHeatingID = dict["max(FloorHeatingID)"] as? UInt else {
            
            return 0
        }
        
        return floorHeatingID
    }
    
    /// 更新 floorHeating
    func updateFloorHeating(_ floorHeating: SHFloorHeating) -> Bool {
        
        let sql =
            "update FloorHeatingInZone set "          +
            "FloorHeatingRemark = "                   +
            "'\(floorHeating.floorHeatingRemark)', "  +
            "SubnetID = \(floorHeating.subnetID), "   +
            "DeviceID = \(floorHeating.deviceID), "   +
            "ChannelNo = \(floorHeating.channelNo), " +
            "outsideSensorSubNetID = "                +
            "\(floorHeating.outsideSensorSubNetID), " +
            "outsideSensorDeviceID = "                +
            "\(floorHeating.outsideSensorDeviceID), " +
            "outsideSensorChannelNo = "               +
            "\(floorHeating.outsideSensorChannelNo) " +
            "Where zoneID = \(floorHeating.zoneID) "  +
            "and FloorHeatingID = " +
            "\(floorHeating.floorHeatingID); "
        
        
        return executeSql(sql)
    }
    
    /// 删除 所有的 FloorHeating
    func deleteFloorHeatings(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from FloorHeatingInZone Where " +
            "zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除指定的  FloorHeating
    func deleteFloorHeating(_ floorHeating: SHFloorHeating) -> Bool {
        
        let sql =
            "delete from FloorHeatingInZone      Where " +
            "zoneID = \(floorHeating.zoneID)       and " +
            "SubnetID = \(floorHeating.subnetID)   and " +
            "DeviceID = \(floorHeating.deviceID)   and " +
            "ChannelNo = \(floorHeating.channelNo) and " +
            "FloorHeatingID = "                          +
                "\(floorHeating.floorHeatingID);"
        
        
        return executeSql(sql)
    }
    
    /// 查询区域中的所有的 FloorHeating
    func getFloorHeatings(_ zoneID: UInt) -> [SHFloorHeating] {
        
        let sql =
            "select id, ZoneID, FloorHeatingID,      " +
            "FloorHeatingRemark, SubnetID, DeviceID, " +
            "ChannelNo, outsideSensorSubNetID,       " +
            "outsideSensorDeviceID,   "                +
            "outsideSensorChannelNo   "                +
            "from FloorHeatingInZone  "                +
            "where ZoneID = \(zoneID) "                +
            "order by FloorHeatingID; "
        
        let array = selectProprty(sql)
        var floorHeatings = [SHFloorHeating]()
        
        for dict in array {
            
            floorHeatings.append(SHFloorHeating(dict: dict))
        }
        
        return floorHeatings
    }
    
    /// 增加FloorHeating 类型
    func addFloorHeating() -> Bool {
        
        let sql =
            "select Distinct SystemID from " +
                "systemDefnition where SystemID = " +
        "\(SHSystemDeviceType.floorHeating.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
                "SystemName) values(" +
                "\(SHSystemDeviceType.floorHeating.rawValue)," +
        "'FloorHeating');"
        
        return executeSql(addSQL)
    }
}
