//
//  SHSchedualExecuteTools.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/4.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchedualExecuteTools.h"

@interface SHSchedualExecuteTools ()

/// 定时器
@property (nonatomic, weak) NSTimer *schedualTimer;

/// 执行的计划列表
@property (strong, nonatomic) NSMutableArray *schedulesActivate;

@end

@implementation SHSchedualExecuteTools


// MARK: - 执行具体的命令


// MARK: - Macro
/// 执行计划宏命令
- (void)exectuSchedualMacro:(SHSchedualCommand *)command {
    
    // 获得宏命令
    SHMacro *macro = [[SHMacro alloc] init];
    macro.macroID = command.parameter1;
    NSMutableArray *macros = [[SHSQLManager shareSQLManager] getCentralMacroCommands:macro];
    
    for (SHMacroCommand *command in macros) {
        
        [SHSocketTools executeMacroCommand:command];
        
        [NSThread sleepForTimeInterval:command.delayMillisecondAfterSend / 1000.0];
    }
}

// MARK: - Mood

/// 执行计划 mood
- (void)exectuSchedualMood:(SHSchedualCommand *)command {
    
    // 获得计划中的所有命令
    SHMood *mood = [[SHMood alloc] init];
    mood.moodID = command.parameter1;
    mood.zoneID = command.parameter2;
    NSMutableArray *moodCommands = [[SHSQLManager shareSQLManager] getAllMoodCommandsFor:mood];
    
    for (SHMoodCommand *command in moodCommands) {
       
        [SHSocketTools executeMoodCommand:command];
    }
}

// MARK: - Light

/// 执行计划 light
- (void)exectuSchedualLight:(SHSchedualCommand *)command {
    
    // 选找出灯
    SHLight *light = [[SHSQLManager shareSQLManager] getLightFor:command.parameter2 lightID:command.parameter1];
 
    
    if (light.lightTypeID != SHZoneControlLightTypeLed) {
     
        NSArray *controlData =
            @[@(light.channelNo), @(command.parameter3), @(0), @(0)];
        
        [SHSocketTools sendDataWithOperatorCode:0x0031
                                       subNetID:light.subnetID
                                       deviceID:light.deviceID
                                 additionalData:controlData
                               remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                     needReSend:true
                                          isDMX:false
         ];
    
    } else {
        
        NSArray *controlData =
            @[@(command.parameter3), @(command.parameter4),
              @(command.parameter5), @(0), @(0), @(0)];
        
        [SHSocketTools sendDataWithOperatorCode:0xF080
                                       subNetID:light.subnetID
                                       deviceID:light.deviceID
                                 additionalData:controlData
                               remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                     needReSend:true
                                          isDMX:false
         ];
    }
}

// MARK: - hvac

/// 执行计划 hvac
- (void)exectuSchedualHVAC:(SHSchedualCommand *)command {
    
    // 1.设置开关
    NSArray *onOff = @[ @(SHAirConditioningControlTypeOnAndOff),
                        @(command.parameter3)];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:command.parameter1
                                   deviceID:command.parameter2
                             additionalData:onOff
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
    
    
    // 2.设置风速
    NSArray *fanData = @[ @(SHAirConditioningControlTypeFanSpeedSet),
                          @(command.parameter4)];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:command.parameter1
                                   deviceID:command.parameter2
                             additionalData:fanData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
    
    // 3.设置工作模式
    NSArray *modeData = @[ @(SHAirConditioningControlTypeAcModeSet),
                           @(command.parameter5)];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:command.parameter1
                                   deviceID:command.parameter2
                             additionalData:modeData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
    
    // 4.设置模式温度
    NSArray *controlModelTemData = nil;
    
    if (command.parameter5 == SHAirConditioningModeTypeHeat) {
        
        controlModelTemData =
            @[@(SHAirConditioningControlTypeHeatTemperatureSet),
              @(command.parameter6)];
        
    } else if (command.parameter5 == SHAirConditioningModeTypeAuto) {
        
        controlModelTemData =
            @[@(SHAirConditioningControlTypeAutoTemperatureSet),
              @(command.parameter6)];
        
    } else {
        
        controlModelTemData =
            @[@(SHAirConditioningControlTypeCoolTemperatureSet),
              @(command.parameter6)];
    }
  
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:command.parameter1
                                   deviceID:command.parameter2
                             additionalData:controlModelTemData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
}

// MARK: - audio

/// 执行计划 audio
- (void)exectuSchedualAudio:(SHSchedualCommand *)command {
    
    // 1.控制声音
    [SHAudioOperatorTools changeAudioVolumeWithSubNetID:command.parameter1 deviceID:command.parameter2 volume:(1 - command.parameter3 * 0.01) * SHAUDIO_MAX_VOLUME zoneFlag:1
     ];
    
    [NSThread sleepForTimeInterval:0.1];
 
    // 2.切换音源来源

    [SHAudioOperatorTools changeAudioSourceWithSubNetID:command.parameter1
                                               deviceID:command.parameter2
                                       musicSoureNumber:command.parameter4 & 0xFF
                                               zoneFlag:1
     ];
    
    [NSThread sleepForTimeInterval:0.1];
    
    // 3.指定歌曲
    [SHAudioOperatorTools playAudioSelectSongWithSubNetID:command.parameter1
                                                 deviceID:command.parameter2
                                               sourceType:command.parameter4 & 0xFF
                                              albumNumber:command.parameter5 & 0xFF
                                               songNumber:command.parameter6 zoneFlag:1
     ];
    
    [NSThread sleepForTimeInterval:0.1];
    
    // 设置播放状态
    if (((command.parameter4 >> 8) & 0xFF) == SHAudioPlayControlTypePlay) {
        
        [SHAudioOperatorTools playAudioAnySongWithSubNetID:command.parameter1 deviceID:command.parameter2 sourceType:command.parameter4 & 0xFF zoneFlag:1
         ];
        
    } else {
         
        [SHAudioOperatorTools stopAudioSongWithSubNetID:command.parameter1 deviceID:command.parameter2 sourceType:command.parameter4 & 0xFF zoneFlag:1
         ];
    }
}

// MARK: - shade

/// 执行计划 shade
- (void)exectuSchedualShade:(SHSchedualCommand *)command {
    
    // 状态忽略，不管
    if (command.parameter3 == SHShadeStatusUnKnow) {
        return;
    }
    
    // 取出对应的指令对应的窗帘
   SHShade *shade =
        [[SHSQLManager shareSQLManager] getShadeFor:command.parameter2
                                            shadeID:command.parameter1
        ];
    
    // 根据状态发送指令
    
    
    // 当前是否开或关
    Byte controlChanel = 0;
    
    if (command.parameter3 == SHShadeStatusClose) { // 关闭
    
        controlChanel = shade.closeChannel;
        
    } else if (command.parameter3 == SHShadeStatusOpen) {  // 打开
         controlChanel = shade.openChannel;
    }
    
    // 控制数据
    NSArray *G4Curtain = @[@(controlChanel), @(100), @(0), @(0)];
    
    [SHSocketTools sendDataWithOperatorCode:0x0031
                                   subNetID:shade.subnetID
                                   deviceID:shade.deviceID
                             additionalData:G4Curtain
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
 
    NSArray *G3Curtain = @[@(controlChanel), @(100)];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3E0
                                   subNetID:shade.subnetID
                                   deviceID:shade.deviceID
                             additionalData:G3Curtain
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
}

// MARK: - 收到通知的响应

/// 执行计划
- (void)executeSchdule:(SHSchedual *)schdule {

    if (schdule.haveSound) {
        
        // 播放音效
        [[SoundTools shareSoundTools] playSoundWithName:@"schedulesound.wav"];
    }
    
    // 查询需要的命令
    NSMutableArray *schedualCommands = [[SHSQLManager shareSQLManager] getSchedualCommands:schdule.scheduleID];
    
    for (SHSchedualCommand *command in schedualCommands) {
        
        
        switch (command.typeID) {
                
                // 宏
            case SHSchdualControlItemTypeMarco: {
                
                [self performSelectorInBackground:@selector(exectuSchedualMacro:) withObject:command];
            }
                break;
                
                // Mood
            case SHSchdualControlItemTypeMood: {
                
                [self performSelectorInBackground:@selector(exectuSchedualMood:) withObject:command];
            }
                break;
                
                // Light
            case SHSchdualControlItemTypeLight: {
                
                [self performSelectorInBackground:@selector(exectuSchedualLight:) withObject:command];
            }
                break;
                
                // HVAC
            case SHSchdualControlItemTypeHVAC: {
                
                [self performSelectorInBackground:@selector(exectuSchedualHVAC:) withObject:command];
            }
                break;
                
                // Audio
            case SHSchdualControlItemTypeAudio: {
                
                [self performSelectorInBackground:@selector(exectuSchedualAudio:) withObject:command];
            }
                break;
                
                // Shade
            case SHSchdualControlItemTypeShade: {
                
                [self performSelectorInBackground:@selector(exectuSchedualShade:) withObject:command];
            }
                break;
                
            default:
                break;
        }
        
        [NSThread sleepForTimeInterval:0.1];
    }
}

/// 接到了执行计划的时间通知
- (void)recvieTimeForSchedualNotification {
    
    // 1.获得当前时间
    NSDateComponents * currentComponents = [NSDate getCurrentDateComponents];
    
    // 2.开始遍历需要执行的计划
    for (SHSchedual *schedual in self.schedulesActivate) {
        
        // 匹配频率
        switch (schedual.frequencyID) {
                
                // 只执行一次
            case SHSchdualFrequencyOneTime: {
                
                NSDateComponents *executeComponents = [NSDate getDateComponentsForDateFormatString:@"MM-dd HH:mm" byDateString:schedual.executionDate];
                
                if (executeComponents.month ==
                    currentComponents.month &&
                    executeComponents.day ==
                    currentComponents.day &&
                    executeComponents.hour ==
                    currentComponents.hour &&
                    executeComponents.minute ==
                    currentComponents.minute) {
                    
                    [self executeSchdule:schedual];
                }
            }
                break;
                
                // 每天执行一次
            case SHSchdualFrequencyDayily: {
                
                NSDateComponents *executeComponents = [NSDate getDateComponentsForDateFormatString:@"HH:mm" byDateString:schedual.executionDate];
                
                if (currentComponents.hour == executeComponents.hour &&
                    currentComponents.minute == executeComponents.minute) {
                    
                    [self executeSchdule:schedual];
                }
            }
                break;
                
                // 每周
            case SHSchdualFrequencyWeekly: {
                
                // 获得当前时间
                switch (currentComponents.weekday) {
                        
                        // 星期天
                    case SHSchdualWeekSunday: {
                        
                        if (schedual.withSunday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [self executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期一
                    case SHSchdualWeekMonday: {
                        
                        if (schedual.withMonday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [self executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期二
                    case SHSchdualWeekTuesday: {
                        
                        if (schedual.withTuesday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [self executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期三
                    case SHSchdualWeekWednesday: {
                        
                        if (schedual.withWednesday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [self executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期四
                    case SHSchdualWeekThursday: {
                        
                        if (schedual.withThursday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [self executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期五
                    case SHSchdualWeekFriday: {
                        
                        if (schedual.withFriday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [self executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期六
                    case SHSchdualWeekSaturday: {
                        
                        if (schedual.withSaturday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [self executeSchdule:schedual];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    }
}

// MARK: - 定时器的准备工作

/// 实初始化定时器
- (void)initSchedualTimer {
    
    // 初始化计划表
    [self updateSchduals];

    // 增加计划执行的 定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(prepareTimerForSchedual) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.schedualTimer = timer;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvieTimeForSchedualNotification) name:SHSchedualPrepareExecuteNotification object:nil];

}

/// 每分钟发出一次通知
- (void)prepareTimerForSchedual {
    
    if (!([[NSDate getCurrentDateComponents] second])) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHSchedualPrepareExecuteNotification object:nil];
    }
}

// MARK: - 更新执行计划

/// 更新计划
- (void)updateSchduals {
    
    NSMutableArray *scheduals = [[SHSQLManager shareSQLManager] getAllSchdule];
    
    [self.schedulesActivate removeAllObjects];
    
    for (SHSchedual *schedual in scheduals) {
        
        if (schedual.enabledSchedule && ![self.schedulesActivate containsObject:schedual]) {
            
            [self.schedulesActivate addObject:schedual];
        }
    }
}


// MARK: - getter && setter

/// 执行的计划数组
- (NSMutableArray *)schedulesActivate {
    
    if (!_schedulesActivate) {
        
        _schedulesActivate = [NSMutableArray array];
    }
    
    return _schedulesActivate;
}

// MARK: - 销毁

/// 移除定时器 && 通知
- (void)dealloc {
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 定时器失效
    [self.schedualTimer invalidate];
    self.schedualTimer = nil;
}

// MARK: 单例

SingletonImplementation(SchedualExecuteTools)

@end
