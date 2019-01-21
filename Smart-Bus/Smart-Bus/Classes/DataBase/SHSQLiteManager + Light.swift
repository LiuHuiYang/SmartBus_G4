//
//  SHSQLiteManager + Light.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/21.
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
            "LightTypeID from LightInZone "             +
            "where ZoneID = \(zoneID) order by LightID;"
        
        let array = selectProprty(sql)
        
        var lights = [SHLight]()
        
        for dict in array {
            
            lights.append(SHLight(dictionary: dict))
        }
        
        return lights
    }
    
    /// 删除指定的灯泡
    func deleteLight(_ light: SHLight) -> Bool {
        
        let sql =
            "delete from LightInZone "                  +
            "Where zoneID = \(light.zoneID) "           +
            "and SubnetID = \(light.subnetID) and "     +
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
            "LightID, LightRemark, SubnetID, DeviceID, "  +
            "ChannelNo, CanDim, LightTypeID) "            +
            "values(\(light.zoneID), \(light.lightID), "  +
            "'\(light.lightRemark)', \(light.subnetID), " +
            "\(light.deviceID), \(light.channelNo), "     +
            "\(light.canDim.rawValue), "                  +
            "\(light.lightTypeID.rawValue));"
        
        return executeSql(sql)
    }
    
    /// 更新light
    func updateLight(_ light: SHLight) -> Bool {
        
        let sql =
            "update LightInZone set " +
            "ZoneID = \(light.zoneID), " +
            "LightID = \(light.lightID), " +
            "LightRemark = '\(light.lightRemark)', " +
            "SubnetID = \(light.subnetID), " +
            "DeviceID = \(light.deviceID), " +
            "ChannelNo = \(light.channelNo), " +
            "CanDim = \(light.canDim.rawValue), " +
            "LightTypeID = \(light.lightTypeID.rawValue) " +
            "Where zoneID = \(light.zoneID) and " +
            "LightID = \(light.lightID);"
        
        return executeSql(sql)
    }
    
    /// 获取指定的灯
    func getLight(_ zoneID: UInt, lightID: UInt) -> SHLight? {
        
        let sql =
            "select id, ZoneID, LightID, LightRemark, " +
            "SubnetID, DeviceID, ChannelNo, CanDim,   " +
            "LightTypeID from LightInZone "             +
            "where ZoneID = \(zoneID) and "             +
            "LightID = \(lightID);"
        
        guard let dict = selectProprty(sql).last else {
            
            return nil
        }

        return SHLight(dictionary: dict)
    }
}
