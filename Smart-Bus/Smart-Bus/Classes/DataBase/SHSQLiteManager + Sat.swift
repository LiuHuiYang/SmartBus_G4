//
//  SHSQLiteManager + Sat.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/23.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Sat 操作
extension SHSQLiteManager {
    
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
