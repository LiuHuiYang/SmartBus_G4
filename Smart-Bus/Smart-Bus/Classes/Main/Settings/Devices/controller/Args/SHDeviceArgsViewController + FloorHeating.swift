//
//  SHDeviceArgsViewController + FloorHeating.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - FloorHeating
extension SHDeviceArgsViewController {
    
    /// 刷新 地热
    func refreshFloorHeating() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "Channel No.",
            "Outside Sensor SubNetID",
            "Outside Sensor DeviceID",
            "Outside Sensor ChannelNo"
        ]
        
        argsValues = [
            floorHeating?.floorHeatingRemark ?? "floor heating",
            "\(floorHeating?.subnetID ?? 1)",
            "\(floorHeating?.deviceID ?? 0)",
            "\(floorHeating?.channelNo ?? 0)",
            "\(floorHeating?.outsideSensorSubNetID ?? 0)",
            "\(floorHeating?.outsideSensorDeviceID ?? 0)",
            "\(floorHeating?.outsideSensorChannelNo ?? 0)"
        ]
    }
    
    /// 更新 地热
    func updateFloorHeating(value: String, index: Int) {
        
        switch (index) {
        case 0:
            self.floorHeating?.floorHeatingRemark = value
            
        case 1:
            self.floorHeating?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.floorHeating?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.floorHeating?.channelNo = UInt8(value) ?? 0
            
        case 4:
            self.floorHeating?.outsideSensorSubNetID = UInt8(value) ?? 1
            
        case 5:
            self.floorHeating?.outsideSensorDeviceID = UInt8(value) ?? 0
            
        case 6:
            self.floorHeating?.outsideSensorChannelNo =
                UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.updateFloorHeating(inZone: floorHeating)
    }
}
