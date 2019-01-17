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
        
        switch (index) {
        case 0:
            self.hvac?.acRemark = value
            
        case 1:
            self.hvac?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.hvac?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.hvac?.acNumber = UInt(value) ?? 0
            
        case 4:
            self.hvac?.acTypeID = SHAirConditioningType(rawValue: (UInt8(value) ?? 1)) ?? SHAirConditioningType.hvac
            
            
        case 5:
            self.hvac?.channelNo = UInt8(value) ?? 0
            
        case 6:
            self.hvac?.temperatureSensorSubNetID = UInt8(value) ?? 0
            
        case 7:
            self.hvac?.temperatureSensorDeviceID = UInt8(value) ?? 0
            
        case 8:
            self.hvac?.temperatureSensorChannelNo = UInt8(value) ?? 0
        default:
            break;
        }
        
        SHSQLManager.share()?.updateHVAC(inZone: hvac)
    }
}
