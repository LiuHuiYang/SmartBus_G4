//
//  SHAudioOperatorTools + radio.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 收音机操作
extension SHAudioOperatorTools {
 
    /// 切换到指定频道的收音机
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - channelNumber: 频道号码
    static func changeRadio(
        subNetID: UInt8,
        deviceID: UInt8,
        channelNumber: UInt8) {
        
        let radioData: [UInt8] = [
            SHAudioControlType.albmOrRadioControl.rawValue,
            SHAudioAlbumOrRadioControlType.specifyRadioChannelNumber.rawValue,
            channelNumber,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0218,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: radioData,
            needReSend:false
        )
    }
    
    
    /// 播放上一个收音机的频道
    ///
    /// - Parameters:
    ///   - subNetID: subNetID 子网ID
    ///   - deviceID: deviceID 设备ID
    static func changePreviousRadioChannel(
        subNetID: UInt8,
        deviceID: UInt8) {
        
        let prevChannel: [UInt8] = [
            SHAudioControlType.albmOrRadioControl.rawValue,
            SHAudioAlbumOrRadioControlType.previousRadioChannel.rawValue,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0218,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: prevChannel,
            needReSend:false
        )
    }

    
    /// 播放下一个收音机的频道
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    static func changeNextRadioChannel(
        subNetID: UInt8,
        deviceID: UInt8) {
        
        let nextChannel: [UInt8] = [
            SHAudioControlType.albmOrRadioControl.rawValue,
            SHAudioAlbumOrRadioControlType.nextRadioChannel.rawValue,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0218,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: nextChannel,
            needReSend:false
        )
    }

}
