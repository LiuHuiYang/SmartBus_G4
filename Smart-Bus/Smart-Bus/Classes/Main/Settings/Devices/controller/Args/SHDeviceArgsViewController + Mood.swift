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
        
        switch (index) {
            
        case 0:
            self.moodCommand?.deviceName = value
            
        case 1:
            self.moodCommand?.deviceType = UInt(value) ?? 0
            
        case 2:
            self.moodCommand?.subnetID = UInt8(value) ?? 0
            
        case 3:
            self.moodCommand?.deviceID = UInt8(value) ?? 0
            
        case 4:
            self.moodCommand?.parameter1 = UInt(value) ?? 0
            
        case 5:
            self.moodCommand?.parameter2 = UInt(value) ?? 0
            
        case 6:
            self.moodCommand?.parameter3 = UInt(value) ?? 0
            
        case 7:
            self.moodCommand?.parameter4 = UInt(value) ?? 0
            
        case 8:
            self.moodCommand?.parameter5 = UInt(value) ?? 0
            
        case 9:
            self.moodCommand?.parameter6 = UInt(value) ?? 0
            
        case 10:
            self.moodCommand?.delayMillisecondAfterSend = UInt(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.update(moodCommand)
    }
}

