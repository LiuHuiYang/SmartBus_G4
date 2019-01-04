//
//  SHAudioOperatorTools + VOL.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 声音控制
extension SHAudioOperatorTools {
    
    
    /// 调整音乐设备的音量
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - volume: 音量大小
    ///   - zoneFlag: 区域标示 默认是1
    static func changeAudioVolume(
        subNetID: UInt8,
        deviceID: UInt8,
        volume: UInt8,
        zoneFlag: UInt8) {
        
        let volH = SHAudioOperatorTools.decimalToAscii(
            data: volume / 10
        )
        let volL = SHAudioOperatorTools.decimalToAscii(
            data: volume % 10
        )
        
        var volData: [UInt8] = Array<UInt8>()
        
        volData.append(0x2A) //*
        volData.append(0x5A) // Z
        volData.append(0x31) // source: sd=1
        volData.append(0x56) // V
        volData.append(0x4F) // O
        volData.append(0x4C) // L
        
        if volume >= 10 {
            
            volData.append(volH)
            volData.append(volL)
        
        } else {
        
            volData.append(volL)
        }
        
        volData.append(0x0D) // <CR>
        
        volData.append(0x55)
        volData.append(0xAA)
        volData.append(zoneFlag)
 
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: volData,
            needReSend:false
        )
    }

   
    /// 设置音乐的高音
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - changeType: + 或者 -
    ///   - zoneFlag: 区域标示 默认是1
    static func changeAudioTreble(
        subNetID: UInt8,
        deviceID: UInt8,
        changeType: SHAudioVolumeControlChangeType,
        zoneFlag: UInt8) {

        // + 或 -
        let value: UInt8 =
            changeType == .increase ? 0x2B : 0x2D
        
        let volData: [UInt8] = [
            0x2A, // *
            0x5A, // Z
            0x31, // 源号 1
            0x54, // T
            0x52, // R
            0x45, // E
            0x42, // B
            0x4C, // L
            0x45, // E
            value,// + / -
            0x0D, // <CR>
            
            0x55,
            0xAA,
            zoneFlag
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: volData,
            needReSend: false
        )
    }

    /// 设置音乐的低音
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - changeType: + 或者 -
    ///   - zoneFlag: 区域标示 默认是1
    static func changeAudioBass(
        subNetID: UInt8,
        deviceID: UInt8,
        changeType: SHAudioVolumeControlChangeType,
        zoneFlag: UInt8) {
        
        // + 或 -
        let value: UInt8 =
            changeType == .increase ? 0x2B : 0x2D
        
        let volData: [UInt8] = [
            0x2A, // *
            0x5A, // Z
            0x31, // 源号 1
            0x42, // B
            0x41, // A
            0x53, // S
            0x53, // S
            value, // + / -
            0x0D, // <CR>
        
            0x55,
            0xAA,
            zoneFlag
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: volData,
            needReSend: false
        )
    }

  
    
    /// 读取当前音乐的高音与低音状态
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - zoneFlag: 区域标示 默认是1
    static func readAudioTrebleAndBass(
        subNetID: UInt8,
        deviceID: UInt8,
        zoneFlag: UInt8
    ) {
        
        let statusData: [UInt8] = [
            0x2A, // *
            0x5A, // Z
            0x31, // 1,2,3都是一样的 音乐来源
            0x54, // T
            0x4F, // O
            0x4E, // N
            0x45, // E
            0x3F, // ?
            0x0D  // <CR>
        ];
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: statusData,
            needReSend: false
        )
    }

}
