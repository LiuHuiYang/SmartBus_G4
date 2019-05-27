//
//  SHSchedualExecuteTools.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/4.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 后台任务标示
@objc enum SHApplicationBackgroundTask: UInt8 {
    
    case unknow // 未知
    case open   // 打开
    case close  // 关闭
}

/// 计划工具类
@objcMembers class SHSchedualExecuteTools: NSObject {
    
    /// 单例
    static let shared = SHSchedualExecuteTools()
    
    /// 可执行的schedual
    private lazy var schedulesActivate = [SHSchedule]()
    
    /// 定时器
    private var schedualTimer: Timer?
    
    deinit {
        schedualTimer?.invalidate()
        schedualTimer = nil
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 执行计划命令
    ///
    /// - Parameter schdule: 需要被执行的计划
    static func executeSchdule(_ schdule: SHSchedule) {
        
        
        /// 子线程中执行
        DispatchQueue.global().async {
            
            if schdule.haveSound {
                
                SoundTools.share()?.playSound(
                    withName: "schedulesound.wav"
                )
            }
            
            // 查询需要的命令
            let schedualCommands =
                SHSQLiteManager.shared.getSchedualCommands(
                    schdule.scheduleID
            )
            
            if schedualCommands.isEmpty {
                return
            }
            
            for command in schedualCommands {
                
                switch command.typeID {
                    
                case .macro :
                    
                    exectuSchedualMacro(command)
                    
                case .mood :
                    
                    exectuSchedualMood(command)
                    
                case .light :
                    
                    exectuSchedualLight(command)
                    
                case .hvac :
                    exectuSchedualHVAC(command)
                    
                case .floorHeating :
                    
                    exectuSchedualFloorHeating(command)
                    
                case .shade :
                    exectuSchedualShade(command)
                    
                case .audio :
                    exectuSchedualAudio(command)
                    
                    
                default:
                    break
                }
            }
        }
    }
}


extension SHSchedualExecuteTools {
    
    func initSchedualTimer() {
        
        updateSchduals()
        
        let timer =
            Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector:
                    #selector(prepareTimerForSchedual),
                userInfo: nil,
                repeats: true
        )
        
        RunLoop.current.add(timer, forMode: .common)
        
        schedualTimer = timer
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(recvieTimeForSchedualNotification),
            name: NSNotification.Name.SHSchedualPrepareExecute,
            object: nil
        )
    }
    
    
    /// 接收到了执行计划的时间通知
    @objc private func recvieTimeForSchedualNotification() {
        
        guard let currentComponents =
            NSDate.getCurrentDateComponents()
            else {
                
            return
        }
        
        print("发送执行 schedule \(Date())")
        if SHSocketTools.shared.socket?.isClosed() ?? true {
            print("socket 已经关闭了")
            SHSocketTools.shared.socket = nil
            SHSocketTools.shared.socket =
                SHSocketTools.shared.setupSocket()
        }
        
         
        for schedule in schedulesActivate {
            
            switch schedule.frequencyID {
                
            case .oneTime:
                
                guard let executeComponents =
                    NSDate.getDateComponents(
                            forDateFormatString: "MM-dd HH:mm",
                        byDateString:
                            schedule.executionDate
                    ) else {
                        
                        return
                }
                
                
                if executeComponents.month ==
                    currentComponents.month &&
                    executeComponents.day ==
                    currentComponents.day &&
                    executeComponents.hour ==
                    currentComponents.hour &&
                    executeComponents.minute ==
                    currentComponents.minute {
                        SHSchedualExecuteTools.executeSchdule(schedule)
                }
                
            case .dayily:
                guard let executeComponents =
                    NSDate.getDateComponents(
                        forDateFormatString: "HH:mm",
                        byDateString:
                        schedule.executionDate
                    ) else {
                        
                        return
                }
                
                if  executeComponents.hour ==
                    currentComponents.hour &&
                    executeComponents.minute ==
                    currentComponents.minute {
                    
                    SHSchedualExecuteTools.executeSchdule(schedule)
                }
                
            case .weekly:
                guard let weekday = currentComponents.weekday,
                let hour = currentComponents.hour,
                let minute = currentComponents.minute else {
                    return
                }
                
                switch UInt8(weekday) {
                    
                case SHSchdualWeek.sunday.rawValue:
                    
                    if !schedule.withSunday {
                        return
                    }
                    
                case SHSchdualWeek.monday.rawValue:
                    
                    if !schedule.withMonday {
                        return
                    }
                    
                case SHSchdualWeek.tuesday.rawValue:
                    
                    if !schedule.withTuesday {
                        return
                    }
                    
                case SHSchdualWeek.wednesday.rawValue:
                    
                    if !schedule.withWednesday {
                        return
                    }
                    
                case SHSchdualWeek.thursday.rawValue:
                    
                    if !schedule.withThursday {
                        return
                    }
                    
                case SHSchdualWeek.friday.rawValue:
                    
                    if !schedule.withFriday {
                        return
                    }
                    
                case SHSchdualWeek.saturday.rawValue:
                    
                    if !schedule.withSaturday {
                        return
                    }
                default:
                    break
                }
               
                if hour == schedule.executionHours &&
                    minute == schedule.executionMins {
                    SHSchedualExecuteTools.executeSchdule(schedule)
                }
            }
        }
    }
    
    
    /// 每分钟发出一次通知
    @objc private func prepareTimerForSchedual() {
        
        if NSDate.getCurrentDateComponents()?.second == 0 {
           
            NotificationCenter.default.post(
                name: NSNotification.Name.SHSchedualPrepareExecute,
                object: nil
            )
            
        }
    }
    
    /// 更新新执行计划
    func updateSchduals() {
         
        let scheduals = SHSQLiteManager.shared.getSchedules()
        
        if scheduals.isEmpty {
            return
        }
        
        schedulesActivate.removeAll()
        
        for schedual in scheduals {
            
            if schedual.enabledSchedule &&
                !schedulesActivate.contains(schedual) {
                
                schedulesActivate.append(schedual)
            }
        }
        
    }
}


// MARK: - 执行各项子命令
extension SHSchedualExecuteTools {
    
    
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
            SHSQLiteManager.shared.getShade(
                command.parameter2,
                shadeID: command.parameter1) else {
                
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
            SHSQLiteManager.shared.getLight(
                command.parameter2,
                lightID: command.parameter1) else {
                
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
        
        let moodCommands =
            SHSQLiteManager.shared.getMoodCommands(mood)
        
        for moodCommand in moodCommands {
            
            SHSocketTools.executeMoodCommand(
                moodCommand
            )
        }
    }
    
    
    /// 执行macroCommand
    ///
    /// - Parameter command: 命令
    static func exectuSchedualMacro(_ command: SHSchedualCommand) {
        
        let macro = SHMacro()
        
        macro.macroID = command.parameter1
        
        let macroCommands =
            SHSQLiteManager.shared.getMacroCommands(macro)
        
        if macroCommands.isEmpty {
            return
        }
        
        for command in macroCommands {
            
            SHSocketTools.executeMacroCommand(command)
            
            Thread.sleep(forTimeInterval: TimeInterval(
                command.delayMillisecondAfterSend
                )/1000.0
            )
        }
    }
}
