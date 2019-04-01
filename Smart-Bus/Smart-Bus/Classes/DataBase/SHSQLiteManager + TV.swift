//
//  SHSQLiteManager + TV.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/22.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - TV操作
extension SHSQLiteManager {
    
    /// 增加 TV
    func insertTV(_ tv: SHMediaTV) -> UInt {
        
        let sql =
            "insert into TVInZone (remark, ZoneID, " +
            "SubnetID, DeviceID,                   "  +
            "UniversalSwitchIDforOn,               " +
            "UniversalSwitchStatusforOn,           " +
            "UniversalSwitchIDforOff,              " +
            "UniversalSwitchStatusforOff,          " +
            "UniversalSwitchIDforCHAdd,            " +
            "UniversalSwitchIDforCHMinus,          " +
            "UniversalSwitchIDforVOLUp,            " +
            "UniversalSwitchIDforVOLDown,          " +
            "UniversalSwitchIDforMute,             " +
            "UniversalSwitchIDforMenu,             " +
            "UniversalSwitchIDforSource,           " +
            "UniversalSwitchIDforOK,               " +
            "UniversalSwitchIDfor0,                " +
            "UniversalSwitchIDfor1,                " +
            "UniversalSwitchIDfor2,                " +
            "UniversalSwitchIDfor3,                " +
            "UniversalSwitchIDfor4,                " +
            "UniversalSwitchIDfor5,                " +
            "UniversalSwitchIDfor6,                " +
            "UniversalSwitchIDfor7,                " +
            "UniversalSwitchIDfor8,                " +
            "UniversalSwitchIDfor9,                " +
            "IRMacroNumberForTVStart0,             " +
            "IRMacroNumberForTVStart1,             " +
            "IRMacroNumberForTVStart2,             " +
            "IRMacroNumberForTVStart3,             " +
            "IRMacroNumberForTVStart4,             " +
            "IRMacroNumberForTVStart5,             " +
              
            "SwitchNameforSpare1,                  " +
            "SwitchIDforSpare1,                    " +
            "SwitchNameforSpare2,                  " +
            "SwitchIDforSpare2,                    " +
            "SwitchNameforSpare3,                  " +
            "SwitchIDforSpare3,                    " +
            "SwitchNameforSpare4,                  " +
            "SwitchIDforSpare4,                    " +
            "SwitchNameforSpare5,                  " +
            "SwitchIDforSpare5,                    " +
            "SwitchNameforSpare6,                  " +
            "SwitchIDforSpare6,                    " +
            "SwitchNameforSpare7,                  " +
            "SwitchIDforSpare7,                    " +
            "SwitchNameforSpare8,                  " +
            "SwitchIDforSpare8,                    " +
            "SwitchNameforSpare9,                  " +
            "SwitchIDforSpare9,                    " +
            "SwitchNameforSpare10,                 " +
            "SwitchIDforSpare10,                   " +
            "SwitchNameforSpare11,                 " +
            "SwitchIDforSpare11,                   " +
            "SwitchNameforSpare12,                 " +
            "SwitchIDforSpare12 )                  " +
                
            "values('\(tv.remark ?? "tv")',        " +
            "\(tv.zoneID), \(tv.subnetID),         " +
            "\(tv.deviceID),                       " +
            "\(tv.universalSwitchIDforOn),         " +
            "\(tv.universalSwitchStatusforOn),     " +
            "\(tv.universalSwitchIDforOff),        " +
            "\(tv.universalSwitchStatusforOff),    " +
            "\(tv.universalSwitchIDforCHAdd),      " +
            "\(tv.universalSwitchIDforCHMinus),    " +
            "\(tv.universalSwitchIDforVOLUp),      " +
            "\(tv.universalSwitchIDforVOLDown),    " +
            "\(tv.universalSwitchIDforMute),       " +
            "\(tv.universalSwitchIDforMenu),       " +
            "\(tv.universalSwitchIDforSource),     " +
            "\(tv.universalSwitchIDforOK),         " +
            "\(tv.universalSwitchIDfor0),          " +
            "\(tv.universalSwitchIDfor1),          " +
            "\(tv.universalSwitchIDfor2),          " +
            "\(tv.universalSwitchIDfor3),          " +
            "\(tv.universalSwitchIDfor4),          " +
            "\(tv.universalSwitchIDfor5),          " +
            "\(tv.universalSwitchIDfor6),          " +
            "\(tv.universalSwitchIDfor7),          " +
            "\(tv.universalSwitchIDfor8),          " +
            "\(tv.universalSwitchIDfor9),          " +
            "\(tv.iRMacroNumberForTVStart0),       " +
            "\(tv.iRMacroNumberForTVStart1),       " +
            "\(tv.iRMacroNumberForTVStart2),       " +
            "\(tv.iRMacroNumberForTVStart3),       " +
            "\(tv.iRMacroNumberForTVStart4),       " +
            "\(tv.iRMacroNumberForTVStart5),       " +
        
            "'\(tv.switchNameforSpare1 ?? "Spare_1")',   " +
            "\(tv.switchIDforSpare1),                    " +
            "'\(tv.switchNameforSpare2 ?? "Spare_2")',   " +
            "\(tv.switchIDforSpare2),                    " +
            "'\(tv.switchNameforSpare3 ?? "Spare_3")',   " +
            "\(tv.switchIDforSpare3),                    " +
            "'\(tv.switchNameforSpare4 ?? "Spare_4")',   " +
            "\(tv.switchIDforSpare4),                    " +
            "'\(tv.switchNameforSpare5 ?? "Spare_5")',   " +
            "\(tv.switchIDforSpare5),                    " +
            "'\(tv.switchNameforSpare6 ?? "Spare_6")',   " +
            "\(tv.switchIDforSpare6),                    " +
            "'\(tv.switchNameforSpare7 ?? "Spare_7" )',  " +
            "\(tv.switchIDforSpare7),                    " +
            "'\(tv.switchNameforSpare8 ?? "Spare_8")',   " +
            "\(tv.switchIDforSpare8),                    " +
            "'\(tv.switchNameforSpare9 ?? "Spare_9")',   " +
            "\(tv.switchIDforSpare9),                    " +
            "'\(tv.switchNameforSpare10 ?? "Spare_10")', " +
            "\(tv.switchIDforSpare10),                   " +
            "'\(tv.switchNameforSpare11 ?? "Spare_11")', " +
            "\(tv.switchIDforSpare11),                   " +
            "'\(tv.switchNameforSpare12 ?? "Spare_12")', " +
            "\(tv.switchIDforSpare12));"
        
        _ = executeSql(sql)
        
        let idSQL = "select max(ID) from TVInZone;"
        
        guard let dict = selectProprty(idSQL).last,
            let id = dict["max(ID)"] as? UInt else {
                
                return 0
        }
        
        return id
    }
   
    /// 更新 TV
    func updateTV(_ tv: SHMediaTV) -> Bool {
        
        let sql =
            "update TVInZone set "                +
            "remark = '\(tv.remark ?? "tv")', "   +
            "SubnetID = \( tv.subnetID), "        +
            "DeviceID = \(tv.deviceID),  "        +
            "UniversalSwitchIDforOn = "           +
            "\(tv.universalSwitchIDforOn), "      +
            "UniversalSwitchStatusforOn = "       +
            "\(tv.universalSwitchStatusforOn), "  +
            "UniversalSwitchIDforOff = "          +
            "\(tv.universalSwitchIDforOff), "     +
            "UniversalSwitchStatusforOff = "      +
            "\(tv.universalSwitchStatusforOff), " +
            "UniversalSwitchIDforCHAdd = "        +
            "\(tv.universalSwitchIDforCHAdd), "   +
            "UniversalSwitchIDforCHMinus = "      +
            "\(tv.universalSwitchIDforCHMinus), " +
            "UniversalSwitchIDforVOLUp = "        +
            "\(tv.universalSwitchIDforVOLUp), "   +
            "UniversalSwitchIDforVOLDown = "      +
            "\(tv.universalSwitchIDforVOLDown), " +
            "UniversalSwitchIDforMute = "         +
            "\(tv.universalSwitchIDforMute), "    +
            "UniversalSwitchIDforMenu = "         +
            "\(tv.universalSwitchIDforMenu),"     +
            "UniversalSwitchIDforSource = "       +
            "\(tv.universalSwitchIDforSource), "  +
            "UniversalSwitchIDforOK = "           +
            "\(tv.universalSwitchIDforOK), "      +
            "UniversalSwitchIDfor0 = "            +
            "\(tv.universalSwitchIDfor0), "       +
            "UniversalSwitchIDfor1 = "            +
            "\(tv.universalSwitchIDfor1), "       +
            "UniversalSwitchIDfor2 = "            +
            "\(tv.universalSwitchIDfor2), "       +
            "UniversalSwitchIDfor3 = "            +
            "\(tv.universalSwitchIDfor3), "       +
            "UniversalSwitchIDfor4 = "            +
            "\(tv.universalSwitchIDfor4), "       +
            "UniversalSwitchIDfor5 = "            +
            "\(tv.universalSwitchIDfor5), "       +
            "UniversalSwitchIDfor6 = "            +
            "\(tv.universalSwitchIDfor6), "       +
            "UniversalSwitchIDfor7 = "            +
            "\(tv.universalSwitchIDfor7), "       +
            "UniversalSwitchIDfor8 = "            +
            "\(tv.universalSwitchIDfor8), "       +
            "UniversalSwitchIDfor9 = "            +
            "\(tv.universalSwitchIDfor9), "       +
            "IRMacroNumberForTVStart0 = "         +
            "\(tv.iRMacroNumberForTVStart0),"     +
            "IRMacroNumberForTVStart1 = "         +
            "\(tv.iRMacroNumberForTVStart1), "    +
            "IRMacroNumberForTVStart2 = "         +
            "\(tv.iRMacroNumberForTVStart2), "    +
            "IRMacroNumberForTVStart3 = "         +
            "\(tv.iRMacroNumberForTVStart3), "    +
            "IRMacroNumberForTVStart4 = "         +
            "\(tv.iRMacroNumberForTVStart4), "    +
            "IRMacroNumberForTVStart5 = "         +
            "\(tv.iRMacroNumberForTVStart5), "    +
                
            "SwitchNameforSpare1 =                       " +
            "'\(tv.switchNameforSpare1 ?? "Spare_1")',   " +
            "SwitchIDforSpare1 =                         " +
            "\(tv.switchIDforSpare1),                    " +
            "SwitchNameforSpare2 =                       " +
            "'\(tv.switchNameforSpare2 ?? "Spare_2")',   " +
            "SwitchIDforSpare2 =                         " +
            "\(tv.switchIDforSpare2),                    " +
            "SwitchNameforSpare3 =                       " +
            "'\(tv.switchNameforSpare3 ?? "Spare_3")',   " +
            "SwitchIDforSpare3 =                         " +
            "\(tv.switchIDforSpare3),                    " +
            "SwitchNameforSpare4 =                       " +
            "'\(tv.switchNameforSpare4 ?? "Spare_4")',   " +
            "SwitchIDforSpare4 =                         " +
            "\(tv.switchIDforSpare4),                    " +
            "SwitchNameforSpare5 =                       " +
            "'\(tv.switchNameforSpare5 ?? "Spare_5")',   " +
            "SwitchIDforSpare5 =                         " +
            "\(tv.switchIDforSpare5),                    " +
            "SwitchNameforSpare6 =                       " +
            "'\(tv.switchNameforSpare6 ?? "Spare_6")',   " +
            "SwitchIDforSpare6 =                         " +
            "\(tv.switchIDforSpare6),                    " +
            "SwitchNameforSpare7 =                       " +
            "'\(tv.switchNameforSpare7 ?? "Spare_7")',   " +
            "SwitchIDforSpare7 =                         " +
            "\(tv.switchIDforSpare7),                    " +
            "SwitchNameforSpare8 =                       " +
            "'\(tv.switchNameforSpare8 ?? "Spare_8")',   " +
            "SwitchIDforSpare8 =                         " +
            "\(tv.switchIDforSpare8),                    " +
            "SwitchNameforSpare9 =                       " +
            "'\(tv.switchNameforSpare9 ?? "Spare_9")',   " +
            "SwitchIDforSpare9 =                         " +
            "\(tv.switchIDforSpare9),                    " +
            "SwitchNameforSpare10 =                      " +
            "'\(tv.switchNameforSpare10 ?? "Spare_10")', " +
            "SwitchIDforSpare10 =                        " +
            "\(tv.switchIDforSpare10),                   " +
            "SwitchNameforSpare11 =                      " +
            "'\(tv.switchNameforSpare11 ?? "Spare_11")', " +
            "SwitchIDforSpare11 =                        " +
            "\(tv.switchIDforSpare11),                   " +
            "SwitchNameforSpare12 =                      " +
            "'\(tv.switchNameforSpare12 ?? "Spare_12")', " +
            "SwitchIDforSpare12 =                        " +
            "\(tv.switchIDforSpare12)                    " +
                
            "Where zoneID = \(tv.zoneID) and id = \(tv.id);"
        
        return executeSql(sql)
    }
    
    /// 删除区域中的TV
    func deleteTVs(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from TVInZone Where zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除指定TV
    func deleteTV(_ tv: SHMediaTV) -> Bool {
        
        let sql =
            "delete from TVInZone    Where " +
            "zoneID = \(tv.zoneID)     and " +
            "SubnetID = \(tv.subnetID) and " +
            "DeviceID = \(tv.deviceID) ; "
        
        return executeSql(sql)
    }
    
    /// 查询当前区域中的电视
    func getMediaTV(_ zoneID: UInt) -> [SHMediaTV] {
        
        let sql =
            "select ID, remark, ZoneID, SubnetID, " +
            "DeviceID, UniversalSwitchIDforOn,    " +
            "UniversalSwitchStatusforOn,          " +
            "UniversalSwitchIDforOff,             " +
            "UniversalSwitchStatusforOff,         " +
            "UniversalSwitchIDforCHAdd,           " +
            "UniversalSwitchIDforCHMinus,         " +
            "UniversalSwitchIDforVOLUp,           " +
            "UniversalSwitchIDforVOLDown,         " +
            "UniversalSwitchIDforMute,            " +
            "UniversalSwitchIDforMenu,            " +
            "UniversalSwitchIDforSource,          " +
            "UniversalSwitchIDforOK,              " +
            "UniversalSwitchIDfor0,               " +
            "UniversalSwitchIDfor1,               " +
            "UniversalSwitchIDfor2,               " +
            "UniversalSwitchIDfor3,               " +
            "UniversalSwitchIDfor4,               " +
            "UniversalSwitchIDfor5,               " +
            "UniversalSwitchIDfor6,               " +
            "UniversalSwitchIDfor7,               " +
            "UniversalSwitchIDfor8,               " +
            "UniversalSwitchIDfor9,               " +
            "IRMacroNumberForTVStart0,            " +
            "IRMacroNumberForTVStart1,            " +
            "IRMacroNumberForTVStart2,            " +
            "IRMacroNumberForTVStart3,            " +
            "IRMacroNumberForTVStart4,            " +
            "IRMacroNumberForTVStart5,            " +
                
            "SwitchNameforSpare1,                    " +
            "SwitchIDforSpare1,                      " +
            "SwitchNameforSpare2,                    " +
            "SwitchIDforSpare2,                      " +
            "SwitchNameforSpare3,                    " +
            "SwitchIDforSpare3,                      " +
            "SwitchNameforSpare4,                    " +
            "SwitchIDforSpare4,                      " +
            "SwitchNameforSpare5,                    " +
            "SwitchIDforSpare5,                      " +
            "SwitchNameforSpare6,                    " +
            "SwitchIDforSpare6,                      " +
            "SwitchNameforSpare7,                    " +
            "SwitchIDforSpare7,                      " +
            "SwitchNameforSpare8,                    " +
            "SwitchIDforSpare8,                      " +
            "SwitchNameforSpare9,                    " +
            "SwitchIDforSpare9,                      " +
            "SwitchNameforSpare10,                   " +
            "SwitchIDforSpare10,                     " +
            "SwitchNameforSpare11,                   " +
            "SwitchIDforSpare11,                     " +
            "SwitchNameforSpare12,                   " +
            "SwitchIDforSpare12                      " +
            "from TVInZone where                     " +
            "ZoneID = \(zoneID) order by id;"
        
        let array = selectProprty(sql)
        var tvs = [SHMediaTV]()
        
        for dict in array {
            
            tvs.append(SHMediaTV(dict: dict))
        }
        
        return tvs
    }
}


// MARK: - 增加字段
extension SHSQLiteManager {
    
    /// 增加电视的更多参数
    func addMediaTVParameter() -> Bool {
        
        if isColumnName(
            "SwitchNameforSpare1",
            consistinTable: "TVInZone"
            ) == false {
            
            for index in 1 ... 12 {
                
                let nameSQL =
                    "ALTER TABLE TVInZone ADD "   +
                    "SwitchNameforSpare\(index) " +
                    "TEXT DEFAULT  'Spare_\(index)';"
                
                let valueSQL =
                    "ALTER TABLE TVInZone ADD " +
                    "SwitchIDforSpare\(index) " +
                    "INTEGER DEFAULT  0;"
                
                _ = executeSql(nameSQL)
                _ = executeSql(valueSQL)
            }
            
            return true
        }
        
        return true
    }
    
    /// 增加媒体设备标签
    func addMediaDeviceRemark() {
        
        if isColumnName(
            "remark",
            consistinTable: "TVInZone") == false {
            
            // 增加TV remark
            _ = executeSql(
                "ALTER TABLE TVInZone ADD remark TEXT NOT NULL DEFAULT 'TV';"
            )
            
            // 增加 AppleTV remark
            _ = executeSql(
                "ALTER TABLE AppleTVInZone ADD remark TEXT NOT NULL DEFAULT 'APPLE TV';"
            )
            
            // 增加 DVDremark
            _ = executeSql(
                "ALTER TABLE DVDInZone ADD remark TEXT NOT NULL DEFAULT 'DVD';"
            )
            
            // 增加 ProjectorInZone remark
            _ = executeSql(
                "ALTER TABLE ProjectorInZone ADD remark TEXT NOT NULL DEFAULT 'PROJECTOR';"
            )
            
            // 增加 卫星电视 remark
            _ = executeSql(
                "ALTER TABLE SATInZone ADD remark TEXT NOT NULL DEFAULT 'SATELLITE TV';"
            )
        }
    }
}
