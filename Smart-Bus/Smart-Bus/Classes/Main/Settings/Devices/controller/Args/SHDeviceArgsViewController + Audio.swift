//
//  SHDeviceArgsViewController + Audio.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
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
        
        switch (index) {
            
        case 0:
            self.audio?.audioName = value
            
        case 1:
            self.audio?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.audio?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.audio?.haveSdCard = UInt8(value) ?? 0
            
        case 4:
            self.audio?.haveFtp = UInt8(value) ?? 0
            
        case 5:
            self.audio?.haveRadio = UInt8(value) ?? 0
            
        case 6:
            self.audio?.haveAudioIn = UInt8(value) ?? 0
            
        case 7:
            self.audio?.havePhone = UInt8(value) ?? 0
            
        case 8:
            self.audio?.haveUdisk = UInt8(value) ?? 0
            
        case 9:
            self.audio?.haveBluetooth = UInt8(value) ?? 0
            
        case 10:
            self.audio?.isMiniZAudio = UInt8(value) ?? 0
            
        default:
            break
        }
        
        SHSQLManager.share()?.updateAudio(inZone: audio)
    }
}
