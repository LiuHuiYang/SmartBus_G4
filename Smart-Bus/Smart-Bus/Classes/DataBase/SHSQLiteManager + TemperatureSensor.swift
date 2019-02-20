//
//  SHSQLiteManager + TemperatureSensor.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - SHSQLiteManager
extension SHSQLiteManager {
    
    /// 增加 温度传感器
    func insertTemperatureSensor(_ sensor: SHTemperatureSensor) -> Bool {
        
        let sql =
            "insert into TemperatureSensorInZone "         +
            "(ZoneID, temperatureID, remark, "             +
            "SubnetID, DeviceID, ChannelNo) values "       +
            "(\(sensor.zoneID), \(sensor.temperatureID), " +
            "'\(sensor.remark ?? "temperature" )', "       +
            "\(sensor.subnetID), \(sensor.deviceID), "     +
            "\(sensor.channelNo) );"
        
        return executeSql(sql)
    }
    
    /// 更新 温度传感器
    func updateTemperatureSensor(_ sensor: SHTemperatureSensor) -> Bool {
        
        let sql =
            "update TemperatureSensorInZone set "   +
            "remark = '\(sensor.remark ?? "temperature" )', "
                                                    +
            "SubnetID = \(sensor.subnetID), "       +
            "DeviceID = \(sensor.deviceID), "       +
            "ChannelNo = \(sensor.channelNo) "      +
            "Where zoneID = \(sensor.zoneID) and "  +
            "temperatureID = \(sensor.temperatureID);"
        
        return executeSql(sql)
    }
    
    /// 获得区域中最大的 TemperatureID
    func getMaxTemperatureID(_ zoneID: UInt) -> UInt {
        
        let sql =
            "select max(TemperatureID) from "  +
            "TemperatureSensorInZone "         +
            "where ZoneID = \(zoneID);"
        
        guard let dict = selectProprty(sql).last,
        let temperatureID =
                dict["max(TemperatureID)"] as? UInt else {
            
            return 0
        }
        
        return temperatureID
    }
    
    /// 删除区域中的温度传感器
    func deleteTemperatureSensors(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from TemperatureSensorInZone " +
            "Where zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除 温度传感器
    func deleteTemperatureSensor(_ sensor: SHTemperatureSensor) -> Bool {
        
        let sql =
            "delete from TemperatureSensorInZone Where " +
            "zoneID = \(sensor.zoneID) and "             +
            "SubnetID = \(sensor.subnetID) and "         +
            "DeviceID = \(sensor.deviceID) and "         +
            "ChannelNo = \(sensor.channelNo) and "       +
            "temperatureID = \(sensor.temperatureID); "
        
        return executeSql(sql)
    }
    
    /// 查询当前区域中的所有温度传感器
    func getTemperatureSensors(zoneID: UInt) -> [SHTemperatureSensor] {
        
        let sql =
            "select ID, ZoneID, remark, temperatureID, " +
            "SubnetID, DeviceID, ChannelNo from "        +
            "TemperatureSensorInZone  where "            +
            "ZoneID = \(zoneID);"
        
        let array = selectProprty(sql)
        
        var sensors = [SHTemperatureSensor]()
        
        for dict in array {
            
            sensors.append(SHTemperatureSensor(dict: dict))
        }
        
        return sensors
    }
    
    /// 增加温度传感器
    func addTemperatureSensor() -> Bool {
        
        let sql =
            "select Distinct SystemID from " +
                "systemDefnition where SystemID = " +
        "\(SHSystemDeviceType.temperatureSensor.rawValue);"
        
        if selectProprty(sql).isEmpty == false {
            
            return true
        }
        
        let addSQL =
            "insert into systemDefnition (SystemID, " +
                "SystemName) values(" +
                "\(SHSystemDeviceType.temperatureSensor.rawValue)," +
        "'temperature Control');"
        
        return executeSql(addSQL)
        
    }
}
