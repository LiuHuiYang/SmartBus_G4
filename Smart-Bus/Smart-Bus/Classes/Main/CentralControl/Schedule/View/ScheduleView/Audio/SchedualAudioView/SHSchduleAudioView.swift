//
//  SHSchduleAudioView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/22.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit
 
class SHSchduleAudioView: UIView {

    /*
    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                return
            }
            
            if plan.isDifferentZoneSchedual ||
                (!plan.isDifferentZoneSchedual &&
                    allAudios.count == 0) {
             
                
                let commands =
                    SHSQLiteManager.shared.getSchedualCommands(
                        plan.scheduleID
                    )
                
                allAudios =
                    SHSQLiteManager.shared.getAudios(
                        plan.zoneID
                )
                
                for audio in allAudios {
                    
                    for command in commands {
                        
                        if command.typeID != SHSchdualControlItemType.audio.rawValue {
                            
                            continue
                        }
                        
                        if (audio.subnetID == command.parameter1) &&
                            (audio.deviceID == command.parameter2) {
                            
                            // 只要是存在的命令就一定是选中的
                            audio.schedualEnable = true
                            
                            audio.schedualVolumeRatio = UInt8(command.parameter3)
                            
                            audio.schedualSourceType = SHAudioSourceType(rawValue: (UInt8(command.parameter4 & 0xFF))) ?? .SDCARD
                            
                            audio.schedualPlayStatus = UInt8((command.parameter4 >> 8) & 0xFF)
                            
                            audio.schedualPlayAlbumNumber = UInt8(command.parameter5)
                            
                            audio.schedualPlaySongNumber = command.parameter6
                        }
                    }
                }
            }
             
            allAudioListView.reloadData()
        }
    }
 
    
    /// 保存数据
    @objc func saveAudio(_ notification: Notification?) {
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .audio {
            
            // 先删除以前的命令
            _ = SHSQLiteManager.shared.deleteSchedualeCommands(
                plan
            )
            
            for audio in allAudios {
                
                if audio.schedualEnable == false {
                    
                    continue
                }
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID =
                    SHSchdualControlItemType.audio.rawValue
                
                command.parameter1 = UInt(audio.subnetID)
                command.parameter2 = UInt(audio.deviceID)
                
                // 音量
                command.parameter3 =
                    UInt(audio.schedualVolumeRatio)
                
                // ((状态 & 0xFF) << 8 ) | (来源 & 0xFF)
                command.parameter4 =   UInt(((audio.schedualPlayStatus & 0xFF) << 8) |
                    (audio.schedualSourceType.rawValue & 0xFF))
                
                // 专辑号
                command.parameter5 =
                    UInt(audio.schedualAlbum?.albumNumber ?? 1)
                
                // 歌曲号
                command.parameter6 = audio.schedualAlbum?.currentSelectSong?.songNumber ?? 1
            
                _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
            }
        }
    }
 
 */
}


