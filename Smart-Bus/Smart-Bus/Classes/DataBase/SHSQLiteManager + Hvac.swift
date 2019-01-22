//
//  SHSQLiteManager + Hvac.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/22.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - HVAC操作
extension SHSQLiteManager {
    
    
    /// 增加空调
    func insertHVAC(_ hvac: SHHVAC) -> UInt {
        
        let sql =
            "insert into HVACInZone (ZoneID, SubnetID, " +
            "DeviceID, ACNumber, ACTypeID, ACRemark,   " +
            "temperatureSensorSubNetID,                " +
            "temperatureSensorDeviceID,                " +
            "temperatureSensorChannelNo, channelNo)    " +
            "values(\(hvac.zoneID), \(hvac.subnetID),  " +
            "\(hvac.deviceID), \(hvac.acNumber),       " +
            "\(hvac.acTypeID.rawValue),                " +
            "'\(hvac.acRemark)',                       " +
            "\(hvac.temperatureSensorSubNetID),        " +
            "\(hvac.temperatureSensorDeviceID),        " +
            "\(hvac.temperatureSensorChannelNo),       " +
            "\(hvac.channelNo) );"
        
        _ = executeSql(sql)
        
        let idSQL = "select max(ID) from HVACInZone;"
        guard let dict = selectProprty(idSQL).last,
            let id = dict["max(ID)"] as? UInt else {
            return 0
        }
        
        return id
    }
    
    /// 更新 HVAC
    func updateHVAC(_ hvac: SHHVAC) -> Bool {
        
        let sql =
            "update HVACInZone set " +
            "SubnetID = \(hvac.subnetID), "          +
            "DeviceID = \(hvac.deviceID), "          +
            "ACNumber = \(hvac.acNumber), "          +
            "ACTypeID = \(hvac.acTypeID.rawValue), " +
            "ACRemark = '\(hvac.acRemark)', "        +
            "temperatureSensorSubNetID = "           +
            "\(hvac.temperatureSensorSubNetID), "    +
            "temperatureSensorDeviceID = "           +
            "\(hvac.temperatureSensorDeviceID), "    +
            "temperatureSensorChannelNo = "          +
            "\(hvac.temperatureSensorChannelNo), "   +
            "channelNo = \(hvac.channelNo) "         +
            "Where zoneID = \(hvac.zoneID) and "     +
            "id = \(hvac.id);"
        
        return executeSql(sql)
    }
    
    /// 删除区域中的空调
    func deleteHVACs(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from HVACInZone Where " +
            "zoneID = \(zoneID); "
        
        return executeSql(sql)
    }
    
    /// 删除HVAC
    func deleteHVAC(_ hvac: SHHVAC) -> Bool {
        
        let sql =
            "delete from HVACInZone    Where " +
            "zoneID = \(hvac.zoneID)     and " +
            "SubnetID = \(hvac.subnetID) and " +
            "DeviceID = \(hvac.deviceID) and " +
            "ACNumber = \(hvac.acNumber) ;"
        
        return executeSql(sql)
    }
    
    /// 查询区域中的所夺空调
    func getHVACs(_ zoneID: UInt) -> [SHHVAC] {
        
        let sql =
            "select id, ZoneID, SubnetID, DeviceID, " +
            "ACNumber, ACTypeID, acRemark, "          +
            "temperatureSensorSubNetID, "             +
            "temperatureSensorDeviceID, "             +
            "temperatureSensorChannelNo, channelNo "  +
            "from HVACInZone where ZoneID = \(zoneID);"
        
        let array = selectProprty(sql)
        
        var hvacs = [SHHVAC]()
        
        for dict in array {
            
            hvacs.append(SHHVAC(dictionary: dict))
        }
        
        return hvacs
    }
    
    /// 增加HVAC字段
    func addHvacParameter() {
        
        // 增加用于显示温度的传感器的三个参数
        if isColumnName(
            "temperatureSensorSubNetID",
            consistinTable: "HVACInZone"
            ) == false {
            
            _ = executeSql(
                "ALTER TABLE HVACInZone ADD temperatureSensorSubNetID INTEGER NOT NULL DEFAULT 1;"
            )
            
            _ = executeSql(
                "ALTER TABLE HVACInZone ADD temperatureSensorDeviceID INTEGER NOT NULL DEFAULT 0;"
            )
            
            _ = executeSql(
                "ALTER TABLE HVACInZone ADD temperatureSensorChannelNo INTEGER NOT NULL DEFAULT 0;"
            )
        }
    }
    
}


// MARK: - HVACSetUpInfo的操作
extension SHSQLiteManager {
    
    func updateHvacSetUpInfo(_ isCelsius: Bool) -> Bool {
        
        let flag = isCelsius ? 1 : 0
        
        let sql =
            "update HVACSetUp set isCelsius = \(flag);"
        
        return executeSql(sql)
    }
    
    /// 获得空调的配置信息
    func getHvacSetUpInfo() -> SHHVACSetUpInfo? {
        
        let sql =
            "select isCelsius, TempertureOfCold, " +
            "TempertureOfCool, TempertureOfWarm, " +
            "TempertureOfHot from HVACSetUp;"
        
        guard let dict = selectProprty(sql).last else {
            
            return nil
        }
      
        return SHHVACSetUpInfo(dict: dict)
    }
}
