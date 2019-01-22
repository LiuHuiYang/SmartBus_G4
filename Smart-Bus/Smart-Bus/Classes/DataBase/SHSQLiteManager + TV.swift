//
//  SHSQLiteManager + TV.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/22.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - TV操作
extension SHSQLiteManager {
    
   
    
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
            "IRMacroNumberForTVStart5             " +
            "from TVInZone where                  " +
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
