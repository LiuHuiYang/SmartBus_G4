//
//  SHDeviceArgsViewController + Dmx.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
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
        
        SHSQLManager.share()?.update(dmxGroup)
    }
    
    /// 保存dmx通道
    func updateDmxChannel(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.dmxChannel?.remark = value;
            
        case 1:
            self.dmxChannel?.channelType =
                SHDmxChannelType(rawValue: UInt(value) ?? 0) ?? .none
            
        case 2:
            self.dmxChannel?.subnetID = UInt8(value) ?? 1
            
        case 3:
            self.dmxChannel?.deviceID = UInt8(value) ?? 0
            
        case 4:
            self.dmxChannel?.channelNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.update(dmxChannel)
    }
}

