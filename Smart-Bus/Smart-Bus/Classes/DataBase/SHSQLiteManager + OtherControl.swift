//
//  SHSQLiteManager + OtherControl.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: -  OtherControl
extension SHSQLiteManager {
    
    /// 增加 OtherControl
    func insertOtherControl(_ otherControl: SHOtherControl) -> Bool {
        let sql =
            "insert into OtherControlInZone (      " +
            "OtherControlID, ZoneID, remark,       " +
            "ControlType, SubnetID, DeviceID,      " +
            "Parameter1, Parameter2) values (      "  +
            "\(otherControl.otherControlID),       " +
            "\(otherControl.zoneID),               " +
            "'\(otherControl.remark)',             " +
            "\(otherControl.controlType.rawValue), " +
            "\(otherControl.subnetID),             " +
            "\(otherControl.deviceID),             " +
            "\(otherControl.parameter1),           " +
            "\(otherControl.parameter2) );"
        
        return executeSql(sql)
    }
    
    /// 最大的 OtherControlID
    func getMaxOtherControlID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(OtherControlID) from " +
            "OtherControlInZone where        " +
            "ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
            let otherControlID = dict["max(OtherControlID)"] as? UInt else {
                return 0
        }
        
        return otherControlID
    }
    
    /// 更新 OtherControl
    func updateOtherControl(_ otherControl: SHOtherControl) -> Bool {
        
        let sql =
            "update OtherControlInZone set             " +
            "remark = '\(otherControl.remark)',        " +
            "ControlType =                             " +
            "\(otherControl.controlType.rawValue),     " +
            "SubnetID = \(otherControl.subnetID),      " +
            "DeviceID = \(otherControl.deviceID),      " +
            "Parameter1 = \(otherControl.parameter1),  " +
            "Parameter2 = \(otherControl.parameter2)   " +
            "where ZoneID = \(otherControl.zoneID) and " +
            "OtherControlID = \(otherControl.otherControlID);"
        
        return executeSql(sql)
    }
    
    /// 删除当前的 OtherControl
    func deleteOtherControl(_ otherControl: SHOtherControl) -> Bool {
        
        let sql =
            "delete from OtherControlInZone where   " +
            "ZoneID = \(otherControl.zoneID) and    " +
            "OtherControlID = \(otherControl.otherControlID);"
        
        return executeSql(sql)
    }
    
    /// 删除区域中的所有的 其它控制
    func deleteOtherControls(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from OtherControlInZone where " +
            "ZoneID = \(zoneID); "
        
        return executeSql(sql)
    }
    
    /// 查询当前区域中的所有OtherControl
    func getOtherControls(_ zoneID: UInt) -> [SHOtherControl] {
        
        let sql =
            "select id, ZoneID, OtherControlID, " +
            "remark, ControlType, SubnetID,     " +
            "DeviceID, Parameter1, Parameter2   " +
            "from OtherControlInZone where      " +
            "ZoneID = \(zoneID) order by OtherControlID;"
        
        let array = selectProprty(sql)
        
        var otherControls = [SHOtherControl]()
        
        for dict in array {
            
            otherControls.append(
                SHOtherControl(dictionary: dict))
        }
        
        return otherControls
    }
    
    /// 增加 其它控件
    func addOtherControl() -> Bool {
     
        let sql =
            "select Distinct SystemID from " +
                "systemDefnition where SystemID = " +
        "\(SHSystemDeviceType.otherControl.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
                "SystemName) values(" +
                "\(SHSystemDeviceType.otherControl.rawValue)," +
        "'Other Control');"
        
        return executeSql(addSQL)
        
    }
    
}
