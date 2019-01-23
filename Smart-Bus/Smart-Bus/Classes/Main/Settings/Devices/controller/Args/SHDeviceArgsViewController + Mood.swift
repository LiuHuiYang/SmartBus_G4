//
//  SHDeviceArgsViewController + Mood.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - MoodCommand
extension SHDeviceArgsViewController {
    
    /// 更新
    func refreshMooCommand() {
        
        argsNames = [
            "Device Name",
            "Device Type",
            "Subnet ID",
            "Device ID",
            "Parameter1",
            "Parameter2",
            "Parameter3",
            "Parameter4",
            "Parameter5",
            "Parameter6",
            "DelayMillisecondAfterSend"
        ]
        
        argsValues = [
            moodCommand?.deviceName ?? "mood Command",
            "\(moodCommand?.deviceType ?? 0)",
            "\(moodCommand?.subnetID ?? 0)",
            "\(moodCommand?.deviceID ?? 0)",
            "\(moodCommand?.parameter1 ?? 0)",
            "\(moodCommand?.parameter2 ?? 0)",
            "\(moodCommand?.parameter3 ?? 0)",
            "\(moodCommand?.parameter4 ?? 0)",
            "\(moodCommand?.parameter5 ?? 0)",
            "\(moodCommand?.parameter6 ?? 0)",
            "\(moodCommand?.delayMillisecondAfterSend ?? 0)",
        ]
    }
    
    /// 保存
    func updateMoodCommand(value: String, index: Int) {
        
        guard let command = self.moodCommand else {
            return
        }
        
        switch (index) {
            
        case 0:
            command.deviceName = value
            
        case 1:
            command.deviceType = UInt(value) ?? 0
            
        case 2:
            command.subnetID = UInt8(value) ?? 0
            
        case 3:
            command.deviceID = UInt8(value) ?? 0
            
        case 4:
            command.parameter1 = UInt(value) ?? 0
            
        case 5:
            command.parameter2 = UInt(value) ?? 0
            
        case 6:
            command.parameter3 = UInt(value) ?? 0
            
        case 7:
            command.parameter4 = UInt(value) ?? 0
            
        case 8:
            command.parameter5 = UInt(value) ?? 0
            
        case 9:
            command.parameter6 = UInt(value) ?? 0
            
        case 10:
            command.delayMillisecondAfterSend =
                UInt(value) ?? 0
            
        default:
            break;
        }
        
        _ = SHSQLiteManager.shared.updateMoodCommand(command)
        
    }
}

