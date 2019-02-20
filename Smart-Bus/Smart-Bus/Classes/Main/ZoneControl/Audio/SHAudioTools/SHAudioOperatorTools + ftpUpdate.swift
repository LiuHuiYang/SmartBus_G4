//
//  SHAudioOperatorTools + ftpUpdate.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


// MARK: - FTP 数据更新
extension SHAudioOperatorTools {
    
    /// 更新音乐设备列表的FTP音乐数据
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    static func updateAudioFtpServerData(
        subNetID: UInt8,
        deviceID: UInt8) {
        
        let updateData: [UInt8] = [
            
            0x2A, // *
            0x53,// S
            0x32, // source // FTP
            0x55, // U
            0x50, // P
            0x44, // D
            0x41, // A
            0x54, // T
            0x45, // E
            0x4C, // L
            0x49, // I
            0x53, // S
            0x54, // T
            0x0D  // <CR>
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: updateData,
            needReSend:false
        )
        
    }
}
