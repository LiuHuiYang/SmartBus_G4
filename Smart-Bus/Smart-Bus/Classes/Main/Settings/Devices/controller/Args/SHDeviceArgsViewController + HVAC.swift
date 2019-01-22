//
//  SHDeviceArgsViewController + HVAC.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - HVAC
extension SHDeviceArgsViewController {
    
    // 刷新 HVAC
    func refreshHVAC() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "ACNumber",
            "ACTypeID",
            "Channel No.",
            "temperature Sensor subnet ID",
            "temperature Sensor Device ID",
            "temperature Sensor Channel No."
        ]
        
        argsValues = [
            hvac?.acRemark ?? "hvac",
            "\(hvac?.subnetID ?? 1)",
            "\(hvac?.deviceID ?? 0)",
            "\(hvac?.acNumber ?? 0)",
            "\(hvac?.acTypeID.rawValue ?? 0)",
            "\(hvac?.channelNo ?? 0)",
            "\(hvac?.temperatureSensorSubNetID ?? 0)",
            "\(hvac?.temperatureSensorDeviceID ?? 0)",
            "\(hvac?.temperatureSensorChannelNo ?? 0)"
        ]
    }
    
    /// 保存HVAC
    func updateHVAC(value: String, index: Int) {
        
        guard let ac = self.hvac else {
            return
        }
        
        switch (index) {
        case 0:
            ac.acRemark = value
            
        case 1:
            ac.subnetID = UInt8(value) ?? 0
            
        case 2:
            ac.deviceID = UInt8(value) ?? 0
            
        case 3:
            ac.acNumber = UInt(value) ?? 0
            
        case 4:
            ac.acTypeID = SHAirConditioningType(rawValue: (UInt8(value) ?? 1)) ?? SHAirConditioningType.hvac
            
            
        case 5:
            ac.channelNo = UInt8(value) ?? 0
            
        case 6:
            ac.temperatureSensorSubNetID = UInt8(value) ?? 0
            
        case 7:
            ac.temperatureSensorDeviceID = UInt8(value) ?? 0
            
        case 8:
            ac.temperatureSensorChannelNo = UInt8(value) ?? 0
        default:
            break;
        } 
        
        _ = SHSQLiteManager.shared.updateHVAC(ac)
    }
}
