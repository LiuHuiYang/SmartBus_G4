//
//  SHSQLiteManager + AppleTV.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/23.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Apple TV 的操作
extension SHSQLiteManager {

    func insertAppleTV(_ tv: SHMediaAppleTV) -> UInt {

        let sql =
            "insert into AppleTVInZone (remark, ZoneID,  " +
            "SubnetID, DeviceID, UniversalSwitchIDforOn, " +
            "UniversalSwitchStatusforOn,                 " +
            "UniversalSwitchIDforOff,                    " +
            "UniversalSwitchStatusforOff,                " +
            "UniversalSwitchIDforUp,                     " +
            "UniversalSwitchIDforDown,                   " +
            "UniversalSwitchIDforLeft,                   " +
            "UniversalSwitchIDforRight,                  " +
            "UniversalSwitchIDforOK,                     " +
            "UniversalSwitchIDforMenu,                   " +
            "UniversalSwitchIDforPlayPause,              " +
            "IRMacroNumberForAppleTVStart0,              " +
            "IRMacroNumberForAppleTVStart1,              " +
            "IRMacroNumberForAppleTVStart2,              " +
            "IRMacroNumberForAppleTVStart3,              " +
            "IRMacroNumberForAppleTVStart4,              " +
            "IRMacroNumberForAppleTVStart5) values(      " +
            "'\(tv.remark ?? "Apple TV")', \(tv.zoneID), " +
            "\(tv.subnetID), \(tv.deviceID),             " +
            "\(tv.universalSwitchIDforOn),               " +
            "\(tv.universalSwitchStatusforOn),           " +
            "\(tv.universalSwitchIDforOff),              " +
            "\(tv.universalSwitchStatusforOff),          " +
            "\(tv.universalSwitchIDforUp),               " +
            "\(tv.universalSwitchIDforDown),             " +
            "\(tv.universalSwitchIDforLeft),             " +
            "\(tv.universalSwitchIDforRight),            " +
            "\(tv.universalSwitchIDforOK),               " +
            "\(tv.universalSwitchIDforMenu),             " +
            "\(tv.universalSwitchIDforPlayPause),        " +
            "\(tv.iRMacroNumberForAppleTVStart0),        " +
            "\(tv.iRMacroNumberForAppleTVStart1),        " +
            "\(tv.iRMacroNumberForAppleTVStart2),        " +
            "\(tv.iRMacroNumberForAppleTVStart3),        " +
            "\(tv.iRMacroNumberForAppleTVStart4),        " +
            "\(tv.iRMacroNumberForAppleTVStart5));"
        
        _ = executeSql(sql)
        
        let idSQL = "select max(ID) from AppleTVInZone;"
        
        guard let dict = selectProprty(idSQL).last ,
            let id = dict["max(ID)"] as? UInt else {
                
            return 0
        }
        
        return id
    }
    
    /// 更新 AppleTV
    func updateAppleTV(_ tv: SHMediaAppleTV) -> Bool {
        
        let sql = "update AppleTVInZone set         " +
            "remark = '\(tv.remark ?? "Apple TV")', " +
            "SubnetID = \(tv.subnetID),             " +
            "DeviceID = \(tv.deviceID),             " +
            "UniversalSwitchIDforOn =               " +
            "\(tv.universalSwitchIDforOn),          " +
            "UniversalSwitchStatusforOn =           " +
            "\(tv.universalSwitchStatusforOn),      " +
            "UniversalSwitchIDforOff =              " +
            "\(tv.universalSwitchIDforOff),         " +
            "UniversalSwitchStatusforOff =          " +
            "\(tv.universalSwitchStatusforOff),     " +
            "UniversalSwitchIDforUp =               " +
            "\(tv.universalSwitchIDforUp),          " +
            "UniversalSwitchIDforDown =             " +
            "\(tv.universalSwitchIDforDown),        " +
            "UniversalSwitchIDforLeft =             " +
            "\(tv.universalSwitchIDforLeft),        " +
            "UniversalSwitchIDforRight =            " +
            "\(tv.universalSwitchIDforRight),       " +
            "UniversalSwitchIDforOK =               " +
            "\(tv.universalSwitchIDforOK),          " +
            "UniversalSwitchIDforMenu =             " +
            "\(tv.universalSwitchIDforMenu),        " +
            "UniversalSwitchIDforPlayPause =        " +
            "\(tv.universalSwitchIDforPlayPause),   " +
            "IRMacroNumberForAppleTVStart0 =        " +
            "\(tv.iRMacroNumberForAppleTVStart0),   " +
            "IRMacroNumberForAppleTVStart1 =        " +
            "\(tv.iRMacroNumberForAppleTVStart1),   " +
            "IRMacroNumberForAppleTVStart2 =        " +
            "\(tv.iRMacroNumberForAppleTVStart2),   " +
            "IRMacroNumberForAppleTVStart3 =        " +
            "\(tv.iRMacroNumberForAppleTVStart3),   " +
            "IRMacroNumberForAppleTVStart4 =        " +
            "\(tv.iRMacroNumberForAppleTVStart4),   " +
            "IRMacroNumberForAppleTVStart5 =        " +
            "\(tv.iRMacroNumberForAppleTVStart5)    " +
            "Where zoneID = \(tv.zoneID) and        " +
            "id = \(tv.id);"
        
        return executeSql(sql)
    }
    
    /// 删除 区域中的 Apple TV
    func deleteAppleTVs(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from AppleTVInZone Where " +
            "zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除指定的 Apple TV
    func deleteAppleTV(_ tv: SHMediaAppleTV) -> Bool {
        
        let sql =
            "delete from AppleTVInZone Where " +
            "zoneID = \(tv.zoneID)       and " +
            "SubnetID = \(tv.subnetID)   and " +
            "DeviceID = \(tv.deviceID);"
        
        return executeSql(sql)
    }
    
    /// 获得区域中的 Apple TV
    func getAppleTV(_ zoneID: UInt) -> [SHMediaAppleTV] {
        
        let sql =
            "select ID, remark, ZoneID, SubnetID, DeviceID, " +
            "UniversalSwitchIDforOn,                        " +
            "UniversalSwitchStatusforOn,                    " +
            "UniversalSwitchIDforOff,                       " +
            "UniversalSwitchStatusforOff,                   " +
            "UniversalSwitchIDforUp,                        " +
            "UniversalSwitchIDforDown,                      " +
            "UniversalSwitchIDforLeft,                      " +
            "UniversalSwitchIDforRight,                     " +
            "UniversalSwitchIDforOK,                        " +
            "UniversalSwitchIDforMenu,                      " +
            "UniversalSwitchIDforPlayPause,                 " +
            "IRMacroNumberForAppleTVStart0,                 " +
            "IRMacroNumberForAppleTVStart1,                 " +
            "IRMacroNumberForAppleTVStart2,                 " +
            "IRMacroNumberForAppleTVStart3,                 " +
            "IRMacroNumberForAppleTVStart4,                 " +
            "IRMacroNumberForAppleTVStart5                  " +
            "from AppleTVInZone where                       " +
            "ZoneID = \(zoneID) order by id;"
        
        let array = selectProprty(sql)
        var appleTVs = [SHMediaAppleTV]()
        
        for dict in array {
            
            appleTVs.append(SHMediaAppleTV(dict: dict))
        }
        
        return appleTVs
        
    }
}
