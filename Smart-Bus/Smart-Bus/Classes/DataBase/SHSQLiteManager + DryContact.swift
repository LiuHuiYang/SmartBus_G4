//
//  SHSQLiteManager + DryContact.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - DryContact(干节点) 操作
extension SHSQLiteManager {
    
    /// 增加 干节点
    func insertDryContact(_ dryContact: SHDryContact) -> Bool {
        
        let sql =
            "insert into DryContactInZone (ZoneID, "    +
            "contactID, remark, SubnetID, DeviceID, "   +
            "ChannelNo) values(\(dryContact.zoneID), "  +
            "\(dryContact.contactID), "                 +
            "'\(dryContact.remark ?? "4Z/24Z")', "      +
            "\(dryContact.subnetID), "                  +
            "\(dryContact.deviceID), "                  +
            "\(dryContact.channelNo));"
        
        return executeSql(sql)
    }
    
    /// 更新 干节点
    func updateDryContact(_ dryContact: SHDryContact) -> Bool {
        
        let sql = "update DryContactInZone set "         +
            "remark = '\(dryContact.remark ?? "4Z/24Z")', "
                                                         +
            "SubnetID = \(dryContact.subnetID), "        +
            "DeviceID = \(dryContact.deviceID), "        +
            "ChannelNo = \(dryContact.channelNo) Where " +
            "zoneID = \(dryContact.zoneID) and "         +
            "contactID = \(dryContact.contactID);"
        
        return executeSql(sql)
    }
    
    /// 获得当前区域中的最大的DryInputID
    func getMaxDryContactID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(contactID) from DryContactInZone " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
         
            let dryInputID = dict["max(contactID)"] as? UInt else {
                
            return 0
        }
        
        return dryInputID
    }
    
    /// 删除区域中的干节点
    func deleteDryContacts(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from DryContactInZone Where " +
            "zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除 干节点 设备
    func deleteDryContact(_ dryContact: SHDryContact) -> Bool {
        
        let sql =
            "delete from DryContactInZone Where " +
            "zoneID = \(dryContact.zoneID) and " +
            "SubnetID = \(dryContact.subnetID) and " +
            "DeviceID = \(dryContact.deviceID) and " +
            "ChannelNo = \(dryContact.channelNo) and " +
            "contactID = \(dryContact.contactID);"
        
        return executeSql(sql)
    }
    
    /// 查询当前区域中的所有干节点设备
    func getDryContact(_ zoneID: UInt) -> [SHDryContact] {
        
        let sql =
            "select ID, remark, contactID, ZoneID, " +
            "SubnetID, DeviceID, ChannelNo from "    +
            "DryContactInZone where ZoneID = \(zoneID);"
        
        let array = selectProprty(sql)
        
        var nodes = [SHDryContact]()
        
        for dict in array {
            
            nodes.append(SHDryContact(dict: dict))
        }
        
        return nodes
    }
    
    /// 增加干节点输入类型
    func addZoneDryContact() -> Bool {
        
        _ = deleteTable("DryInputModuleInZone")
        
        let sql =
            "select Distinct SystemID from " +
                "systemDefnition where SystemID = " +
        "\(SHSystemDeviceType.dryContact.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
                "SystemName) values(" +
                "\(SHSystemDeviceType.dryContact.rawValue)," +
        "'Dry Contact');"
        
        return executeSql(addSQL)
    }
    
}
