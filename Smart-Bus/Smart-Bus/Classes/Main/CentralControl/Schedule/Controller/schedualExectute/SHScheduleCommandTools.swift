//
//  SHScheduleCommandTools.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/14.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// 计划工具类
@objcMembers class SHScheduleCommandTools: NSObject {
    
    
    /// 执行计划命令
    ///
    /// - Parameter schdule: 需要被执行的计划
    static func executeSchdule(_ schdule: SHSchedual) {
        
        /// 子线程中执行
        DispatchQueue.global().async {
            
            if schdule.haveSound {
                
                SoundTools.share()?.playSound(
                    withName: "schedulesound.wav"
                )
            }
            
            // 查询需要的命令
            guard let schedualCommands =
                SHSQLManager.share()?.getSchedualCommands(
                    schdule.scheduleID
                    ) as? [SHSchedualCommand] else {
                        
                        return
            }
            
            for command in schedualCommands {
                
                switch command.typeID {
                    
                case SHSchdualControlItemType.marco.rawValue :
                    
                    exectuSchedualMacro(command)
                    
                case SHSchdualControlItemType.mood.rawValue:
                    
                    exectuSchedualMood(command)
                    
                case SHSchdualControlItemType.light.rawValue:
                    
                    exectuSchedualLight(command)
                    
                case SHSchdualControlItemType.HVAC.rawValue :
                    exectuSchedualHVAC(command)
                    
                case SHSchdualControlItemType.floorHeating.rawValue :
                    
                    exectuSchedualFloorHeating(command)
                    
                case SHSchdualControlItemType.shade.rawValue:
                    exectuSchedualShade(command)
                    
                case SHSchdualControlItemType.audio.rawValue:
                    exectuSchedualAudio(command)
                    
                    
                default:
                    break
                }
            }
        }
    }
}


// MARK: - 执行各项子命令
extension SHScheduleCommandTools {
    
    
    /// 执行音乐
    ///
    /// - Parameter command: 音乐命令
    static func exectuSchedualAudio(_ command: SHSchedualCommand) {
        
        let subNetID = UInt8(command.parameter1)
        let deviceID = UInt8(command.parameter2)
        let sourceType =
            (UInt8(command.parameter4 & 0xFF))
        let zoneFlag: UInt8 = 1
        
        // 1.控制声音
        let volume =
            UInt8(
                (1.0 - Double(command.parameter3) * 0.01) * Double(SHAUDIO_MAX_VOLUME)
        )
        
        SHAudioOperatorTools.changeAudioVolume(
            subNetID: subNetID,
            deviceID: deviceID,
            volume: volume,
            zoneFlag: zoneFlag
        )
        
        // 2.切换音源来源
        SHAudioOperatorTools.changeAudioSource(
            subNetID: subNetID,
            deviceID: deviceID,
            musicSoureNumber: sourceType,
            zoneFlag: zoneFlag
        )
        
        // 3.指定歌曲
        SHAudioOperatorTools.playAudioSelectSong(
            subNetID: subNetID,
            deviceID: deviceID,
            sourceType: sourceType,
            albumNumber:
            (UInt8(command.parameter5 & 0xFF)),
            songNumber: command.parameter6,
            zoneFlag: zoneFlag
        )
        
        // 设置播放状态
        if UInt8((command.parameter4 >> 8) & 0xFF) == SHAudioPlayControlType.play.rawValue {
            
            SHAudioOperatorTools.playAudioAnySong(
                subNetID: subNetID,
                deviceID: deviceID,
                sourceType: sourceType,
                zoneFlag: zoneFlag
            )
            
        } else {
            
            SHAudioOperatorTools.stopAudioSong(
                subNetID: subNetID,
                deviceID: deviceID,
                sourceType: sourceType,
                zoneFlag: zoneFlag
            )
        }
    }
    
    /// 执行窗帘
    ///
    /// - Parameter command: 窗帘指令
    static func exectuSchedualShade(_ command: SHSchedualCommand) {
        
        // 状态忽略，不管
        if command.parameter3 == SHShadeStatus.unKnow.rawValue {
            
            return
        }
        
        guard let shade =
            SHSQLManager.share()?.getShadeFor(
                command.parameter2,
                shadeID: command.parameter1
            ) else {
                
                return
        }
        
        var controlChanel: UInt8 = 0
        
        if command.parameter3 == SHShadeStatus.close.rawValue {
            
            controlChanel = shade.closeChannel
            
        } else if command.parameter3 == SHShadeStatus.open.rawValue {
            
            controlChanel = shade.openChannel
        }
        
        let G4Curtain = [
            controlChanel,
            100,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0031,
            subNetID: shade.subnetID,
            deviceID: shade.deviceID,
            additionalData: G4Curtain
        )
        
        let G3Curtain = [
            controlChanel,
            100
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3E0,
            subNetID: shade.subnetID,
            deviceID: shade.deviceID,
            additionalData: G3Curtain
        )
    }
    
    /// 执行地热
    ///
    /// - Parameter command: 命令
    static func exectuSchedualFloorHeating(_ command: SHSchedualCommand) {
        
        let subNetID = UInt8(command.parameter1)
        let deviceID = UInt8(command.parameter2)
        let channelNO = UInt8(command.parameter3)
        
        // 1.设置开关
        let onOffData = [
            SHFloorHeatingControlType.onAndOff.rawValue,
            UInt8(command.parameter4),
            channelNO
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: onOffData
        )
        
        // 2.设置模式
        let modelData = [
            SHFloorHeatingControlType.modelSet.rawValue,
            UInt8(command.parameter5),
            channelNO
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: modelData
        )
        
        // 3.如果模式是手动，则设置手动模式温度
        if command.parameter5 == SHFloorHeatingModeType.manual.rawValue {
            
            let temperatureData = [
                
                SHFloorHeatingControlType.temperatureSet.rawValue,
                UInt8(command.parameter6),
                channelNO
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0xE3D8,
                subNetID: subNetID,
                deviceID: deviceID,
                additionalData: temperatureData
            )
        }
    }
    
    
    /// 执行HVAC
    ///
    /// - Parameter command: 命令
    static func exectuSchedualHVAC(_ command: SHSchedualCommand) {
        
        let subNetID = UInt8(command.parameter1)
        let deviceID = UInt8(command.parameter2)
        
        // 1.设置开关
        let onOffData = [
            SHAirConditioningControlType.onAndOff.rawValue,
            UInt8(command.parameter3)
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: onOffData
        )
        
        
        // 2.设置风速
        let fanData = [
            SHAirConditioningControlType.fanSpeedSet.rawValue,
            
            UInt8(command.parameter4)
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: fanData
        )
        
        // 3.设置模式
        let modelData = [
            SHAirConditioningControlType.acModeSet.rawValue,
            UInt8(command.parameter5)
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: modelData
        )
        
        // 4.设置模式温度
        
        var model: UInt8 = 0
        
        if command.parameter5 == SHAirConditioningModeType.heat.rawValue {
            
            model =
                SHAirConditioningModeType.heat.rawValue
            
        } else if command.parameter5 == SHAirConditioningModeType.auto.rawValue {
            
            model =
                SHAirConditioningModeType.auto.rawValue
            
        } else {
            
            model =
                SHAirConditioningModeType.cool.rawValue
        }
        
        let temperatureData = [
            
            model,
            UInt8(command.parameter6)
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0xE3D8,
            subNetID: subNetID,
            deviceID: deviceID,
            additionalData: temperatureData
        )
    }
    
    /// 执行light
    ///
    /// - Parameter command: light命令
    static func exectuSchedualLight(_ command: SHSchedualCommand) {
        
        guard let light =
            SHSQLManager.share()?.getLightFor(
                command.parameter2,
                lightID: command.parameter1
            ) else {
                
                return
        }
        
        if light.lightTypeID == .led {
            
            let ledData = [
                UInt8(command.parameter3),
                UInt8(command.parameter4),
                UInt8(command.parameter5),
                0,
                0,
                0
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0xF080,
                subNetID: light.subnetID,
                deviceID: light.deviceID,
                additionalData: ledData
            )
            
        } else {
            
            let lightData = [
                light.channelNo,
                UInt8(command.parameter3),
                0,
                0
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: light.subnetID,
                deviceID: light.deviceID,
                additionalData: lightData
            )
        }
    }
    
    
    /// 执行mood
    ///
    /// - Parameter command: 命令
    static func exectuSchedualMood(_ command: SHSchedualCommand) {
        
        let mood = SHMood()
        mood.moodID = command.parameter1
        mood.zoneID = command.parameter2
        
        guard let moodCommands =
            SHSQLManager.share()?.getAllMoodCommands(
                for: mood
                ) as? [SHMoodCommand] else {
                    
                    return
        }
        
        for moodCommand in moodCommands {
            
            SHSocketTools.executeMoodCommand(
                moodCommand
            )
        }
    }
    
    
    /// 执行macro
    ///
    /// - Parameter command: 命令
    static func exectuSchedualMacro(_ command: SHSchedualCommand) {
        
        let macro = SHMacro()
        
        macro.macroID = command.parameter1
        
        guard let macros = SHSQLManager.share()?.getCentralMacroCommands(
            macro) as? [SHMacroCommand] else {
                
                return
        }
        
        for command in macros {
            
            SHSocketTools.executeMacroCommand(command)
            
            Thread.sleep(forTimeInterval: TimeInterval(
                command.delayMillisecondAfterSend
                )/1000.0
            )
        }
    }
}
