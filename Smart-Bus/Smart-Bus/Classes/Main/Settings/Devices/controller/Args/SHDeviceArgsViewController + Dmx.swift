//
//  SHDeviceArgsViewController + Dmx.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - DmxChannel
extension SHDeviceArgsViewController {
    
    /// 刷新dmxGroup
    func refreshDmxGroup() {
        
        argsNames = [
            "Group Name"
        ]
        
        argsValues = [
            dmxGroup?.groupName ?? "dmx group"
        ]
    }
    
    /// 刷新dmxChannel
    func refreshDmxChannel() {
        
        argsNames = [
            "channel Name",
            "channel Type",
            "Subnet ID",
            "Device ID",
            "Chanel NO."
        ]
        
        argsValues = [
            dmxChannel?.remark ?? "dmx channel",
            "\((dmxChannel?.channelType ?? .none).rawValue)",
            "\(dmxChannel?.subnetID ?? 0)",
            "\(dmxChannel?.deviceID ?? 0)",
            "\(dmxChannel?.channelNo ?? 0)"
        ]
    }
    
    /// 保存dmx Group
    func updateDmxGroup(value: String, index: Int) {
        
        switch index {
            
        case 0:
            self.dmxGroup?.groupName = value
            
        default:
            break
        }
        
        if self.dmxGroup != nil {
        
            _ = SHSQLiteManager.shared.updateDmxGroup(
                self.dmxGroup!
            )
        }
    }
    
    /// 保存dmx通道
    func updateDmxChannel(value: String, index: Int) {
        
        guard let channel = self.dmxChannel else {
            return
        }
        
        switch (index) {
            
        case 0:
            channel.remark = value;
            
        case 1:
            channel.channelType =
                SHDmxChannelType(rawValue: UInt(value) ?? 0) ?? .none
            
        case 2:
            channel.subnetID = UInt8(value) ?? 1
            
        case 3:
            channel.deviceID = UInt8(value) ?? 0
            
        case 4:
            channel.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        } 
        
        _ = SHSQLiteManager.shared.updateDmxChannel(channel)
    }
}

