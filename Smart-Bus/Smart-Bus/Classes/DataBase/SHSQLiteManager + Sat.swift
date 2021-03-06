//
//  SHSQLiteManager + Sat.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/23.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

/*
 涉及到的数据表格的关系
    同一个区域有 很多 电视
 
    每个电视 有很多组频道 category
        对应关系: zoneID && subetID && deviceID
 
    每组 category 有很多个频道
        对应关系: zoneID && categoryID
 
    找到组中的 每个频道
        channelID
 */


// MARK: - Sat 操作
extension SHSQLiteManager {
    
    /// 增加 Sat
    func insertSat(_ sat: SHMediaSAT) -> UInt {
        
        let sql =
            "insert into SATInZone (remark, ZoneID,     " +
            "SubnetID, DeviceID,                        " +
            "UniversalSwitchIDforOn,                    " +
            "UniversalSwitchStatusforOn,                " +
            "UniversalSwitchIDforOff,                   " +
            "UniversalSwitchStatusforOff,               " +
            "UniversalSwitchIDforUp,                    " +
            "UniversalSwitchIDforDown,                  " +
            "UniversalSwitchIDforLeft,                  " +
            "UniversalSwitchIDforRight,                 " +
            "UniversalSwitchIDforOK,                    " +
            "UniversalSwitchIDfoMenu,                   " +
            "UniversalSwitchIDforFAV,                   " +
            "UniversalSwitchIDfor0,                     " +
            "UniversalSwitchIDfor1,                     " +
            "UniversalSwitchIDfor2,                     " +
            "UniversalSwitchIDfor3,                     " +
            "UniversalSwitchIDfor4,                     " +
            "UniversalSwitchIDfor5,                     " +
            "UniversalSwitchIDfor6,                     " +
            "UniversalSwitchIDfor7,                     " +
            "UniversalSwitchIDfor8,                     " +
            "UniversalSwitchIDfor9,                     " +
            "UniversalSwitchIDforPlayRecord,            " +
            "UniversalSwitchIDforPlayStopRecord,        " +
            "IRMacroNumberForSATSpare0,                 " +
            "IRMacroNumberForSATSpare1,                 " +
            "IRMacroNumberForSATSpare2,                 " +
            "IRMacroNumberForSATSpare3,                 " +
            "IRMacroNumberForSATSpare4,                 " +
            "IRMacroNumberForSATSpare5,                 " +
            "UniversalSwitchIDforPREVChapter,           " +
            "UniversalSwitchIDforNextChapter,           " +
            "SwitchNameforControl1,                     " +
            "SwitchIDforControl1,                       " +
            "SwitchNameforControl2,                     " +
            "SwitchIDforControl2,                       " +
            "SwitchNameforControl3,                     " +
            "SwitchIDforControl3,                       " +
            "SwitchNameforControl4,                     " +
            "SwitchIDforControl4,                       " +
            "SwitchNameforControl5,                     " +
            "SwitchIDforControl5,                       " +
            "SwitchNameforControl6,                     " +
            "SwitchIDforControl6 )  values(             " +
            "'\(sat.remark ?? "sat." )', \(sat.zoneID), " +
            "\(sat.subnetID), \(sat.deviceID),          " +
            "\(sat.universalSwitchIDforOn),             " +
            "\(sat.universalSwitchStatusforOn),         " +
            "\(sat.universalSwitchIDforOff),            " +
            "\(sat.universalSwitchStatusforOff),        " +
            "\(sat.universalSwitchIDforUp),             " +
            "\(sat.universalSwitchIDforDown),           " +
            "\(sat.universalSwitchIDforLeft),           " +
            "\(sat.universalSwitchIDforRight),          " +
            "\(sat.universalSwitchIDforOK),             " +
            "\(sat.universalSwitchIDfoMenu),            " +
            "\(sat.universalSwitchIDforFAV),            " +
            "\(sat.universalSwitchIDfor0),              " +
            "\(sat.universalSwitchIDfor1),              " +
            "\(sat.universalSwitchIDfor2),              " +
            "\(sat.universalSwitchIDfor3),              " +
            "\(sat.universalSwitchIDfor4),              " +
            "\(sat.universalSwitchIDfor5),              " +
            "\(sat.universalSwitchIDfor6),              " +
            "\(sat.universalSwitchIDfor7),              " +
            "\(sat.universalSwitchIDfor8),              " +
            "\(sat.universalSwitchIDfor9),              " +
            "\(sat.universalSwitchIDforPlayRecord),     " +
            "\(sat.universalSwitchIDforPlayStopRecord), " +
            "\(sat.iRMacroNumberForSATSpare0),          " +
            "\(sat.iRMacroNumberForSATSpare1),          " +
            "\(sat.iRMacroNumberForSATSpare2),          " +
            "\(sat.iRMacroNumberForSATSpare3),          " +
            "\(sat.iRMacroNumberForSATSpare4),          " +
            "\(sat.iRMacroNumberForSATSpare5),          " +
            "\(sat.universalSwitchIDforPREVChapter),    " +
            "\(sat.universalSwitchIDforNextChapter),    " +
            "'\(sat.switchNameforControl1 ?? "C1" )',   " +
            "\(sat.switchIDforControl1),                " +
            "'\(sat.switchNameforControl2 ?? "C2" )',   " +
            "\(sat.switchIDforControl2),                " +
            "'\(sat.switchNameforControl3 ?? "C3" )',   " +
            "\(sat.switchIDforControl3),                " +
            "'\(sat.switchNameforControl4 ?? "C4" )',   " +
            "\(sat.switchIDforControl4),                " +
            "'\(sat.switchNameforControl5 ?? "C5" )',   " +
            "\(sat.switchIDforControl5),                " +
            "'\(sat.switchNameforControl6 ?? "C6" )',   " +
            "\(sat.switchIDforControl6));"
        
        _ = executeSql(sql)
        
        let idSQL = "select max(ID) from SATInZone;"
        
        guard let dict = selectProprty(idSQL).last,
        let id = dict["max(ID)"] as? UInt else {
            
            return 0
        }
        
        return id
    }
    
    /// 更新 sat
    func updateSat(_ sat: SHMediaSAT) -> Bool {
        
        let sql =
            "update SATInZone set remark =              " +
            "'\(sat.remark ?? "sat.")',                 " +
            "SubnetID = \(sat.subnetID),                " +
            "DeviceID = \(sat.deviceID),                " +
            "UniversalSwitchIDforOn =                   " +
            "\(sat.universalSwitchIDforOn),             " +
            "UniversalSwitchStatusforOn =               " +
            "\(sat.universalSwitchStatusforOn),         " +
            "UniversalSwitchIDforOff =                  " +
            "\(sat.universalSwitchIDforOff),            " +
            "UniversalSwitchStatusforOff =              " +
            "\(sat.universalSwitchStatusforOff),        " +
            "UniversalSwitchIDforUp =                   " +
            "\(sat.universalSwitchIDforUp),             " +
            "UniversalSwitchIDforDown =                 " +
            "\(sat.universalSwitchIDforDown),           " +
            "UniversalSwitchIDforLeft =                 " +
            "\(sat.universalSwitchIDforLeft),           " +
            "UniversalSwitchIDforRight =                " +
            "\(sat.universalSwitchIDforRight),          " +
            "UniversalSwitchIDforOK =                   " +
            "\(sat.universalSwitchIDforOK),             " +
            "UniversalSwitchIDfoMenu =                  " +
            "\(sat.universalSwitchIDfoMenu),            " +
            "UniversalSwitchIDforFAV =                  " +
            "\(sat.universalSwitchIDforFAV),            " +
            "UniversalSwitchIDfor0 =                    " +
            "\(sat.universalSwitchIDfor0),              " +
            "UniversalSwitchIDfor1 =                    " +
            "\(sat.universalSwitchIDfor1),              " +
            "UniversalSwitchIDfor2 =                    " +
            "\(sat.universalSwitchIDfor2),              " +
            "UniversalSwitchIDfor3 =                    " +
            "\(sat.universalSwitchIDfor3),              " +
            "UniversalSwitchIDfor4 =                    " +
            "\(sat.universalSwitchIDfor4),              " +
            "UniversalSwitchIDfor5 =                    " +
            "\(sat.universalSwitchIDfor5),              " +
            "UniversalSwitchIDfor6 =                    " +
            "\(sat.universalSwitchIDfor6),              " +
            "UniversalSwitchIDfor7 =                    " +
            "\(sat.universalSwitchIDfor7),              " +
            "UniversalSwitchIDfor8 =                    " +
            "\(sat.universalSwitchIDfor8),              " +
            "UniversalSwitchIDfor9 =                    " +
            "\(sat.universalSwitchIDfor9),              " +
            "UniversalSwitchIDforPREVChapter =          " +
            "\(sat.universalSwitchIDforPREVChapter),    " +
            "UniversalSwitchIDforNextChapter =          " +
            "\(sat.universalSwitchIDforNextChapter),    " +
            "UniversalSwitchIDforPlayRecord =           " +
            "\(sat.universalSwitchIDforPlayRecord),     " +
            "UniversalSwitchIDforPlayStopRecord =       " +
            "\(sat.universalSwitchIDforPlayStopRecord), " +
            "IRMacroNumberForSATSpare0 =                " +
            "\(sat.iRMacroNumberForSATSpare0),          " +
            "IRMacroNumberForSATSpare1 =                " +
            "\(sat.iRMacroNumberForSATSpare1),          " +
            "IRMacroNumberForSATSpare2 =                " +
            "\(sat.iRMacroNumberForSATSpare2),          " +
            "IRMacroNumberForSATSpare3 =                " +
            "\(sat.iRMacroNumberForSATSpare3),          " +
            "IRMacroNumberForSATSpare4 =                " +
            "\(sat.iRMacroNumberForSATSpare4),          " +
            "IRMacroNumberForSATSpare5 =                " +
            "\(sat.iRMacroNumberForSATSpare5),          " +
                
            "SwitchNameforControl1 =                    " +
            "'\(sat.switchNameforControl1 ?? "C1")',    " +
            "SwitchIDforControl1 =                      " +
            "\(sat.switchIDforControl1),                " +
            "SwitchNameforControl2 =                    " +
            "'\(sat.switchNameforControl2 ?? "C2")',    " +
            "SwitchIDforControl2 =                      " +
            "\(sat.switchIDforControl2),                " +
            "SwitchNameforControl3 =                    " +
            "'\(sat.switchNameforControl3 ?? "C3")',    " +
            "SwitchIDforControl3 =                      " +
            "\(sat.switchIDforControl3),                " +
            "SwitchNameforControl4 =                    " +
            "'\(sat.switchNameforControl4 ?? "C4")',    " +
            "SwitchIDforControl4 =                      " +
            "\(sat.switchIDforControl4),                " +
            "SwitchNameforControl5 =                    " +
            "'\(sat.switchNameforControl5 ?? "C5")',    " +
            "SwitchIDforControl5 =                      " +
            "\(sat.switchIDforControl5),                " +
            "SwitchNameforControl6 =                    " +
            "'\(sat.switchNameforControl6 ?? "C6")',    " +
            "SwitchIDforControl6 =                      " +
            "\(sat.switchIDforControl6)                 " +
            "Where zoneID = \(sat.zoneID) and id = \(sat.id);"
        
        return executeSql(sql)
    }
    
    /// 删除 区域中的 sat
    func deleteSats(_ zoneID: UInt) -> Bool {
        
        // 1. 删除频道
        let channelSQL =
            "delete from SATChannels Where zoneID = \(zoneID);"
        
        if executeSql(channelSQL) == false {
            
            return false
        }
        
        // 2.删除分类
        let categorySQL =
            "delete from SATCategory Where zoneID = \(zoneID);"
        
        if executeSql(categorySQL) == false {
            
            return false
        }
        
        // 3.删除SAT
        let satSQL =
            "delete from SATInZone Where zoneID = \(zoneID);"
        
        return executeSql(satSQL)
    }
    
    /// 删除 指定的 sat
    func deleteSat(_ sat: SHMediaSAT) -> Bool {
        
        let sql =
            "delete from SATInZone    Where " +
            "zoneID = \(sat.zoneID)     and " +
            "SubnetID = \(sat.subnetID) and " +
            "DeviceID = \(sat.deviceID) ;"
        
        return executeSql(sql)
    }
    
    /// 获得区域中的 sat.
    func getSats(_ zoneID: UInt) -> [SHMediaSAT] {
        
        let sql =
            "select ID, remark, ZoneID,          " +
            "SubnetID, DeviceID,                 " +
            "UniversalSwitchIDforOn,             " +
            "UniversalSwitchStatusforOn,         " +
            "UniversalSwitchIDforOff,            " +
            "UniversalSwitchStatusforOff,        " +
            "UniversalSwitchIDforUp,             " +
            "UniversalSwitchIDforDown,           " +
            "UniversalSwitchIDforLeft,           " +
            "UniversalSwitchIDforRight,          " +
            "UniversalSwitchIDforOK ,            " +
            "UniversalSwitchIDfoMenu,            " +
            "UniversalSwitchIDforFAV,            " +
            "UniversalSwitchIDfor0,              " +
            "UniversalSwitchIDfor1,              " +
            "UniversalSwitchIDfor2,              " +
            "UniversalSwitchIDfor3,              " +
            "UniversalSwitchIDfor4,              " +
            "UniversalSwitchIDfor5,              " +
            "UniversalSwitchIDfor6,              " +
            "UniversalSwitchIDfor7,              " +
            "UniversalSwitchIDfor8,              " +
            "UniversalSwitchIDfor9,              " +
            "UniversalSwitchIDforPlayRecord,     " +
            "UniversalSwitchIDforPlayStopRecord, " +
            "IRMacroNumberForSATSpare0,          " +
            "IRMacroNumberForSATSpare1,          " +
            "IRMacroNumberForSATSpare2,          " +
            "IRMacroNumberForSATSpare3,          " +
            "IRMacroNumberForSATSpare4,          " +
            "IRMacroNumberForSATSpare5,          " +
            "UniversalSwitchIDforPREVChapter,    " +
            "UniversalSwitchIDforNextChapter,    " +
            "SwitchNameforControl1,              " +
            "SwitchIDforControl1,                " +
            "SwitchNameforControl2,              " +
            "SwitchIDforControl2,                " +
            "SwitchNameforControl3,              " +
            "SwitchIDforControl3,                " +
            "SwitchNameforControl4,              " +
            "SwitchIDforControl4,                " +
            "SwitchNameforControl5,              " +
            "SwitchIDforControl5,                " +
            "SwitchNameforControl6,              " +
            "SwitchIDforControl6                 " +
            "from SATInZone where                " +
            "ZoneID = \(zoneID) order by id;"
        
        let array = selectProprty(sql)
        
        var sats = [SHMediaSAT]()
        
        for dict in array {
            
            sats.append(SHMediaSAT(dict: dict))
        }
        
        return sats
    }
    
    /// 增加控制单元
    func addSatControlItems() {
        
        if isColumnName(
            "SwitchNameforControl1",
            consistinTable: "SATInZone") == false {
            
            // C1
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl1 TEXT DEFAULT 'C1';"
            )
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl1 INTEGER DEFAULT 0;"
            )
            
            // C2
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl2 TEXT DEFAULT 'C2';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl2 INTEGER DEFAULT 0;"
            )
            
            // C3
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl3 TEXT DEFAULT 'C3';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl3 INTEGER DEFAULT 0;"
            )
            
            // C4
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl4 TEXT DEFAULT 'C4';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl4 INTEGER DEFAULT 0;"
            )
            
            // C5
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl5 TEXT DEFAULT 'C5';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl5 INTEGER DEFAULT 0;"
            )
            
            // C6
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchNameforControl6 TEXT DEFAULT 'C6';"
            )
            
            _ = executeSql(
                "ALTER TABLE SATInZone ADD SwitchIDforControl6 INTEGER DEFAULT 0;"
            )
        }
    }
}


// MARK: - Sat Category 操作
extension SHSQLiteManager {
    

    /// 获得当前区域最大的 categoryID
    func getMaxCategoryID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(CategoryID) from SATCategory " +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
            let categoryID = dict["max(CategoryID)"] as? UInt else {
                
                return 0
        }
        
        return categoryID
    }
    
    /// 增加 sat category
    func insertSatCategory(_ category: SHMediaSATCategory) -> Bool {
        
        let sql =
            "insert into SATCategory(CategoryID,       " +
            "CategoryName, SequenceNo, ZoneID,         " +
            "SubnetID, DeviceID)                       " +
            "values(\(category.categoryID),            " +
            "'\(category.categoryName ?? "category")', " +
            "\(category.sequenceNo),                   " +
            "\(category.zoneID),                       " +
            "\(category.subnetID),                     " +
            "\(category.deviceID));"
        
        return executeSql(sql)
    }
    
    /// 更新 category 分类
    func updateSatCategory(_ category: SHMediaSATCategory) -> Bool {
        
        let sql =
            "update SATCategory set CategoryName =     " +
            "'\(category.categoryName ?? "category")', " +
            "SubnetID = \(category.subnetID),          " +
            "DeviceID = \(category.deviceID)           " +
            "Where CategoryID = \(category.categoryID) " +
            "and ZoneID = \(category.zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除 category
    func deleteSatCategory(_ category: SHMediaSATCategory) -> Bool {
        
        // 清除里面的频道
        if deleteSatChannels(category) == false {
            
            return false
        }
        
        let sql =
            "delete from SATCategory           Where " +
            "CategoryID = \(category.categoryID) and " +
            "ZoneID = \(category.zoneID);"
        
        return executeSql(sql)
    }
    
    /// 获得 Sat Category
    func getSatCategory(_ sat: SHMediaSAT) -> [SHMediaSATCategory] {
        
        let sql =
            "select CategoryID, CategoryName,    " +
            "SequenceNo, ZoneID , SubnetID,      " +
            "DeviceID from SATCategory           " +
            "where SubnetID = \(sat.subnetID)    " +
            "and DeviceID = \(sat.deviceID)      " +
            "order by CategoryID;"
        
        let array = selectProprty(sql)
        
        var categories = [SHMediaSATCategory]()
        
        for dict in array {
            
            categories.append(SHMediaSATCategory(dict: dict))
        }
        
        return categories
    }
    
    /// 增加SAT的分类参数
    func addMediaSATCategoryParameter() -> Bool {
        
        if isColumnName(
            "SubnetID",
            consistinTable: "SATCategory"
            ) == false {
            
            // 清除 satcategory中的所有数据
            _ = executeSql(
                "delete from SATCategory;"
            )

            _ = executeSql(
                "delete from SATChannels;"
            )

            _ = executeSql(
                "delete from SATChannelIconList;"
            )
            
            // 清除 satchannel中所有数据
                
            let subNetIDSQL =
                "ALTER TABLE SATCategory ADD " +
                "SubnetID INTEGER DEFAULT 0;"
            
            let deviceIDSQL =
                "ALTER TABLE SATCategory ADD " +
                "DeviceID INTEGER DEFAULT 0;"
            
            return executeSql(subNetIDSQL) &&
                   executeSql(deviceIDSQL)
        }
        
        return true
    }
}


// MARK: - sat channel
extension SHSQLiteManager {
    
    /// 删除 指定的频道
    func deleteSatChannel(_ channel: SHMediaSATChannel) -> Bool {
        
        let sql =
            "delete from SATChannels where " +
                "CategoryID = \(channel.categoryID) " +
                "and ZoneID = \(channel.zoneID)     " +
                "and ChannelNo = \(channel.channelNo) ;"
        
        return executeSql(sql)
    }
    
    /// 删除所有的频道
    func deleteSatChannels(_ category: SHMediaSATCategory) -> Bool {
        
        let sql =
            "delete from SATChannels where " +
            "CategoryID = \(category.categoryID) " +
            "and ZoneID = \(category.zoneID);"
        
        return executeSql(sql)
    }
    
    /// 获得SAT 指定分类中的所有频道
    func getSatChannels(_ category: SHMediaSATCategory) -> [SHMediaSATChannel] {
        
        let sql =
            "select CategoryID, ChannelID, ChannelNo,  " +
            "ChannelName, iconName, SequenceNo, ZoneID " +
            "from SATChannels where CategoryID =       " +
            "\(category.categoryID)                    " +
            "and ZoneID = \(category.zoneID);"
        
        let array = selectProprty(sql)
        var channels = [SHMediaSATChannel]()
        
        for dict in array {
            
            channels.append(SHMediaSATChannel(dict: dict))
        }
        
        return channels
    }
    
    /// 更新卫星电视频道
    func updateSatChannel(_ channel: SHMediaSATChannel) -> Bool {
        
        let sql = "update SATChannels set ChannelName = " +
            "'\(channel.channelName ?? "channel")',     " +
            "ChannelNo = \(channel.channelNo) where     " +
            "ZoneID = \(channel.zoneID) and             " +
            "CategoryID = \(channel.categoryID) and     " +
            "ChannelID = \(channel.channelID); "
        
        return executeSql(sql)
    }
    
    
    /// 增加电视频道
    ///
    /// - Parameter channel: <#channel description#>
    /// - Returns: <#return value description#>
    func insertSatChannel(_ channel: SHMediaSATChannel) -> Bool {
        
        let sql =
            "insert into SATChannels(CategoryID,        " +
            "ChannelID, ChannelNo, ChannelName,         " +
            "iconName, SequenceNo, ZoneID)              " +
            "Values ( \(channel.categoryID),            " +
            "\(channel.channelID),                      " +
            "\(channel.channelNo),                      " +
            "'\(channel.channelName ?? "channelName")', " +
            "'\(channel.iconName ?? "iconName")',       " +
            "\(channel.sequenceNo), \(channel.zoneID));"
        
        
        return executeSql(sql)
    }
    
    /// 获得当前分组最大的channelID
    func getMaxChannelID(_ category: SHMediaSATCategory) -> UInt {
        
        let sql =
            "select max(ChannelID) from SATChannels " +
            "where ZoneID = \(category.zoneID) and  " +
            "CategoryID = \(category.categoryID);"
        
        guard let dict = selectProprty(sql).last,
            let channelID = dict["max(ChannelID)"] as? UInt else {
                
                return 0
        }
        
        return channelID
    }
}
