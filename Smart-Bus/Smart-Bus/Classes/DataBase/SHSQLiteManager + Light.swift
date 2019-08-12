//
//  SHSQLiteManager + Light.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - light
extension SHSQLiteManager {
    
    /// 获得当前区域中的最大的lightID
    func getMaxLightID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(LightID) from LightInZone " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
            let lightID = dict["max(LightID)"] as? UInt
            
            else {
                
            return 0
        }
        
        return lightID
    }
    
    /// 查询当前区域中的所有light
    func getLights(_ zoneID: UInt) -> [SHLight] {
        
        let sql =
            "select id, ZoneID, LightID, LightRemark, " +
            "SubnetID, DeviceID, ChannelNo, CanDim, "   +
            "LightTypeID, SwitchOn, SwitchOff from "    +
            "LightInZone where ZoneID = \(zoneID) "     +
            "order by LightID;"
        
        let array = selectProprty(sql)
        
        var lights = [SHLight]()
        
        for dict in array {
            
            lights.append(SHLight(dictionary: dict))
        }
        
        return lights
    }
    
    /// 删除区域的light
    func deleteLights(zoneID: UInt) -> Bool {
        
        let sql =
            "delete from LightInZone Where " +
            "zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除指定的灯泡
    func deleteLight(_ light: SHLight) -> Bool {
        
        let sql =
            "delete from LightInZone Where "            +
            "zoneID = \(light.zoneID) and "             +
            "SubnetID = \(light.subnetID) and "         +
            "DeviceID = \(light.deviceID) and "         +
            "ChannelNo = \(light.channelNo) and "       +
            "CanDim = \(light.canDim.rawValue) and "    +
            "LightTypeID = \(light.lightTypeID.rawValue);"
        
        return executeSql(sql)
    }
    
    /// 增加light
    func insertLight(_ light: SHLight) -> Bool {
        
        let sql =
            "insert into LightInZone (ZoneID, "           +
            "LightID, LightRemark, SubnetID, "            +
            "DeviceID, ChannelNo, CanDim, "               +
            "LightTypeID, SwitchOn, SwitchOff) "          +
            "values(\(light.zoneID), \(light.lightID), "  +
            "'\(light.lightRemark)', \(light.subnetID), " +
            "\(light.deviceID), \(light.channelNo), "     +
            "\(light.canDim.rawValue), "                  +
            "\(light.lightTypeID.rawValue), "             +
            "\(light.switchOn), \(light.switchOff));"
        
        return executeSql(sql)
    }
    
    /// 更新light
    func updateLight(_ light: SHLight) -> Bool {
        
        let sql =
            "update LightInZone set "                       +
            "ZoneID = \(light.zoneID), "                    +
            "LightID = \(light.lightID), "                  +
            "LightRemark = '\(light.lightRemark)', "        +
            "SubnetID = \(light.subnetID), "                +
            "DeviceID = \(light.deviceID), "                +
            "ChannelNo = \(light.channelNo), "              +
            "CanDim = \(light.canDim.rawValue), "           +
            "LightTypeID = \(light.lightTypeID.rawValue), " +
            "SwitchOn = \(light.switchOn), "                +
            "SwitchOff = \(light.switchOff) "               +
            "Where zoneID = \(light.zoneID) and "           +
            "LightID = \(light.lightID);"
        
        return executeSql(sql)
    }
    
    /// 获取指定的灯
    func getLight(_ zoneID: UInt, lightID: UInt) -> SHLight? {
        
        let sql =
            "select id, ZoneID, LightID, LightRemark, "  +
            "SubnetID, DeviceID, ChannelNo, CanDim,   "  +
            "LightTypeID, SwitchOn, SwitchOff "          +
            "from LightInZone where ZoneID = \(zoneID) " +
            "and LightID = \(lightID);"
        
        guard let dict = selectProprty(sql).last else {
            
            return nil
        }

        return SHLight(dictionary: dict)
    }
    
    
    /// 增加ligth的参数
    ///
    /// - Returns: Bool
    func addLightParameter() -> Bool {
        
        if isColumnName(
            "SwitchOn",
            consistinTable: "LightInZone"
            ) == false {
            
            let onSQL =
                "ALTER TABLE LightInZone ADD SwitchOn " +
                "INTEGER DEFAULT 0;"
            
            let offSQL =
                "ALTER TABLE LightInZone ADD SwitchOff " +
                "INTEGER DEFAULT 0;"
            
            return executeSql(onSQL) &&
                   executeSql(offSQL)
        }
        
        return true
    }
}
