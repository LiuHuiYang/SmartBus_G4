//
//  SHSQLiteManager + Projector.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/24.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Projector 操作
extension SHSQLiteManager {
    
    /// 增加 projector
    func insertProjector(_ projector: SHMediaProjector) -> UInt {
        
        let sql =
            "insert into ProjectorInZone (remark,           " +
            "ZoneID, SubnetID, DeviceID,                    " +
            "UniversalSwitchIDforOn,                        " +
            "UniversalSwitchStatusforOn,                    " +
            " UniversalSwitchIDforOff,                      " +
            "UniversalSwitchStatusforOff,                   " +
            "UniversalSwitchIDfoUp,                         " +
            "UniversalSwitchIDforDown,                      " +
            "UniversalSwitchIDforLeft,                      " +
            "UniversalSwitchIDforRight,                     " +
            "UniversalSwitchIDforOK,                        " +
            "UniversalSwitchIDfoMenu,                       " +
            "UniversalSwitchIDforSource,                    " +
            "IRMacroNumberForProjectorSpare0,               " +
            "IRMacroNumberForProjectorSpare1,               " +
            "IRMacroNumberForProjectorSpare2,               " +
            "IRMacroNumberForProjectorSpare3,               " +
            "IRMacroNumberForProjectorSpare4,               " +
            "IRMacroNumberForProjectorSpare5)               " +
            "values('\(projector.remark ?? "projectorr" )', " +
            "\(projector.zoneID), \(projector.subnetID),    " +
            "\(projector.deviceID),                         " +
            "\(projector.universalSwitchIDforOn),           " +
            "\(projector.universalSwitchStatusforOn),       " +
            "\(projector.universalSwitchIDforOff),          " +
            "\(projector.universalSwitchStatusforOff),      " +
            "\(projector.universalSwitchIDfoUp),            " +
            "\(projector.universalSwitchIDforDown),         " +
            "\(projector.universalSwitchIDforLeft),         " +
            "\(projector.universalSwitchIDforRight),        " +
            "\(projector.universalSwitchIDforOK),           " +
            "\(projector.universalSwitchIDfoMenu),          " +
            "\(projector.universalSwitchIDforSource),       " +
            "\(projector.iRMacroNumberForProjectorSpare0),  " +
            "\(projector.iRMacroNumberForProjectorSpare1),  " +
            "\(projector.iRMacroNumberForProjectorSpare2),  " +
            "\(projector.iRMacroNumberForProjectorSpare3),  " +
            "\(projector.iRMacroNumberForProjectorSpare4),  " +
            "\(projector.iRMacroNumberForProjectorSpare5));"
        
        _ = executeSql(sql)
        
        let idSQL = "select max(ID) from ProjectorInZone;"
        
        guard let dict = selectProprty(idSQL).last,
            let id = dict["max(ID)"] as? UInt else {
            
            return 0
        }
        
        return id
    }
    
    /// 更新 projector
    func updateProjector(_ projector: SHMediaProjector) -> Bool {
        
        let sql =
            "update ProjectorInZone set " +
            "remark = '\(projector.remark ?? "projector")'," +
            "SubnetID = \(projector.subnetID),             " +
            "DeviceID = \(projector.deviceID),             " +
            "UniversalSwitchIDforOn =                      " +
            "\(projector.universalSwitchIDforOn),          " +
            "UniversalSwitchStatusforOn =                  " +
            "\(projector.universalSwitchStatusforOn),      " +
            "UniversalSwitchIDforOff =                     " +
            "\(projector.universalSwitchIDforOff),         " +
            "UniversalSwitchStatusforOff =                 " +
            "\(projector.universalSwitchStatusforOff),     " +
            "UniversalSwitchIDfoUp =                       " +
            "\(projector.universalSwitchIDfoUp),           " +
            "UniversalSwitchIDforDown =                    " +
            "\(projector.universalSwitchIDforDown),        " +
            "UniversalSwitchIDforLeft =                    " +
            "\(projector.universalSwitchIDforLeft),        " +
            "UniversalSwitchIDforRight =                   " +
            "\(projector.universalSwitchIDforRight),       " +
            "UniversalSwitchIDforOK =                      " +
            "\(projector.universalSwitchIDforOK),          " +
            "UniversalSwitchIDfoMenu =                     " +
            "\(projector.universalSwitchIDfoMenu),         " +
            "UniversalSwitchIDforSource =                  " +
            "\(projector.universalSwitchIDforSource),      " +
            "IRMacroNumberForProjectorSpare0 =             " +
            "\(projector.iRMacroNumberForProjectorSpare0), " +
            "IRMacroNumberForProjectorSpare1 =             " +
            "\(projector.iRMacroNumberForProjectorSpare1), " +
            "IRMacroNumberForProjectorSpare2 =             " +
            "\(projector.iRMacroNumberForProjectorSpare2), " +
            "IRMacroNumberForProjectorSpare3 =             " +
            "\(projector.iRMacroNumberForProjectorSpare3), " +
            "IRMacroNumberForProjectorSpare4 =             " +
            "\(projector.iRMacroNumberForProjectorSpare4), " +
            "IRMacroNumberForProjectorSpare5 =             " +
            "\(projector.iRMacroNumberForProjectorSpare5)  " +
            "Where zoneID = \(projector.zoneID) and        " +
            "id = \(projector.id);"
        
        return executeSql(sql)
    }
    
    /// 删除区域中的 projector
    func deleteProjectors(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from ProjectorInZone Where " +
            "zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除指定的 projector
    func deleteProjector(_ projector: SHMediaProjector) -> Bool {
        
        let sql =
            "delete from ProjectorInZone    Where " +
            "zoneID = \(projector.zoneID)     and " +
            "SubnetID = \(projector.subnetID) and " +
            "DeviceID = \(projector.deviceID);"
        
        return executeSql(sql)
    }
    
    /// 获得当前区域的投影仪
    func getProjectors(_ zoneID: UInt) -> [SHMediaProjector] {
     
        let sql =
            "select ID, remark, ZoneID,       " +
            "SubnetID, DeviceID,              " +
            "UniversalSwitchIDforOn,          " +
            "UniversalSwitchStatusforOn,      " +
            "UniversalSwitchIDforOff,         " +
            "UniversalSwitchStatusforOff,     " +
            "UniversalSwitchIDfoMenu,         " +
            "UniversalSwitchIDfoUp,           " +
            "UniversalSwitchIDforDown,        " +
            "UniversalSwitchIDforLeft,        " +
            "UniversalSwitchIDforRight,       " +
            "UniversalSwitchIDforOK,          " +
            "UniversalSwitchIDforSource,      " +
            "IRMacroNumberForProjectorSpare0, " +
            "IRMacroNumberForProjectorSpare1, " +
            "IRMacroNumberForProjectorSpare2, " +
            "IRMacroNumberForProjectorSpare3, " +
            "IRMacroNumberForProjectorSpare4, " +
            "IRMacroNumberForProjectorSpare5  " +
            "from ProjectorInZone where       " +
            "ZoneID = \(zoneID) order by id;"
        
        let array = selectProprty(sql)
        var projectors = [SHMediaProjector]()
        
        for dict in array {
            
            projectors.append(SHMediaProjector(dict: dict))
        }
        
        return projectors
    }
}
