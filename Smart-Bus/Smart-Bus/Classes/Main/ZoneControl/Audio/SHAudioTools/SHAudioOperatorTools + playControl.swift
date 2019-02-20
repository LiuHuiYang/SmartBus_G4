//
//  SHAudioOperatorTools + playControl.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 歌曲播放控制
extension SHAudioOperatorTools {
    
    /// 开始播放
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    static func playAudio(
        subNetID: UInt8,
        deviceID: UInt8) {
        
        let playData: [UInt8] = [
            
            SHAudioControlType.playControl.rawValue,
            SHAudioPlayControlType.play.rawValue
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0218,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: playData,
            needReSend:false
        )
    }
    
    
    /// 播放任意的音乐
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - sourceType: SDCard = 1, FTP = 2
    ///   - zoneFlag: 音乐区域标示，默认使用1
    static func playAudioAnySong(
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8,
        zoneFlag: UInt8
        ){
        
        let playData: [UInt8] = [
            
            0x2A, //*
            0x53, //S
            SHAudioOperatorTools.decimalToAscii(
                data: sourceType
            ),
            0x50, //P
            0x4C, //L
            0x41, //A
            0x59, //Y
            0x0D, // <CR>
            
            0x55,
            0xAA,
            zoneFlag
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0218,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: playData,
            needReSend:false
        )
    }
    
    /// 停止播放
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    static func stopAudio(
        subNetID: UInt8,
        deviceID: UInt8) {
        
        let stopData: [UInt8] = [
            
            SHAudioControlType.playControl.rawValue,
            SHAudioPlayControlType.stop.rawValue
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0218,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: stopData,
            needReSend:false
        )
    }
    
    static func stopAudioSong(
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8,
        zoneFlag: UInt8) {
        
        let stopData: [UInt8] = [
            0x2A, // *
            0x53, // S
            SHAudioOperatorTools.decimalToAscii(
                data: sourceType
            ),
            0x53, // S
            0x54, // T
            0x4F, // O
            0x50, // P
            0x0D, // CR
            
            0x55,
            0xAA,
            zoneFlag
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: stopData,
            needReSend:false
        )
    }
    
    
    /// 播放上一首
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - sourceType: 音乐来源
    ///   - zoneFlag: 区域标示，默认是1
    static func playAudioPreviousSong(
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8,
        zoneFlag: UInt8) {
        
        let prevSong:[UInt8] = [
            0x2A, //*
            0x53, //S
            SHAudioOperatorTools.decimalToAscii(data: sourceType),
            0x50, //P
            0x52, //R
            0x45, //E
            0x56, //V
            0x0D, // <CR>
            
            0x55,
            0xAA,
            zoneFlag
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: prevSong,
            needReSend:false
        )
    }
    
    /// 播放下一首
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - sourceType: 音乐来源
    ///   - zoneFlag: 区域标示，默认是1
    static func playAudioNextSong(
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8,
        zoneFlag: UInt8) {
        
        let nextSong:[UInt8] = [
            
            0x2A, // *
            0x53, // S
            SHAudioOperatorTools.decimalToAscii(data: sourceType),
            0x4E, // N
            0x45, // E
            0x58, // X
            0x54, // T
            0x0D, // <CR>
            
            0x55,
            0xAA,
            zoneFlag
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: nextSong,
            needReSend:false
        )
    }
    
    
    /// 指定播放音乐
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - sourceType: 音乐类型
    ///   - albumNumber: 音乐专辑号码
    ///   - songNumber: 音乐歌曲号码
    ///   - zoneFlag: 区域标示，默认使用1
    static func playAudioSelectSong(
        subNetID: UInt8,
        deviceID: UInt8,
        sourceType: UInt8,
        albumNumber: UInt8,
        songNumber: UInt,
        zoneFlag: UInt8
        ) {
        
        let albumH =
            SHAudioOperatorTools.decimalToAscii(
                data: albumNumber / 10
        )
        
        let albumL =
            SHAudioOperatorTools.decimalToAscii(
                data: albumNumber % 10
        )
        
        let songH =
            SHAudioOperatorTools.decimalToAscii(
                data: UInt8(songNumber / 100)
        )
        
        let songM =
            SHAudioOperatorTools.decimalToAscii(
                data: UInt8(songNumber % 100 / 10)
        )
        
        let songL =
            SHAudioOperatorTools.decimalToAscii(
                data: UInt8(songNumber % 10)
        )
        
        var playData = Array<UInt8>()
      
        playData.append(0x2A) // *
        playData.append(0x53) // S
        
        let type =
            SHAudioOperatorTools.decimalToAscii(
                data: sourceType
        )
        
        playData.append(type)
        
        // ====== 指定专辑 ======
        
        playData.append(0x4C) // L
        playData.append(0x49) // I
        playData.append(0x53) // S
        playData.append(0x54) // T
        
        if albumH == 0 {
            
            playData.append(albumL)
            
        } else {
            
            playData.append(albumH)
            playData.append(albumL)
        }
        
        // ====== 指定歌曲 ========
        
        playData.append(0x2C) // ,
        playData.append(0x53) // S
        playData.append(0x4F) // O
        playData.append(0x4E) // N
        playData.append(0x47) // G
        
        if songNumber < 10 {
            
            playData.append(songL)
            
        } else if songNumber >= 10 && songNumber < 100 {
            
            playData.append(songM)
            playData.append(songL)
            
        } else if songNumber >= 100 {
            
            playData.append(songH)
            playData.append(songM)
            playData.append(songL)
        }
        
        playData.append(0x0D) // 0x0D
        playData.append(0x55)
        playData.append(0xAA)
        playData.append(zoneFlag)
        
        SHSocketTools.sendData(
            operatorCode: 0x192E,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: playData,
            needReSend:false
        )
    }
    
    /// 切换音乐来源
    ///
    /// - Parameters:
    ///   - subNetID: 子网ID
    ///   - deviceID: 设备ID
    ///   - musicSoureNumber: 音乐来源编号 1-SD,2-Audioin, 3-FTP, 4-Radio
    ///   - zoneFlag: 区域标示，默认是1
    static func changeAudioSource(
        subNetID: UInt8,
        deviceID: UInt8,
        musicSoureNumber: UInt8,
        zoneFlag: UInt8) {
        
        let sourceData = [
            
            SHAudioControlType.musicSource.rawValue,
            musicSoureNumber
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0218,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: sourceData,
            needReSend:false
        )
    }

}
