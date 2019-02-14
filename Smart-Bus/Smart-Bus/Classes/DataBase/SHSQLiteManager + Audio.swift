//
//  SHSQLiteManager + Audio.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/22.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Audio的操作
extension SHSQLiteManager {
    
    /// 增加 Audio
    func insertAudio(_ audio: SHAudio) -> UInt {
        
        let sql =
            "insert into ZaudioInZone (ZoneID, "         +
            "SubnetID, DeviceID, haveSdCard, haveFtp, "  +
            "haveRadio, haveAudioIn, havePhone, "        +
            "haveUdisk, haveBluetooth, isMiniZAudio,"    +
            "audioName) values (\(audio.zoneID), "       +
            "\(audio.subnetID), \(audio.deviceID), "     +
            "\(audio.haveSdCard), \(audio.haveFtp), "    +
            "\(audio.haveRadio), \(audio.haveAudioIn), " +
            "\(audio.havePhone), \(audio.haveUdisk), "   +
            "\(audio.haveBluetooth), "                   +
            "\(audio.isMiniZAudio), "                    +
            "'\(audio.audioName)');"
        
        _ = executeSql(sql)
        
        let idSQL = "select max(ID) from ZaudioInZone;"
        
        guard let dict = selectProprty(idSQL).last,
            let id = dict["max(ID)"] as? UInt else {
            return 0
        }
        
        return id
    }
    
    /// 更析 Audio
    func updateAudio(_ audio: SHAudio) -> Bool {
        
        let sql =
            "update ZaudioInZone set "                 +
            "SubnetID = \(audio.subnetID), "           +
            "DeviceID = \(audio.deviceID), "           +
            "haveSdCard = \(audio.haveSdCard), "       +
            "haveFtp = \(audio.haveFtp), "             +
            "haveRadio = \(audio.haveRadio), "         +
            "haveAudioIn = \(audio.haveAudioIn), "     +
            "havePhone = \(audio.havePhone), "         +
            "haveUdisk = \(audio.haveUdisk), "         +
            "haveBluetooth = \(audio.haveBluetooth), " +
            "isMiniZAudio = \(audio.isMiniZAudio), "   +
            "audioName = '\(audio.audioName)' "        +
            "Where zoneID = \(audio.zoneID) and "      +
            "id = \(audio.id);"
        
        return executeSql(sql)
    }
    
    /// 删除区域中的Audio
    func deleteAudios(_ zoneID: UInt) -> Bool {
        
        let sql =
            "delete from ZaudioInZone Where " +
            "zoneID = \(zoneID);"
        
        return executeSql(sql)
    }
    
    /// 删除 audio
    func deleteAudio(_ audio: SHAudio) -> Bool {
        
        let sql =
            "delete from ZaudioInZone   Where " +
            "zoneID = \(audio.zoneID)     and " +
            "SubnetID = \(audio.subnetID) and " +
            "DeviceID = \(audio.deviceID) ;"
        
        return executeSql(sql)
    }
    
    /// 获得指定区域中的Audio
    func getAudios(_ zoneID: UInt) -> [SHAudio] {
        
        let audios = getAllAudios()
        
        var needAudios = [SHAudio]()
        
        for audio in audios {
            
            if audio.zoneID == zoneID {
                
                needAudios.append(audio)
            }
        }
        
        return needAudios
    }
    
    /// 当前应用中的所有Audio
    func getAllAudios() -> [SHAudio] {
        
        let sql =
            "select ID, ZoneID, SubnetID, DeviceID, " +
            "haveSdCard, haveFtp, haveRadio, "        +
            "haveAudioIn, havePhone, haveUdisk, "     +
            "haveBluetooth, isMiniZAudio, audioName " +
            "from ZaudioInZone order by ID;"
        
        let array = selectProprty(sql)
        
        var audios = [SHAudio]()
        
        for dict in array {
            
            audios.append(SHAudio(dictionary: dict))
        }
        
        return audios
    }
    
    /// 增加音乐的参数
    func addAudioParameter() {
        
        // 增加一个音乐设备名称的字段
        if isColumnName(
            "audioName",
            consistinTable: "ZaudioInZone"
            ) == false {
            
            _ = executeSql(
                "ALTER TABLE ZaudioInZone ADD audioName TEXT NOT NULL DEFAULT 'audio';"
            )
        }
        
        // 增加风个音源
        if isColumnName(
            "haveSdCard",
            consistinTable: "ZaudioInZone"
            ) == false {
            
            // SDCard
            _ = executeSql(
                "ALTER TABLE ZaudioInZone ADD haveSdCard INTEGER NOT NULL DEFAULT 1;"
            )
            
            // FTP
            _ = executeSql(
                "ALTER TABLE ZaudioInZone ADD haveFtp INTEGER NOT NULL DEFAULT 0;"
            )
            
            // Radio
            _ = executeSql(
                "ALTER TABLE ZaudioInZone ADD haveRadio INTEGER NOT NULL DEFAULT 0;"
            )
            
            // AudioIN
            _ = executeSql("ALTER TABLE ZaudioInZone ADD haveAudioIn INTEGER NOT NULL DEFAULT 0;"
            )
            
            // Phone
            _ = executeSql(
                "ALTER TABLE ZaudioInZone ADD havePhone INTEGER NOT NULL DEFAULT 0;"
            )
        }
        
        // miniAudio
        if isColumnName(
            "haveUdisk",
            consistinTable: "ZaudioInZone"
            ) == false {
            
            // U盘
            _ = executeSql(
                "ALTER TABLE ZaudioInZone ADD haveUdisk INTEGER NOT NULL DEFAULT 0;"
            )
            
            // 蓝牙
            _ = executeSql(
                "ALTER TABLE ZaudioInZone ADD haveBluetooth INTEGER NOT NULL DEFAULT 0;"
            )
           
        }
        
        // 判断是否 mini Audio
        if isColumnName(
            "isMiniZAudio",
            consistinTable: "ZaudioInZone"
            ) == false {
            
            _ = executeSql(
                "ALTER TABLE ZaudioInZone ADD isMiniZAudio INTEGER NOT NULL DEFAULT 0;"
            )
        }
        
    }
}
