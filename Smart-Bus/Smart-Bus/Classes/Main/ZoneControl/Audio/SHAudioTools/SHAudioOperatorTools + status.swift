//
//  SHAudioOperatorTools + status.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 读取音乐状态
extension SHAudioOperatorTools {
    
    
    /// 读取音乐设备的信息
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    static func readAudioStatus(
        subNetID: UInt8,
        deviceID: UInt8) {
        
        // 读状态会分别返回多次信息, 每次都是0X192F
        
        let statusData: [UInt8] = [
            0x2A,
            0x5A,
            0x31,
            0x53,
            0x54,
            0x41,
            0x54,
            0x55,
            0x53,
            0x3F,
            0x0D
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: statusData
        )
        
        Thread.sleep(forTimeInterval: 0.3)
    }
}
