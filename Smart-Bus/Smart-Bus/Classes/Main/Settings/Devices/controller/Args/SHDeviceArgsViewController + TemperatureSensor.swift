//
//  SHDeviceArgsViewController + TemperatureSensor.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
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
        
        switch (index) {
            
        case 0:
            self.temperatureSensor?.remark = value
            
        case 1:
            self.temperatureSensor?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.temperatureSensor?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.temperatureSensor?.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.update(temperatureSensor)
    }
}
