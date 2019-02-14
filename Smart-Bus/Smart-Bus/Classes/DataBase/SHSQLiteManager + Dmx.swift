//
//  SHSQLiteManager + Dmx.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - DMX操作
extension SHSQLiteManager {
    
    /// 增加 dmx 通道
    func insertDmxChannel(_ channel: SHDmxChannel) -> UInt {
        
        let sql =
            "insert into dmxChannelInZone (ZoneID, " +
            "groupID, groupName) values( "           +
            "\(channel.zoneID), "                    +
            "\(channel.groupID), "                   +
            "'\(channel.groupName)');"
        
        if executeSql(sql) == false {
            
            return 0
        }
      
        
        let idSQL =
            "select max(ID) from dmxChannelInZone;"
        
        guard let dict = selectProprty(idSQL).last,
            let id = dict["max(ID)"] as? UInt else {
                
            return 0
        }
        
        return id
    }
    
    /// 增加 Dmx 分组
    func insertDmxGroup(_ dmxGroup: SHDmxGroup) -> Bool {
        
        let sql =
            "insert into dmxGroupInZone(ZoneID, groupID) " +
            "values( \(dmxGroup.zoneID), " +
            "\(dmxGroup.groupID));"
        
        return executeSql(sql)
    }
    
    /// 获得指定区域的最大分组ID
    func getMaxDmxGroupID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(groupID) from dmxGroupInZone " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
        let groupID = dict["max(groupID)"] as? UInt else {
            return 0
        }
        
        return groupID
    }
    
    /// 更新 dmx 通道
    func updateDmxChannel(_ channel: SHDmxChannel) -> Bool {
        
        let sql =
            "update dmxChannelInZone set "      +
            "remark = '\(channel.remark)', "    +
            "channelType = "                    +
            "\(channel.channelType.rawValue), " +
            "SubnetID = \(channel.subnetID), "  +
            "DeviceID = \(channel.deviceID), "  +
            "channelNo = \(channel.channelNo) " +
            "where  id = \(channel.id);"
        
        return executeSql(sql)
    }
    
    /// 更新 dmx 分组
    func updateDmxGroup(_ dmxGroup: SHDmxGroup) -> Bool {
        
        let sql =
            "update dmxGroupInZone set "             +
            "groupName = '\(dmxGroup.groupName)' "   +
            "where ZoneID = \(dmxGroup.zoneID) and " +
            "groupID = \(dmxGroup.groupID); "
        
        return executeSql(sql)
    }
    
    /// 删除所有的dmx
    func deleteDmxs(_ zoneID: UInt) -> Bool {
        
        let channelSQL =
            "delete from dmxChannelInZone where " +
            "ZoneID = \(zoneID);"
        
        if executeSql(channelSQL) == false {
            
            return false
        }
        
        let groupSQL =
            "delete from dmxGroupInZone where " +
            "ZoneID = \(zoneID);"
        
        return executeSql(groupSQL)
    }
    
    /// 删除dmx分组
    func deleteDmxGroup(_ dmxGroup: SHDmxGroup) -> Bool {
        
        // 先删除通道
        let chanelSQL =
            "delete from dmxChannelInZone where " +
            "ZoneID =  \(dmxGroup.zoneID) and "    +
            "groupID = \(dmxGroup.groupID) ;"
        
        if executeSql(chanelSQL) == false {
            return false
        }
        
        // 删除分组
        let groupSQL =
            "delete from dmxGroupInZone where " +
            "ZoneID = \(dmxGroup.zoneID) and "  +
            "groupID = \(dmxGroup.groupID) ;"
        
        return executeSql(groupSQL)
    }
    
    /// 删除dmx通道
    func deleteDmxChannel(_ channel: SHDmxChannel) -> Bool {
        
        let sql =
            "delete from dmxChannelInZone where "  +
            "ZoneID    = \(channel.zoneID)   and " +
            "groupID   = \(channel.groupID)  and " +
            "SubnetID  = \(channel.subnetID) and " +
            "DeviceID  = \(channel.deviceID) and " +
            "channelNo = \(channel.channelNo) ;"
        
        return executeSql(sql)
    }
    
    /// 获得dmx分组的dmx通道
    func getDmxGroupChannels(_ dmxGroup: SHDmxGroup) -> [SHDmxChannel] {
        
        let sql =
        "select ID, ZoneID, groupID, groupName, "   +
        "remark, channelType, SubnetID, DeviceID, " +
        "channelNo from dmxChannelInZone where "    +
        "ZoneID = \(dmxGroup.zoneID) and "          +
        "groupID = \(dmxGroup.groupID); "
        
        let array = selectProprty(sql)
        var channels = [SHDmxChannel]()
        
        for dict in array {
            
            channels.append(SHDmxChannel(dict: dict))
        }
        
        return channels
        
    }
    
    /// 获得 DMX分组
    func getDmxGroup(_ zoneID: UInt) -> [SHDmxGroup] {
        
        let sql =
            "select ID, ZoneID, groupID, groupName " +
            "from dmxGroupInZone  " +
            "where ZoneID = \(zoneID);"
        
        let array = selectProprty(sql)
        var groups = [SHDmxGroup]()
        
        for dict in array {
            
            groups.append(SHDmxGroup(dict: dict))
        }
        
        return groups
    }
    
    /// 增加DMX 字段
    func addZoneDmx() -> Bool {
        
        let sql =
            "select Distinct SystemID from " +
                "systemDefnition where SystemID = " +
        "\(SHSystemDeviceType.dmx.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
                "SystemName) values(" +
                "\(SHSystemDeviceType.dmx.rawValue)," +
        "'dmx');"
        
        return executeSql(addSQL)
    }
}
