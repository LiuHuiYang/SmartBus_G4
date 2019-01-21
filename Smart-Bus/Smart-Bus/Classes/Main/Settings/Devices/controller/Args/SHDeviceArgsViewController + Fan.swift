//
//  SHDeviceArgsViewController + Fan.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - Fan
extension SHDeviceArgsViewController {
    
    func refreshFan() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "ChannelNO",
            "FanTypeID",
            "Remark",
            "Reserved1",
            "Reserved2",
            "Reserved3",
            "Reserved4",
            "Reserved5"
        ]
        
        
        argsValues = [
            
            fan?.fanName ?? "fan",
            "\(fan?.subnetID ?? 1)",
            "\(fan?.deviceID ?? 0)",
            "\(fan?.channelNO ?? 0)",
            "\(fan?.fanTypeID.rawValue ?? 0)",
            "\(fan?.remark ?? "fan")",
            "\(fan?.reserved1 ?? 0)",
            "\(fan?.reserved2 ?? 0)",
            "\(fan?.reserved3 ?? 0)",
            "\(fan?.reserved4 ?? 0)",
            "\(fan?.reserved5 ?? 0)",
        ]
    }
    
    func updateFan(value: String, index: Int) {
        
        guard let fan = self.fan else {
            return
        }
        
        switch (index) {
        case 0:
            fan.fanName = value
            
        case 1:
            fan.subnetID = UInt8(value) ?? 1
            
        case 2:
            fan.deviceID = UInt8(value) ?? 0
            
        case 3:
            fan.channelNO = UInt8(value) ?? 0
            
        case 4:
            fan.fanTypeID = (SHFanType(rawValue: UInt(value) ?? 0)) ?? .unknow
            
        case 5:
            fan.remark = value
            
        case 6:
            fan.reserved1 = UInt(value) ?? 0
            
        case 7:
            fan.reserved2 = UInt(value) ?? 0
            
        case 8:
            fan.reserved3 = UInt(value) ?? 0
            
        case 9:
            fan.reserved4 = UInt(value) ?? 0
            
        case 10:
            fan.reserved5 = UInt(value) ?? 0
            
        default:
            break;
        }
       
        _ = SHSQLiteManager.shared.updateFan(fan)
    }
}
