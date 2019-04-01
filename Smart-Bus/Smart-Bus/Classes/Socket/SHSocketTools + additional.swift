//
//  SHSocketTools + additional.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017 SmartHome. All rights reserved.
//

import Foundation


// MARK: - 执行Mood指令
extension SHSocketTools {
     
    /// 执行每条Mood指令
    ///
    /// - Parameter command: mood中的每一条指令
    static func executeMoodCommand(_ command: SHMoodCommand) {
        
        var operatorCode: UInt16 = 0
        var controlData:[UInt8] = [UInt8]()
        
        // 1.新的执行模式
        if command.parameter6 == 0 &&
            command.deviceType != 0 {
            
            switch command.deviceType {
                
            case SHSystemDeviceType.light.rawValue:
                
                // LED
                if command.parameter1 == SHZoneControlLightType.led.rawValue {
                    
                    operatorCode = 0xF080
                    controlData = [
                        UInt8(command.parameter2),
                        UInt8(command.parameter3),
                        UInt8(command.parameter4),
                        0,
                        0,
                        0
                    ]
                    
                } else {
                    
                    operatorCode = 0x0031
                    controlData = [
                        UInt8(command.parameter2),
                        UInt8(command.parameter3),
                        UInt8(command.parameter4 >> 8),
                        UInt8(command.parameter4 & 0xFF)
                    ]
                }
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
            case SHSystemDeviceType.hvac.rawValue:
                
                operatorCode = 0xE3D8
                
                // 1.设置开关
                controlData = [
                    UInt8(SHAirConditioningControlType.onAndOff.rawValue),
                    UInt8(command.parameter1),
                ]
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
                // 2.设置风速
                controlData = [
                    UInt8(Float(SHAirConditioningControlType.fanSpeedSet.rawValue)),
                    UInt8(command.parameter2),
                ]
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
                // 设置工作模式
                controlData = [
                    UInt8(Float(SHAirConditioningControlType.acModeSet.rawValue)),
                    UInt8(command.parameter3),
                ]
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
                // 设置模式温度
                if command.parameter3 == SHAirConditioningModeType.heat.rawValue {
                    
                    controlData[0] = UInt8(SHAirConditioningControlType.heatTemperatureSet.rawValue)
                    
                } else if command.parameter3 == SHAirConditioningModeType.auto.rawValue {
                    
                    controlData[0] = UInt8(SHAirConditioningControlType.autoTemperatureSet.rawValue)
                    
                } else {
                    
                    controlData[0] = UInt8(SHAirConditioningControlType.coolTemperatureSet.rawValue)
                }
                
                controlData[1] = UInt8(command.parameter4)
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
            case SHSystemDeviceType.shade.rawValue:
                
                operatorCode = 0x0031
                
                let channel = (command.parameter1 == SHShadeStatus.close.rawValue) ? command.parameter3 : command.parameter2
                
                controlData = [
                    UInt8(channel),
                    100,
                    0,
                    0
                ]
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
                // 兼容3代
                controlData = [
                    UInt8(channel),
                    100
                ]
                
                SHSocketTools.sendData(
                    operatorCode: 0xE3E0,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
            case SHSystemDeviceType.audio.rawValue:
                
                // 调置声音
                   SHAudioOperatorTools.changeAudioVolume(
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    volume: UInt8(UInt(SHAUDIO_MAX_VOLUME) - command.parameter1),
                    zoneFlag: 1
                   )
                
                // 切换来源
                   SHAudioOperatorTools.changeAudioSource(
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    musicSoureNumber: UInt8(command.parameter2),
                    zoneFlag: 1
                   )
                
                // 选择专辑
               SHAudioOperatorTools.playAudioSelectSong(
                subNetID: command.subnetID,
                deviceID: command.deviceID,
                sourceType: UInt8(command.parameter2),
                albumNumber: UInt8(command.parameter3),
                songNumber: command.parameter4,
                zoneFlag: 1
              )
                
                // 设置播放状态
                if command.parameter5 == SHAudioPlayControlType.play.rawValue {
                      SHAudioOperatorTools.playAudioAnySong(
                        subNetID: command.subnetID,
                        deviceID: command.deviceID,
                        sourceType: UInt8(command.parameter2),
                        zoneFlag: 1
                    )
                    
                } else {
                    SHAudioOperatorTools.stopAudioSong(
                        subNetID: command.subnetID,
                        deviceID: command.deviceID,
                        sourceType: UInt8(command.parameter2),
                        zoneFlag: 1
                    )
                }
                
            case SHSystemDeviceType.floorHeating.rawValue:
                
                operatorCode = 0xE3D8
                
                // 设置开与关
                controlData = [
                    SHFloorHeatingControlType.onAndOff.rawValue,
                    UInt8(command.parameter2),
                    UInt8(command.parameter1)
                ]
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
                // 设置模式
                controlData = [
                    SHFloorHeatingControlType.modelSet.rawValue,
                    UInt8(command.parameter3),
                    UInt8(command.parameter1)
                ]
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
                // 设置手动模式温度
                controlData = [
                    SHFloorHeatingControlType.temperatureSet.rawValue,
                    UInt8(command.parameter4),
                    UInt8(command.parameter1)
                ]
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
            default:
                break
            }
            
            // 兼容以前旧的App的配置方式
        } else {
            
            // 必须是0才工作
            if command.deviceType == 0 {
                
                let operatorCode: UInt16 =
                    SHSocketTools.getOperatorCode(
                        command.parameter6
                )
                
                var controlData: [UInt8] = [UInt8]()
                
                // 音乐
                if operatorCode == 0x0218 {
                    
                    switch UInt8(command.parameter1) {
                        
                    case SHAudioControlType.musicSource.rawValue:
                        controlData = [
                            1,
                            UInt8(command.parameter1)
                        ]
                        
                    case SHAudioControlType.playModeChanging.rawValue:
                        
                        controlData = [
                            2,
                            UInt8(command.parameter1)
                        ]
                        
                    case SHAudioControlType.albmOrRadioControl.rawValue:
                        
                        controlData = [
                            UInt8(command.parameter1),
                            UInt8(command.parameter2),
                            UInt8(command.parameter3)
                        ]
                        
                    case SHAudioControlType.playControl.rawValue:
                        
                        controlData = [
                            UInt8(command.parameter1),
                            UInt8(command.parameter2)
                        ]
                        
                    case SHAudioControlType.volumeControl.rawValue:
                        
                        let vol =
                            CGFloat(SHAUDIO_MAX_VOLUME) * (1 - 0.01 * CGFloat(command.parameter2))
                        
                        controlData = [
                            UInt8(command.parameter1),
                            1,
                            3,
                            UInt8(vol)
                        ]
                        
                    case SHAudioControlType.playSpecifySong.rawValue:
                        
                        controlData = [
                            UInt8(command.parameter1),
                            UInt8(command.parameter2),
                            UInt8(command.parameter3 >> 8),
                            UInt8(command.parameter3 & 0xFF)
                        ]
                        
                    default:
                        break
                    }
                    
                } else if operatorCode == 0xF080 {
                    
                    controlData = [
                        
                        UInt8(command.parameter1),
                        UInt8(command.parameter2),
                        UInt8(command.parameter3 >> 8),
                        UInt8(command.parameter3 & 0xFF),
                        0,
                        0
                    ]
                    
                } else if operatorCode == 0x0031 ||
                    operatorCode == 0x010C {
                    
                    controlData = [
                        UInt8(command.parameter1),
                        UInt8(command.parameter2),
                        UInt8(command.parameter3 >> 8),
                        UInt8(command.parameter3 & 0xFF)
                    ]
                    
                } else {
                    
                    // 增加支持地热
                    if command.parameter3 == 0 {
                        
                        controlData = [
                            UInt8(command.parameter1),
                            UInt8(command.parameter2)
                        ]
                        
                    } else {
                        
                        controlData = [
                            UInt8(command.parameter1),
                            UInt8(command.parameter2),
                            UInt8(command.parameter3)
                        ]
                    }
                }
                
                SHSocketTools.sendData(
                    operatorCode: operatorCode,
                    subNetID: command.subnetID,
                    deviceID: command.deviceID,
                    additionalData: controlData
                )
                
                Thread.sleep(forTimeInterval:
                    TimeInterval(command.delayMillisecondAfterSend) * 0.001
                )
            }
        }
    }
}

// MARK: - 执行macro
extension SHSocketTools {
    
    /// 执行每个条Macro命令
    ///
    /// - Parameter command: 宏定义中的每一条指令
    static func executeMacroCommand(_ command: SHMacroCommand) {
        
        let operatorCode: UInt16 =
            SHSocketTools.getOperatorCode(
                command.commandTypeID
        )
        
        var controlData: [UInt8] = [UInt8]()
        
        // 音乐
        if operatorCode == 0x0218 {
            
            // 注意：旧版本协议的可变参数为2 ~ 4 个，新版本统一为4个，
            // 可以给不同的值，为了兼容，采用旧代码的协议方式
            
            switch command.firstParameter {
                // 音源控制
                // 播放模式
            // 播放控制
            case UInt(SHAudioControlType.musicSource.rawValue),
                 UInt(SHAudioControlType.playModeChanging.rawValue),
                 UInt(SHAudioControlType.playControl.rawValue):
                
                controlData = [
                    UInt8(command.firstParameter),
                    UInt8(command.secondParameter)
                ]
                
            // 列表/频道
            case UInt(SHAudioControlType.albmOrRadioControl.rawValue):
                
                controlData = [
                    UInt8(command.firstParameter),
                    UInt8(command.secondParameter),
                    UInt8(command.thirdParameter)
                ]
                
            // 歌曲播放
            case UInt(SHAudioControlType.playSpecifySong.rawValue):
                
                controlData = [
                    UInt8(command.firstParameter),
                    UInt8(command.secondParameter),
                    UInt8(command.thirdParameter >> 8),
                    UInt8(command.thirdParameter & 0xFF)
                ]
                
            // 音量调节
            case UInt(SHAudioControlType.volumeControl.rawValue):
                
                let vol = (1 - CGFloat(command.secondParameter) * 0.01) * CGFloat(SHAUDIO_MAX_VOLUME)
                
                controlData = [
                    UInt8(command.firstParameter),
                    1,
                    3,
                    UInt8(vol)
                ]
                
            default:
                break
            }
            
            // LED
        } else if operatorCode == 0xF080 {
            
            controlData = [
                UInt8(command.firstParameter),
                UInt8(command.secondParameter),
                UInt8(command.thirdParameter >> 8),
                UInt8(command.thirdParameter & 0xFF),
                0,
                0
            ]
            
            // 其它情况
        } else if operatorCode == 0x0031 ||
            operatorCode == 0x010C {
            
            controlData = [
                UInt8(command.firstParameter),
                UInt8(command.secondParameter),
                UInt8(command.thirdParameter >> 8),
                UInt8(command.thirdParameter & 0xFF)
            ]
            
        } else {
            
            if command.thirdParameter == 0 { // HVAC等
                
                controlData = [
                    UInt8(command.firstParameter),
                    UInt8(command.secondParameter)
                ]
                  
            } else { // 地热
                
                controlData = [
                    UInt8(command.firstParameter),
                    UInt8(command.secondParameter),
                    UInt8(command.thirdParameter)
                ]
            }
        }
        
        SHSocketTools.sendData(
            operatorCode: operatorCode,
            subNetID: command.subnetID,
            deviceID: command.deviceID,
            additionalData: controlData
        )
        
        Thread.sleep(forTimeInterval:
            TimeInterval(command.delayMillisecondAfterSend) * 0.001
        )
        
        
    }
}


extension SHSocketTools {
    
    /// 通过指令类型获得操作码
    ///
    /// - Parameter commandTypeID: 指令类型
    /// - Returns: 操作码
    static func getOperatorCode(_ commandTypeID: UInt) -> UInt16 {
        
        switch commandTypeID {
            
        case 0:
            return 0x0002 // 2个可变参数
            
        case 1, 5:
            return 0x001a // 2个可变参数
            
        case 2, 9:
            return 0xe01c // 2个可变参数
            
        case 4, 6:
            return 0x0031 // 4
            
        case 7:
            return 0xe3e0 // 2个参数
            
        case 8:
            return 0x192e // 8个可变参数
            
        case 10:
            return 0xe3d8 // 2
            
        case 18:
            return 0x0218 // 4
            
        case 11:
            return 0x0104 // 2
            
        case 12, 13, 14, 15, 16, 17:
            return 0x010c // 4
            
        case 30:
            return 0xf080 // 6
            
        default:
            return 0
        }
    }
}
