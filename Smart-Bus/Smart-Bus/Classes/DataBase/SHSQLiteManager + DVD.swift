//
//  SHSQLiteManager + DVD.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/23.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - DVD的操作
extension SHSQLiteManager {
    
    /// 增加 DVD
    func insertDVD(_ dvd: SHMediaDVD) -> UInt {
        
        let sql =
            "insert into DVDInZone(remark, ZoneID,      " +
            "SubnetID, DeviceID,                        " +
            "UniversalSwitchIDforOn,                    " +
            "UniversalSwitchStatusforOn,                " +
            "UniversalSwitchIDforOff,                   " +
            "UniversalSwitchStatusforOff,               " +
            "UniversalSwitchIDfoMenu,                   " +
            "UniversalSwitchIDfoUp,                     " +
            "UniversalSwitchIDforDown,                  " +
            "UniversalSwitchIDforFastForward,           " +
            "UniversalSwitchIDforBackForward,           " +
            "UniversalSwitchIDforOK,                    " +
            "UniversalSwitchIDforPREVChapter,           " +
            "UniversalSwitchIDforNextChapter,           " +
            "UniversalSwitchIDforPlayPause,             " +
            "UniversalSwitchIDforPlayRecord,            " +
            "UniversalSwitchIDforPlayStopRecord,        " +
            "IRMacroNumberForDVDStart0,                 " +
            "IRMacroNumberForDVDStart1,                 " +
            "IRMacroNumberForDVDStart2,                 " +
            "IRMacroNumberForDVDStart3,                 " +
            "IRMacroNumberForDVDStart4,                 " +
            "IRMacroNumberForDVDStart5) values(         " +
            "'\(dvd.remark ?? "dvd")', \(dvd.zoneID),   " +
            "\(dvd.subnetID), \(dvd.deviceID),          " +
            "\(dvd.universalSwitchIDforOn),             " +
            "\(dvd.universalSwitchStatusforOn),         " +
            "\(dvd.universalSwitchIDforOff),            " +
            "\(dvd.universalSwitchStatusforOff),        " +
            "\(dvd.universalSwitchIDfoMenu),            " +
            "\(dvd.universalSwitchIDfoUp),              " +
            "\(dvd.universalSwitchIDforDown),           " +
            "\(dvd.universalSwitchIDforFastForward),    " +
            "\(dvd.universalSwitchIDforBackForward),    " +
            "\(dvd.universalSwitchIDforOK),             " +
            "\(dvd.universalSwitchIDforPREVChapter),    " +
            "\(dvd.universalSwitchIDforNextChapter),    " +
            "\(dvd.universalSwitchIDforPlayPause),      " +
            "\(dvd.universalSwitchIDforPlayRecord),     " +
            "\(dvd.universalSwitchIDforPlayStopRecord), " +
            "\(dvd.iRMacroNumberForDVDStart0),          " +
            "\(dvd.iRMacroNumberForDVDStart1),          " +
            "\(dvd.iRMacroNumberForDVDStart2),          " +
            "\(dvd.iRMacroNumberForDVDStart3),          " +
            "\(dvd.iRMacroNumberForDVDStart4),          " +
            "\(dvd.iRMacroNumberForDVDStart5) );"
        
        _ = executeSql(sql)
        
        let idSQL = "select max(ID) from DVDInZone;"
        
        guard let dict = selectProprty(idSQL).last,
        let id = dict["max(ID)"] as? UInt else {
            
            return 0
        }
        
        return id
    }
    
    /// 更新DVD
    func updateDVD(_ dvd: SHMediaDVD) -> Bool {
        
        let sql =
            "update DVDInZone set                       " +
            "remark = '\(dvd.remark ?? "dvd")',         " +
            "SubnetID = \(dvd.subnetID),                " +
            "DeviceID = \(dvd.deviceID),                " +
            "UniversalSwitchIDforOn =                   " +
            "\(dvd.universalSwitchIDforOn),             " +
            "UniversalSwitchStatusforOn =               " +
            "\(dvd.universalSwitchStatusforOn),         " +
            "UniversalSwitchIDforOff =                  " +
            "\(dvd.universalSwitchIDforOff),            " +
            "UniversalSwitchStatusforOff =              " +
            "\(dvd.universalSwitchStatusforOff),        " +
            "UniversalSwitchIDfoMenu =                  " +
            "\(dvd.universalSwitchIDfoMenu),            " +
            "UniversalSwitchIDfoUp =                    " +
            "\(dvd.universalSwitchIDfoUp),              " +
            "UniversalSwitchIDforDown =                 " +
            "\(dvd.universalSwitchIDforDown),           " +
            "UniversalSwitchIDforFastForward =          " +
            "\(dvd.universalSwitchIDforFastForward),    " +
            "UniversalSwitchIDforBackForward =          " +
            "\(dvd.universalSwitchIDforBackForward),    " +
            "UniversalSwitchIDforOK =                   " +
            "\(dvd.universalSwitchIDforOK),             " +
            "UniversalSwitchIDforPREVChapter =          " +
            "\(dvd.universalSwitchIDforPREVChapter),    " +
            "UniversalSwitchIDforNextChapter =          " +
            "\(dvd.universalSwitchIDforNextChapter),    " +
            "UniversalSwitchIDforPlayPause =            " +
            "\(dvd.universalSwitchIDforPlayPause),      " +
            "UniversalSwitchIDforPlayRecord =           " +
            "\(dvd.universalSwitchIDforPlayRecord),     " +
            "UniversalSwitchIDforPlayStopRecord =       " +
            "\(dvd.universalSwitchIDforPlayStopRecord), " +
            "IRMacroNumberForDVDStart0 =                " +
            "\(dvd.iRMacroNumberForDVDStart0),          " +
            "IRMacroNumberForDVDStart1 =                " +
            "\(dvd.iRMacroNumberForDVDStart1),          " +
            "IRMacroNumberForDVDStart2 =                " +
            "\(dvd.iRMacroNumberForDVDStart2),          " +
            "IRMacroNumberForDVDStart3 =                " +
            "\(dvd.iRMacroNumberForDVDStart3),          " +
            "IRMacroNumberForDVDStart4 =                " +
            "\(dvd.iRMacroNumberForDVDStart4),          " +
            "IRMacroNumberForDVDStart5 =                " +
            "\(dvd.iRMacroNumberForDVDStart5)           " +
            "Where zoneID = \(dvd.zoneID) and           " +
            "id = \(dvd.id);"
        
        return executeSql(sql)
    }
 
    /// 删除指定的DVD
    func deleteDVD(_ dvd: SHMediaDVD) -> Bool {
        
        let sql = "delete from DVDInZone Where " +
            "zoneID = \(dvd.zoneID)        and " +
            "SubnetID = \(dvd.subnetID)    and " +
            "DeviceID = \(dvd.deviceID) ;"
        
        return executeSql(sql)
    }
    
    /// 删除区域中的 dvds
    func deleteDVDs(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from DVDInZone Where zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 查询区域中的 DVD
    func getDVDs(_ zoneID: UInt) -> [SHMediaDVD] {
        
        let sql =
            "select ID, remark, ZoneID, SubnetID, DeviceID, " +
            "UniversalSwitchIDforOn,                        " +
            "UniversalSwitchStatusforOn,                    " +
            "UniversalSwitchIDforOff,                       " +
            "UniversalSwitchStatusforOff,                   " +
            "UniversalSwitchIDfoMenu,                       " +
            "UniversalSwitchIDfoUp,                         " +
            "UniversalSwitchIDforDown,                      " +
            "UniversalSwitchIDforFastForward,               " +
            "UniversalSwitchIDforBackForward,               " +
            "UniversalSwitchIDforOK,                        " +
            "UniversalSwitchIDforPREVChapter,               " +
            "UniversalSwitchIDforNextChapter,               " +
            "UniversalSwitchIDforPlayPause,                 " +
            "UniversalSwitchIDforPlayRecord,                " +
            "UniversalSwitchIDforPlayStopRecord,            " +
            "IRMacroNumberForDVDStart0,                     " +
            "IRMacroNumberForDVDStart1,                     " +
            "IRMacroNumberForDVDStart2,                     " +
            "IRMacroNumberForDVDStart3,                     " +
            "IRMacroNumberForDVDStart4,                     " +
            "IRMacroNumberForDVDStart5 from DVDInZone where " +
            "ZoneID = \(zoneID) order by id;"
        
        let array = selectProprty(sql)
        
        var dvds = [SHMediaDVD]()
        
        for dict in array {
            
            dvds.append(SHMediaDVD(dict: dict))
        }
        
        return dvds
    }
}
