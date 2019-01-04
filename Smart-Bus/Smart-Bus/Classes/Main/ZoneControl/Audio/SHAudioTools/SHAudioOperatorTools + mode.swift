//
//  SHAudioOperatorTools + MODE.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 模式
extension SHAudioOperatorTools {
    
  
    /**
     切换音乐设备的播放模式
     
     @param subNetID 子网ID
     @param deviceID 设备ID
     @param playMode 设定的播放模式
     */
    static func changeAudioplayModel(
        subNetID: UInt8,
        deviceID: UInt8,
        playMode: SHAudioPlayModeType) {
        
        let isRepeatAll = playMode == .repeatAllAlbum
        
        // - / +
        let flag: UInt8 = isRepeatAll ? 0x2D : 0x2B;
        
        var count = isRepeatAll ? 3 : 1
        
        let modelData: [UInt8] = [
            0x2A, // *
            0x53, // S
            0x31, // source: sd=1
            0x4D, // M
            0x4F, // O
            0x44, // D
            0x45, // E
            flag, // - // +
            0x0D  // <CR>
        ]
        
        while count != 0 {
            
            SHSocketTools.sendData(
                operatorCode: 0x192E,
                subNetID: subNetID,
                deviceID: deviceID,
                additionalData: modelData,
                needReSend:false
            )
            
            count -= 1
        }
    }

    
    /// 读取当前音乐的模式
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    static func readAudioModel(subNetID: UInt8,
                               deviceID: UInt8) {
        
        // *SsPLAYMODE?<CR>
        
        let modelStatus: [UInt8] = [
            0x2A,
            0x53,
            0x31,
            0x50,
            0x4C,
            0x41,
            0x59,
            0x4D,
            0x4F,
            0x44,
            0x45,
            0x3F,
            0x0D
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: modelStatus,
            needReSend:false
        )
    }

}
