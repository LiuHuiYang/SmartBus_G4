//
//  SHDeviceArgsViewController + Audio.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - Audio
extension SHDeviceArgsViewController {
    
    /// 刷新音乐数据
    func refreshAudio() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "SDCard",
            "FTP",
            "Radio",
            "Audio In",
            "Phone",
            "Udisk",
            "Bluetooth",
            "isMiniZAudio"
        ]
        
        argsValues = [
            audio?.audioName ?? "audio",
            "\(audio?.subnetID ?? 1)",
            "\(audio?.deviceID ?? 0)",
            
            "\(audio?.haveSdCard ?? 0)",
            "\(audio?.haveFtp ?? 0)",
            "\(audio?.haveRadio ?? 0)",
            "\(audio?.haveAudioIn ?? 0)",
            "\(audio?.havePhone ?? 0)",
            "\(audio?.haveUdisk ?? 0)",
            "\(audio?.haveBluetooth ?? 0)",
            "\(audio?.isMiniZAudio ?? 0)",
        ]
    }
    
    
    func updateAudio(value: String, index: Int) {
        
        guard let music = self.audio else {
            return
        }
        
        switch (index) {
            
        case 0:
            music.audioName = value
            
        case 1:
            music.subnetID = UInt8(value) ?? 1
            
        case 2:
            music.deviceID = UInt8(value) ?? 0
            
        case 3:
            music.haveSdCard = UInt8(value) ?? 0
            
        case 4:
            music.haveFtp = UInt8(value) ?? 0
            
        case 5:
            music.haveRadio = UInt8(value) ?? 0
            
        case 6:
            music.haveAudioIn = UInt8(value) ?? 0
            
        case 7:
            music.havePhone = UInt8(value) ?? 0
            
        case 8:
            music.haveUdisk = UInt8(value) ?? 0
            
        case 9:
            music.haveBluetooth = UInt8(value) ?? 0
            
        case 10:
            music.isMiniZAudio = UInt8(value) ?? 0
            
        default:
            break
        }
         
        _ = SHSQLiteManager.shared.updateAudio(music)
    }
}
