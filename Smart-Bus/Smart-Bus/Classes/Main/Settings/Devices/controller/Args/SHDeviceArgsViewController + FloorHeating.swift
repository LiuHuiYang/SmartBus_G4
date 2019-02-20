//
//  SHDeviceArgsViewController + FloorHeating.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
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
        
        guard let floorheater = self.floorHeating else {
            return
        }
        
        switch (index) {
        case 0:
            floorheater.floorHeatingRemark = value
            
        case 1:
            floorheater.subnetID = UInt8(value) ?? 1
            
        case 2:
            floorheater.deviceID = UInt8(value) ?? 0
            
        case 3:
            floorheater.channelNo = UInt8(value) ?? 0
            
        case 4:
            floorheater.outsideSensorSubNetID = UInt8(value) ?? 1
            
        case 5:
            floorheater.outsideSensorDeviceID = UInt8(value) ?? 0
            
        case 6:
            floorheater.outsideSensorChannelNo =
                UInt8(value) ?? 0
            
        default:
            break;
        }
        
        _ = SHSQLiteManager.shared.updateFloorHeating(
            floorheater
        )
    }
}
