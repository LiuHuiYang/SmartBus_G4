//
//  SHDeviceArgsViewController + TemperatureSensor.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation
 
// MARK: - TemperatureSensor
extension SHDeviceArgsViewController {
    
    /// 刷新 温度传感器
    func refreshTemperatureSensor() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "Channel No."
        ]
        
        argsValues = [
            
            temperatureSensor?.remark ?? "tem Sensor",
            "\(temperatureSensor?.subnetID ?? 1)",
            "\(temperatureSensor?.deviceID ?? 0)",
            "\(temperatureSensor?.channelNo ?? 0)"
        ]
    }
    
    /// 保存 4T
    func updateTemperatureSensor(value: String, index: Int) {
        
        guard let sensor = self.temperatureSensor else {
            return
        }
        
        switch (index) {
            
        case 0:
            sensor.remark = value
            
        case 1:
            sensor.subnetID = UInt8(value) ?? 0
            
        case 2:
            sensor.deviceID = UInt8(value) ?? 0
            
        case 3:
            sensor.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        } 
       
        _ = SHSQLiteManager.shared.updateTemperatureSensor(
            sensor
        )
    }
}
