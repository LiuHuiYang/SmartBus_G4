//
//  SHZoneControlRecordMoodViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/11.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//


#import "SHZoneControlRecordMoodViewController.h"

@interface SHZoneControlRecordMoodViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SHEditRecordShadeStatusDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moodNameTextFieldHeightConstraint;

/// 区域标签
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;

/// 选择按钮的背景图片
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

/// 灯光按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *lightButton;

/// 空调按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *hvacButton;

/// 音乐按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *audioButton;

/// 灯光按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *shadeButton;

/// 窗帘列表
@property (weak, nonatomic) IBOutlet UITableView *shadeListView;

/// 窗帘占位视图
@property (weak, nonatomic) IBOutlet UIView *shadeHolderView;

/// 关闭窗帘占位视图按钮
@property (weak, nonatomic) IBOutlet UIButton *closeShadeHolderViewButton;


/// 地热按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *floorHeatingButton;

/// 当前区域的所有系统ID
@property (strong, nonatomic) NSArray *systemIDs;

/// 录制控制的背景界面
@property (weak, nonatomic) IBOutlet UIView *recordView;

/// 竖直方向上的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordViewBottomHeightConstraint;

/// 当前出现的键盘的高度
@property (assign, nonatomic) CGFloat keyboradHeight;

/// 录制按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *recordButton;

/// 选择图片按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *selectImageButton;

/// 场景名称
@property (weak, nonatomic) IBOutlet UITextField *moodNameTextField;

/// 所有的场景图片
@property (strong, nonatomic) NSMutableArray *moodImageNames;

/// 显示图片
@property (weak, nonatomic)  UIScrollView *moodIconsView;

/// 当前的模式
@property (nonatomic, strong) SHMood *currentMood;


// MARK: 录制的设备

/// 当前区域中的所有灯光设备
@property (strong, nonatomic) NSMutableArray *allLights;

/// 当前区域中的所有空调设备
@property (strong, nonatomic) NSMutableArray *allHVACs;

/// 当前区域所有的窗帘
@property (nonatomic, strong) NSMutableArray *allShades;

/// 所有的音乐设备
@property (nonatomic, strong) NSMutableArray *allAudios;

/// 所有的供暖设备
@property (nonatomic, strong) NSMutableArray *allFloorHeatings;

/// 录制成功
@property (nonatomic, assign) BOOL recordSuccess;

/// 录制定时器
@property (weak, nonatomic) NSTimer *timer;


@end

@implementation SHZoneControlRecordMoodViewController

// MARK: - 解析当前的状态

- (void)analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    NSUInteger count = socketData.additionalData.count;
    Byte recivedData[count];
    
    for (int i = 0; i < count; i++) {
        
        recivedData[i] =
        ([socketData.additionalData[i] integerValue]) & 0xFF;
    }
    
    switch (socketData.operatorCode) {
            
        case 0x0034: {
            
            // 这是LED
            if ((count == 0 + 4 + 1) &&
                socketData.deviceType == 0x0382) {
                
                // 获得每个通道的值
                Byte red   = recivedData[1];
                Byte green = recivedData[2];
                Byte blue  = recivedData[3];
                Byte white = recivedData[4];
                
                // 查询所有的灯光
                for (SHLight *light in self.allLights) {
                    
                    if (light.subnetID == socketData.subNetID &&
                        light.deviceID == socketData.deviceID) {
                        
                        // 这是将LED当成一个整体来控制的情况
                        light.redColorValue = red;
                        light.greenColorValue = green;
                        light.blueColorValue = blue;
                        light.whiteColorValue = white;
                        
                        light.ledHaveColor = (red || green || blue || white);
                        
                        // 这是将LED中的每个颜色通道【独立】看成一个灯 (另一种方式)
                        if (light.channelNo == SHZoneControllightLEDChannelRed) {
                            
                            light.brightness = red;
                            
                        } else if (light.channelNo == SHZoneControllightLEDChannelGreen) {
                            
                            light.brightness = green;
                            
                        } else if (light.channelNo == SHZoneControllightLEDChannelBlue) {
                            
                            light.brightness = blue;
                            
                        } else if (light.channelNo == SHZoneControllightLEDChannelWhite){
                            
                            light.brightness = white;
                        }
                        
                        light.recordSuccess = YES;
                    }
                }
                
                // 普通灯泡
            } else {
                
                // 这是普通灯炮 (总通道数)
                Byte totalChannels = recivedData[0];
                
                for (SHLight *light in self.allLights) {
                    
                    if (light.subnetID == socketData.subNetID &&
                        light.deviceID == socketData.deviceID &&
                        light.channelNo <= totalChannels) {
                        
                        light.brightness =
                        recivedData[0 + light.channelNo];
                        
                        if (light.canDim == SHZoneControlLightCanDimTypeNotDimmable) {
                            light.brightness =
                            (light.brightness == lightMaxBrightness) ?
                            lightMaxBrightness : 0;
                        }
                        
                        light.recordSuccess = YES;
                    }
                }
            }
            
            // ===== 处理录制完成的数据
            for (SHLight *light in self.allLights) {
                
                self.lightButton.recordSuccess = light.recordSuccess;
                
                if (!light.recordSuccess) {
                    break;
                }
            }
        }
            break;
            
            // 获得温度单位
        case 0xE121: {
             
            for (SHHVAC *hvac in self.allHVACs) {
                
                // 找到对应的空调
                if (hvac.subnetID == socketData.subNetID && hvac.deviceID == socketData.deviceID) {
                    
                    hvac.isCelsius =
                        (recivedData[0] == 0);
                }
            }
            
        }
            break;
            
        case 0xE0ED: {
            
            for (SHHVAC *hvac in self.allHVACs) {
                
                // 找到对应的空调
                if (hvac.subnetID == socketData.subNetID && hvac.deviceID == socketData.deviceID) {
                    
                    // 和以前一样的解析
                    
                    hvac.isTurnOn = recivedData[0];
                    hvac.indoorTemperature = recivedData[4];
                    hvac.fanSpeed = recivedData[2] & 0x0F;
                    hvac.acMode = (recivedData[2] & 0xF0) >> 4;
                    hvac.coolTemperture = recivedData[1];
                    hvac.heatTemperture = recivedData[5];
                    hvac.autoTemperture = recivedData[7];
                    
                    hvac.recordSuccess = YES;
                }
            }
            
            // ===== 处理录制完成的数据
            for (SHHVAC *hvac in self.allHVACs) {
                
                self.hvacButton.recordSuccess = hvac.recordSuccess;
                
                if (!hvac.recordSuccess) {
                    break;
                }
            }
        }
            break;
            
        case 0x192F: {  // 音乐
            
            for (SHAudio *audio in self.allAudios) {
                
                // 找到对应的音乐设备
                if (audio.subnetID == socketData.subNetID &&
                    audio.deviceID == socketData.deviceID) {
                    
                    // 1.获得音量大小部分
                    if (recivedData[0]  == 0x23 && // #
                        recivedData[1]  == 0x5A && // Z
                        //                recivedData[2]   && // z // 当前区号
                        recivedData[3]  == 0x2C && // ,
                        recivedData[4]  == 0x4F && // O
                        recivedData[5]  == 0x4E && // N
                        recivedData[6]  == 0x2C && // ,
                        recivedData[7]  == 0x53 && // S
                        recivedData[8]  == 0x52 && // R
                        recivedData[9]  == 0x43 && // C
                        //                recivedData[0 + 10]  && // 当前源号
                        recivedData[11] == 0x2C && // ,
                        recivedData[12] == 0x56 && // V
                        recivedData[13] == 0x4F && // O
                        recivedData[14] == 0x4C    // L
                        ) {
                        
                        if (recivedData[17] == 0xD) {
                            
                            audio.recoredVolume = SHAUDIO_MAX_VOLUME -
                            (([SHAudioOperatorTools asciiToDecimalWithData:recivedData[15]]) * 10 +
                             [SHAudioOperatorTools asciiToDecimalWithData:recivedData[16]]);
                            
                            
                            
                        } else {
                            
                            audio.recoredVolume = SHAUDIO_MAX_VOLUME -
                            [SHAudioOperatorTools asciiToDecimalWithData:recivedData[15]];
                        }
                    }
                    
                    
                    // 3.获得歌曲名称
                    else if (recivedData[0]  == 0x23 && // #
                             recivedData[1]  == 0x53 && // S
                             
                             // recivedData[2] 音乐来源
                             
                             recivedData[3]  == 0x44 && // D
                             recivedData[4]  == 0x49 && // I
                             recivedData[5]  == 0x53 && // S
                             recivedData[6]  == 0x50 && // P
                             recivedData[7]  == 0x4C && // L
                             recivedData[8]  == 0x49 && // I
                             recivedData[9]  == 0x4E && // N
                             recivedData[10] == 0x45 && // E
                             
                             recivedData[12] == 0x2C &&  // ,
                             recivedData[13] == 0x02     // STX , ASC码
                             ) {
                        
                        NSString *string =
                        [[NSString alloc]
                         initWithBytes:&recivedData[14]
                         length:(count - 0 - 14 - 3)
                         encoding:NSUnicodeStringEncoding
                         ];
                        
                        if (!string.length) {
                            break;
                        }
                        
                        // 音乐来源
                        audio.recordSource =
                            [SHAudioOperatorTools asciiToDecimalWithData:recivedData[2]];
                        
                        switch (recivedData[11]) {
                                
                            case 0x31: {  // 列表号与列表总数
                                
                                // 获得专辑分类 辑字符串:List:1/8
                                NSRange range1 = [string rangeOfString:@"List:"];
                                NSRange range2 = [string rangeOfString:@"/"];
                                
                                if (range1.location == NSNotFound ||
                                    range2.location == NSNotFound) {
                                    
                                    break;
                                }
                                
                                NSRange range =
                                NSMakeRange(range1.location + range1.length,
                                            range2.location - range1.location -
                                            range1.length);
                                
                                string = [string substringWithRange:range];
                                
                                audio.recordAlubmNumber = string.integerValue;
                            }
                                break;
                                
                            case 0x33: {  // 列表号与列表总数
                                
                                // 获得歌曲号 歌曲字符串:Track:1/5
                                
                                NSRange range1 = [string rangeOfString:@"Track:"];
                                NSRange range2 = [string rangeOfString:@"/"];
                                
                                if (range1.location == NSNotFound ||
                                    range2.location == NSNotFound) {
                                    
                                    break;
                                }
                                
                                NSRange range =
                                NSMakeRange(range1.location + range1.length,
                                            range2.location - range1.location -
                                            range1.length);
                                
                                string = [string substringWithRange:range];
                                
                                audio.recordSongNumber = string.integerValue;
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                    // 4.获得当前的播放状态
                    else if (recivedData[0]  == 0x23 &&  // #
                             recivedData[1]  == 0x53 &&  // S
                             
                             // recivedData[0 + 2]         // 音乐来源
                             
                             recivedData[3]  == 0x44 &&  // D
                             recivedData[4]  == 0x49 &&  // I
                             recivedData[5]  == 0x53 &&  // S
                             recivedData[6]  == 0x50 &&  // P
                             recivedData[7]  == 0x49 &&  // I
                             recivedData[8]  == 0x4E &&  // N
                             recivedData[9]  == 0x46 &&  // F
                             recivedData[10] == 0x4F &&  // O
                             recivedData[11] == 0x2C &&  // ,
                             recivedData[12] == 0x44 &&  // D
                             recivedData[13] == 0x55 &&  // U
                             recivedData[14] == 0x52     // R
                             ) {
                        
                        audio.recordPlayStatus = (recivedData[count - 2] == 0x32) ? SHAudioPlayControlTypePlay : SHAudioPlayControlTypeStop;
                    }
                    
                    // 这些都不可能是0 才是录制成功
                    if (audio.recordPlayStatus  &&
                        audio.recordAlubmNumber &&
                        audio.recordSongNumber  &&
                        audio.recordSource) {
                        
                        audio.recordSuccess = YES;
                    }
                }
            }
            
            // ===== 处理录制完成的数据
            for (SHAudio *audio in self.allAudios) {
                
                self.audioButton.recordSuccess = audio.recordSuccess;
                
                if (!audio.recordSuccess) {
                    break;
                }
            }
        }
            break;
            
            
        case 0x03C8: { //获得模式温度
            
            for (SHFloorHeating *floorHeating in self.allFloorHeatings) {
                
                // 找到设备
                if (floorHeating.subnetID == socketData.subNetID &&
                    floorHeating.deviceID == socketData.deviceID &&
                    floorHeating.channelNo == recivedData[2]) {
                    
                    floorHeating.recordSuccess = YES;
                    
                    // 获得每个模式下的温度
                    floorHeating.manualTemperature =
                        recivedData[1];
                    
                    floorHeating.dayTemperature =
                        recivedData[3];
                    
                    floorHeating.nightTemperature =
                        recivedData[5];
                    
                    floorHeating.awayTemperature =
                        recivedData[7];
                }
            }
        }
            break;
            
        case 0xE3DB: { // 开关与模式
            
            Byte operatorKind = recivedData[0];
            Byte operatorResult = recivedData[1];
            
            for (SHFloorHeating *floorHeating in self.allFloorHeatings) {
                
                // 找到设备
                if (floorHeating.subnetID == socketData.subNetID &&
                    floorHeating.deviceID == socketData.deviceID &&
                    floorHeating.channelNo == recivedData[2]) {
                    
                    switch (operatorKind) {
                        case SHFloorHeatingControlTypeOnAndOff:
                            floorHeating.isTurnOn = operatorResult;
                            break;
                            
                        case SHFloorHeatingControlTypeModelSet:
                            floorHeating.floorHeatingModeType =
                            operatorResult;
                            break;
                        default:
                            break;
                    }
                    
                    floorHeating.recordSuccess = YES;
                }
            }
            
            
            // ===== 处理录制完成的数据
            for (SHFloorHeating *floorHeating in self.allFloorHeatings) {
                
                self.floorHeatingButton.recordSuccess =
                floorHeating.recordSuccess;
                
                if (!floorHeating.recordSuccess) {
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
}


// MARK: - 完成录制

/// 完成录制
- (void)finishedRecored {
    
    static Byte count = 0;
    ++count;
    
    BOOL recoredLight =
        (self.lightButton.selected ? self.lightButton.recordSuccess : YES);
    
    BOOL recoredHVAC =
        (self.hvacButton.selected ? self.hvacButton.recordSuccess : YES);
    
    BOOL recoredAudio =
        (self.audioButton.selected ? self.audioButton.recordSuccess : YES);
    
    BOOL recoredFloorHeating=
        (self.floorHeatingButton.selected ? self.floorHeatingButton.recordSuccess : YES);
    
    // 由于音乐数据比较多, 容易失败, 所以启动多次重发
    if (!recoredAudio) {
    
        [self readAudioStatus];
    }
    
    // 窗帘是直接编辑的, 所以不读取状态.
    self.shadeButton.recordSuccess = YES;
    BOOL recoredShade =
        (self.shadeButton.selected ? self.shadeButton.recordSuccess : YES);
    
    BOOL status = recoredLight && recoredHVAC && recoredAudio && recoredShade && recoredFloorHeating;
    
    printLog(@"灯光状态: %d\n空调状态: %d\n音乐状态: %d\n窗帘状态: %d\n窗帘状态: %d\n最终的录制结果: %d",
          self.lightButton.recordSuccess,
          self.hvacButton.recordSuccess,
          self.audioButton.recordSuccess,
          self.shadeButton.recordSuccess,
          self.floorHeatingButton.recordSuccess,
          status);
    
    if (status) {
        
        // 定时器失效
        [self.timer invalidate];
        self.timer = nil;
        
        printLog(@"保存数据");
        
        [SHSQLiteManager.shared insertMood:self.currentMood];
        
        [self saveLightMoods];
        [self saveHvacMoods];
        [self saveShadeMoods];
        [self saveAudioMoods];
        [self saveFloorHeatings];
       
        // 显示录制成功
        NSString *resultString = [NSString stringWithFormat:@"%@ %@", [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"RECORD"], SHLanguageText.done];
        
        [SVProgressHUD showSuccessWithStatus:resultString];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    // 音乐比较复杂，需要解析的内容比较多 * 3 多延时一下
    if (count > (self.allLights.count +
                 self.allHVACs.count  +
                 self.allAudios.count * 3 +
                 self.allShades.count +
                 self.allFloorHeatings.count)
        ) {
        
        // 定时器失效
        [self.timer invalidate];
        self.timer = nil;
        
        NSString *statusString = [NSString stringWithFormat: @"%@\n\r%@\n\r%@",
                                  
                                  [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"PROMPT_MESSAGE_2"],
                                  
                                  [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"PROMPT_MESSAGE_3"],
                                  
                                  [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"PROMPT_MESSAGE_4"]
                                  ];
        
        [SVProgressHUD showErrorWithStatus:statusString];
    }
}


/// 保存窗帘数据
- (void)saveShadeMoods {
    
    for (SHShade *shade in self.allShades) {
        
        SHMoodCommand *moodCommand = [[SHMoodCommand alloc] init];
        moodCommand.id =
        [SHSQLiteManager.shared getMaxIDForMoodCommand] + 1;
        moodCommand.deviceName = shade.shadeName;
        moodCommand.zoneID = self.currentMood.zoneID;
        moodCommand.moodID = self.currentMood.moodID;
        moodCommand.deviceType = SHSystemDeviceTypeShade;
        moodCommand.subnetID = shade.subnetID;
        moodCommand.deviceID = shade.deviceID;
        
        moodCommand.parameter1 = shade.currentStatus;
        moodCommand.parameter2 = shade.openChannel;
        moodCommand.parameter3 = shade.closeChannel;
        
        if (shade.currentStatus == SHShadeStatusClose ||
            shade.currentStatus == SHShadeStatusOpen) {
            
            [SHSQLiteManager.shared insertMoodCommand:moodCommand];
        }
    }
}

/// 保存音乐数据
- (void)saveAudioMoods {
    
    for (SHAudio *audio in self.allAudios) {
        
        SHMoodCommand *moodCommand = [[SHMoodCommand alloc] init];
        moodCommand.id = SHSQLiteManager.shared.getMaxIDForMoodCommand + 1;
        moodCommand.deviceName = audio.audioName;
        
        moodCommand.zoneID = self.currentMood.zoneID;
        moodCommand.moodID = self.currentMood.moodID;
        
        moodCommand.deviceType = SHSystemDeviceTypeAudio;
        
        moodCommand.subnetID = audio.subnetID;
        moodCommand.deviceID = audio.deviceID;
        
        moodCommand.parameter1 = audio.recoredVolume;
        moodCommand.parameter2 = audio.recordSource;
        moodCommand.parameter3 = audio.recordAlubmNumber;
        moodCommand.parameter4 = audio.recordSongNumber;
        moodCommand.parameter5 = audio.recordPlayStatus;
        
        [SHSQLiteManager.shared insertMoodCommand:moodCommand];
    }
}

/// 保存地热数据
- (void)saveFloorHeatings {
    
    for (SHFloorHeating *floorHeating in self.allFloorHeatings) {
        
        SHMoodCommand *command = [[SHMoodCommand alloc] init];
        
        command.id = SHSQLiteManager.shared.getMaxIDForMoodCommand + 1;
        command.zoneID = self.currentMood.zoneID;
        command.moodID = self.currentMood.moodID;
        command.deviceName = floorHeating.floorHeatingRemark;
        command.deviceType = SHSystemDeviceTypeFloorHeating;
        command.subnetID = floorHeating.subnetID;
        command.deviceID = floorHeating.deviceID;
        
        command.parameter1 = floorHeating.channelNo;
        command.parameter2 = floorHeating.isTurnOn;
        command.parameter3 = floorHeating.floorHeatingModeType;
        command.parameter4 = floorHeating.manualTemperature;
        
       
        [SHSQLiteManager.shared insertMoodCommand:command];
    }
}

/// 保存空调的数据
- (void)saveHvacMoods {
    
    for (SHHVAC *hvac in self.allHVACs) {
        
        SHMoodCommand *moodCommand = [[SHMoodCommand alloc] init];
        moodCommand.id = SHSQLiteManager.shared.getMaxIDForMoodCommand + 1;
        moodCommand.deviceName = hvac.acRemark;
        
        moodCommand.zoneID = self.currentMood.zoneID;
        moodCommand.moodID = self.currentMood.moodID;
        
        moodCommand.deviceType = SHSystemDeviceTypeHvac;
        
        moodCommand.subnetID = hvac.subnetID;
        moodCommand.deviceID = hvac.deviceID;
        
        moodCommand.parameter1 = hvac.isTurnOn;
        moodCommand.parameter2 = hvac.fanSpeed;
        moodCommand.parameter3 = hvac.acMode;
        
        if (hvac.acMode == SHAirConditioningModeTypeHeat) {
            moodCommand.parameter4 = hvac.heatTemperture;
            
        } else if (hvac.acMode == SHAirConditioningModeTypeAuto) {
            
            moodCommand.parameter4 = hvac.autoTemperture;
            
        } else {
            
            moodCommand.parameter4 = hvac.coolTemperture;
        }
        
        [SHSQLiteManager.shared insertMoodCommand:moodCommand];
    }
}

/// 保存灯光的场景数据
- (void)saveLightMoods {
    
    for (SHLight *light in self.allLights) {
        
        SHMoodCommand *moodCommand = [[SHMoodCommand alloc] init];
        moodCommand.id =
            SHSQLiteManager.shared.getMaxIDForMoodCommand + 1;
        
        moodCommand.deviceName = light.lightRemark;
        
        moodCommand.zoneID = self.currentMood.zoneID;
        moodCommand.moodID = self.currentMood.moodID;
        
        moodCommand.deviceType = SHSystemDeviceTypeLight;
        
        moodCommand.subnetID = light.subnetID;
        moodCommand.deviceID = light.deviceID;
        
        moodCommand.parameter1 = light.lightTypeID;
        
        // LED
        if (light.lightTypeID == SHZoneControlLightTypeLed ||
            light.canDim == SHZoneControlLightCanDimTypeLed) {
            
            moodCommand.parameter2 = light.redColorValue;
            moodCommand.parameter3 = light.greenColorValue;
            moodCommand.parameter4 = light.blueColorValue;
            moodCommand.parameter5 = light.whiteColorValue;
            
        } else {
            
            moodCommand.parameter2 = light.channelNo;
            moodCommand.parameter3 = light.brightness;
        }
        
        [SHSQLiteManager.shared insertMoodCommand:moodCommand];
    }
}

// MARK: - 按钮点击

/// 关闭占位视图按钮
- (IBAction)closeShadeHolderViewButtonClick {
    
    self.shadeHolderView.hidden = YES;
}

/// 开始录制
- (IBAction)recordButtonClick {
    
    // 隐藏窗帘
    self.shadeHolderView.hidden = YES;
    
    // 1.处理名称
    if (![self parseRecordName]) {
        
        return;
    }
    
    // 2.处理键盘
    if (self.keyboradHeight) {
        
        self.recordViewBottomHeightConstraint.constant -= self.keyboradHeight;
        [self.view layoutIfNeeded];
        self.keyboradHeight = 0;
        
        [self.moodNameTextField endEditing:YES];
    }
    
    self.moodIconsView.hidden = YES;
    
    // 没有选择任何
    if (
        (!self.lightButton.selected &&
         !self.hvacButton.selected  &&
         !self.audioButton.selected &&
         !self.shadeButton.selected &&
         !self.floorHeatingButton.selected)
        ) {
        
        
        NSString *statusString = [NSString stringWithFormat: @"%@\n\r%@\n\r%@",
                                  
                                  [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"PROMPT_MESSAGE_5"],
                                  
                                  [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"PROMPT_MESSAGE_6"],
                                  
                                  [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"PROMPT_MESSAGE_7"]
                                  ];
        
        [SVProgressHUD showErrorWithStatus:statusString];
        
        return;
    }
    
    [SVProgressHUD showWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"PROMPT_MESSAGE_8"]];
    
    
    // 开始录制
    [self readLightStatus];
    [self readHVACStatus];
    [self recordShade];
    [self readAudioStatus];
    [self readFloorheatingStatus];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(finishedRecored)
                                           userInfo:nil
                                            repeats:YES
                    ];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    _timer = timer;
}

/// 读取地热状态
- (void)readFloorheatingStatus {
    
    for (SHFloorHeating *floorHeating in self.allFloorHeatings) {
        
        // 读取模式匹配温度与传感器的地址
        [SHSocketTools sendDataWithOperatorCode:0x03C7 subNetID:floorHeating.subnetID deviceID:floorHeating.deviceID additionalData:@[@(floorHeating.channelNo)] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:true isDMX:false];
        
        // 读取开关状态
        [SHSocketTools sendDataWithOperatorCode:0xE3DA subNetID:floorHeating.subnetID deviceID:floorHeating.deviceID additionalData:@[@(SHFloorHeatingControlTypeOnAndOff), @(floorHeating.channelNo)] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:true isDMX:false];
        
        // 读取模式状态
        [SHSocketTools sendDataWithOperatorCode:0xE3DA subNetID:floorHeating.subnetID deviceID:floorHeating.deviceID additionalData:@[@(SHFloorHeatingControlTypeModelSet), @(floorHeating.channelNo)] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:true isDMX:false];
    }
    
    
}

/// 读取窗帘的状态，本身存在问题，只是为了保证当前设备在线
- (void)recordShade {
    
    for (SHShade *shade in self.allShades) {
        
        shade.recordSuccess = NO;
        
        [SHSocketTools sendDataWithOperatorCode:0x0033 subNetID:shade.subnetID deviceID:shade.subnetID additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:false isDMX:false];
    }
}

/// 录制音乐的状态
- (void)readAudioStatus {
    
    for (SHAudio *audio in self.allAudios) {
        
        audio.recordSuccess = NO;
 
        [SHAudioOperatorTools readAudioModelWithSubNetID:audio.subnetID
                                                deviceID:audio.deviceID];
    }
}

/// 读取HVAC的状态
- (void)readHVACStatus {
    
    for (SHHVAC *hvac  in self.allHVACs) {
        
        hvac.recordSuccess = NO;
        
        // 读取温度单位
        [SHSocketTools sendDataWithOperatorCode:0xE120 subNetID:hvac.subnetID deviceID:hvac.deviceID additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:true isDMX:false];
        
        // 读取状态空调的开关状态
        [SHSocketTools sendDataWithOperatorCode:0xE0EC subNetID:hvac.subnetID deviceID:hvac.deviceID additionalData:@[@(hvac.channelNo)] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:true isDMX:false];
    }
}

/// 读取灯泡的状态
- (void)readLightStatus {
    
    Byte subNetID = 0, deviceID = 0;
    
    for (SHLight *light in self.allLights) {
        
        light.recordSuccess = NO;
        
        if (light.subnetID == subNetID &&
            light.deviceID == deviceID) {
            
            continue;
        }
        
        subNetID = light.subnetID;
        deviceID = light.deviceID;

        [SHSocketTools sendDataWithOperatorCode:0x0033 subNetID:light.subnetID deviceID:light.deviceID additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:true isDMX:false];
    }
}

/// 选择图片
- (IBAction)selectImageButtonClick {
    
    [self textFieldShouldReturn:self.moodNameTextField];
    self.moodIconsView.hidden = !self.moodIconsView.hidden;
}

/// 选择灯光
- (IBAction)lightButtonClick {
    
    self.lightButton.selected = !self.lightButton.selected;
    
    NSArray *lights = [[SHSQLiteManager shared]
                       getLights:self.currentZone.zoneID];
    
    NSMutableArray *allLights = [NSMutableArray arrayWithArray:lights];
    
    self.allLights = self.lightButton.selected ? allLights : nil;
}

/// 选择空调
- (IBAction)hvacButtonClick {
    
    self.hvacButton.selected = !self.hvacButton.selected;
   
    NSArray *hvacs = [SHSQLiteManager.shared getHVACs:self.currentZone.zoneID];
    
    self.allHVACs =
        self.hvacButton.isSelected ?
        [NSMutableArray arrayWithArray:hvacs] : nil;
}

/// 选择音乐
- (IBAction)audioButtonClick {
    
    self.audioButton.selected = !self.audioButton.selected;
    
    NSArray *audios = [SHSQLiteManager.shared getAudios:self.currentZone.zoneID];
    
    self.allAudios = self.audioButton.isSelected? [NSMutableArray arrayWithArray:audios] : nil;
}

/// 选择窗帘
- (IBAction)shadeButtonClick {
    
    self.shadeButton.selected = !self.shadeButton.selected;
    self.shadeHolderView.hidden = !self.shadeHolderView.hidden;
    
    if (self.shadeButton.selected) {
        
        NSArray *shades = [[SHSQLiteManager shared] getShades:self.currentZone.zoneID];
        
        self.allShades =
            [NSMutableArray arrayWithArray:shades];
        
        [self.shadeListView reloadData];
    }
}

/// 地热按钮点击
- (IBAction)floorheatingButtonClick {
    
    self.floorHeatingButton.selected = !self.floorHeatingButton.selected;
     
    NSArray *FloorHeatings = [SHSQLiteManager.shared getFloorHeatings:self.currentZone.zoneID];
    
    self.allFloorHeatings =
        self.floorHeatingButton.isSelected ?
        [NSMutableArray arrayWithArray:FloorHeatings] : nil;
}

/// 选择图片
- (void)choiceMoodImage:(UIButton *)button {
    
    NSString *imageName = self.moodImageNames[button.tag];
    
    NSString *normalImageName = [NSString stringWithFormat:@"%@_highlighted", imageName];
    
    [self.selectImageButton setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    
    self.currentMood.moodIconName = imageName ? imageName : self.moodImageNames.firstObject;
    
    self.moodIconsView.hidden = !self.moodIconsView.hidden;
}

// MARK: - UITextField 代理

/// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.moodIconsView.hidden = YES;
}

/// 点击确认键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.moodNameTextField) {
        
        if (self.keyboradHeight) {
            
            self.recordViewBottomHeightConstraint.constant -= self.keyboradHeight;
            [self.view layoutIfNeeded];
            self.keyboradHeight = 0;
        }
        
        [textField endEditing:YES]; // 退出编辑模式
    }
    
    return YES;
}

/// 解析录制名称
- (BOOL)parseRecordName {
    
    NSString *name = self.moodNameTextField.text;
    
    if (!name.length ||
        [name isEqual:[NSNull null]] ||
        ![[name stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceCharacterSet]] length]) {
        
        [SVProgressHUD showErrorWithStatus:@"The name cannot be empty!"];
        return NO;
    }
    
    //  检查名字是否有相同的
    
    NSArray * moods =
        [SHSQLiteManager.shared getMoods:self.currentZone.zoneID];
    
    for (SHMood *mood in moods) {
        
        if ([mood.moodName isEqualToString:name]) {
            
            [SVProgressHUD showErrorWithStatus:@"The name has been saved!"];
            
            return NO;
        }
    }
    
    self.currentMood.moodName = name;
    
    return YES;
}

// MARK: - 设置窗帘的状态代理

- (void)editShade:(SHShade *)shade currentStatus:(NSString *)status {
    
    for (SHShade *currentShade in self.allShades) {
        
        if (currentShade.shadeID == shade.shadeID &&
            currentShade.subnetID == shade.subnetID &&
            currentShade.deviceID == shade.deviceID) {
            
            if ([status isEqualToString: [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_OPEN"]]) {
                
                currentShade.currentStatus = SHShadeStatusOpen;
                
            } else if ([status isEqualToString:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_CLOSE"]]) {
                
                currentShade.currentStatus = SHShadeStatusClose;
                
            } else {
                
                currentShade.currentStatus = SHShadeStatusUnKnow;
            }
        }
    }
}

// MARK: - 代理

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allShades.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHEditRecordShadeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHEditRecordShadeCell class]) forIndexPath:indexPath];

    cell.delegate = self;
    
    cell.shade = self.allShades[indexPath.row];
    
    return cell;
}

// MARK: - 通知处理

/// 键盘出现
-(void)keyboardWillShow:(NSNotification *)notification {
    
    if (self.keyboradHeight) {
        return;
    }
    
    // 获得键盘的高度
    self.keyboradHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (![self.moodNameTextField isFirstResponder]) {
        
        return;
    }
    
    self.recordViewBottomHeightConstraint.constant += self.keyboradHeight;
    
    [self.view layoutIfNeeded];
    
    if (self.keyboradHeight && self.shadeButton.selected) {
        
        self.shadeListView.hidden = YES;
    }
}


/// 移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - UI界面设置

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    // 设置显示图片的位置
    self.moodIconsView.frame_centerX = self.buttonsView.frame_centerX;
    self.moodIconsView.frame_y = self.buttonsView.frame_y;
    self.moodIconsView.frame_width = MIN(self.view.frame_width , self.view.frame_height) * 0.75;
    self.moodIconsView.frame_height = self.moodIconsView.frame_width * 0.75;
    
    // 设置每个图片按钮的位置
    
    // 总共有的列数
    NSUInteger totalCols = 3;
    CGFloat realRows = (self.moodImageNames.count / (CGFloat)totalCols);
    NSUInteger totalRows = realRows > (self.moodImageNames.count / totalCols) ? ++realRows : realRows;
    
    CGFloat marign = self.moodIconsView.frame_width * 0.1;
    CGFloat buttonWidth = (self.moodIconsView.frame_width - (totalCols + 1) * marign) / totalCols;
    CGFloat buttonHeight = buttonWidth;
    
    for (NSUInteger i = 0; i < self.moodIconsView.subviews.count; i++) {
        
        UIButton *iconButton = self.moodIconsView.subviews[i];
        
        // 计算行数和列数
        NSUInteger row = i / totalCols;
        NSUInteger col = i % totalCols;
        
        iconButton.frame = CGRectMake(marign + (buttonWidth + marign) * col, row * (buttonHeight + marign) + marign, buttonWidth, buttonHeight);
    }
    
    // 设置滚动范围
    self.moodIconsView.contentSize = CGSizeMake(0, totalRows *( buttonHeight + marign));
    
    if ([UIDevice is_iPad]) {
        
        self.moodNameTextFieldHeightConstraint.constant = navigationBarHeight + statusBarHeight;
    }
}

/// 准备新模式
- (void)prepareNewMood {
    
    // 1.创建新模式
    SHMood *mood = [[SHMood alloc]  init];
    
    mood.moodID = 
    [SHSQLiteManager.shared getMaxMoodID:self.currentZone.zoneID] + 1;
    
    mood.zoneID = self.currentZone.zoneID;
    mood.moodIconName = self.moodImageNames.firstObject;
    
    self.currentMood = mood;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareNewMood];
    
    [self suitText];
    
    [self showRecordDeviceKinds];
    
    // 添加显示选择场景图片的view
    [self showMoodIconsView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self.recordButton setRoundedRectangleBorder];
    [self.selectImageButton setRoundedRectangleBorder];
    [self.moodNameTextField setRoundedRectangleBorder];
    
    if ([UIDevice is_iPad]) {
        
        self.zoneLabel.font = [UIView suitFontForPad];
        self.moodNameTextField.font = [UIView suitFontForPad];
    }
}

/// 显示场景图片选择
- (void)showMoodIconsView {
    
    // 1.添加选择图片背景的view
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.layer.cornerRadius = 15;
    scrollView.clipsToBounds = YES;
    [self.view addSubview:scrollView];
    scrollView.hidden = YES;
    self.moodIconsView = scrollView;
    
    // 2.添加每个图片
    for (NSUInteger i = 0; i < self.moodImageNames.count; i++) {
        
        UIButton *iconButton = [[UIButton alloc] init];
        
        [iconButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal", self.moodImageNames[i]]] forState:UIControlStateNormal];
        
        [iconButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted", self.moodImageNames[i]]] forState:UIControlStateHighlighted];
        
        iconButton.tag = i;
        [scrollView addSubview:iconButton];
        [iconButton addTarget:self action:@selector(choiceMoodImage:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/// 显示录制种类
- (void)showRecordDeviceKinds {
    
    // 获得当前区域中的所有系统设备
    self.systemIDs =
    [SHSQLiteManager.shared getSystemIDs:self.currentZone.zoneID];
    
    self.lightButton.hidden = !([self.systemIDs containsObject:@(SHSystemDeviceTypeLight)]);
    
    self.hvacButton.hidden = !([self.systemIDs containsObject:@(SHSystemDeviceTypeHvac)]);
    
    self.audioButton.hidden = !([self.systemIDs containsObject:@(SHSystemDeviceTypeAudio)]);
    
    self.shadeButton.hidden = !([self.systemIDs containsObject:@(SHSystemDeviceTypeShade)]);
    
    self.floorHeatingButton.hidden = !([self.systemIDs containsObject:@(SHSystemDeviceTypeFloorHeating)]);
    
   
    self.shadeHolderView.hidden = YES;
    [self.shadeHolderView setRoundedRectangleBorder];
    
  
//    self.shadeListView.layer.cornerRadius = 15;
//    self.shadeListView.clipsToBounds = YES;
    self.shadeListView.rowHeight =
        [SHEditRecordShadeCell rowHeight];
    
    [self.shadeListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHEditRecordShadeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHEditRecordShadeCell class])];
}

/// 适配文字
- (void)suitText {
    
    self.navigationItem.title = [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"RECORD_MOOD"];
    
    self.zoneLabel.text = self.currentZone.zoneName;
    
    [self.lightButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MAIN_PAGE" withSubTitle:@"alight"] forState:UIControlStateNormal];
    
    [self.hvacButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MAIN_PAGE" withSubTitle:@"bhvac"] forState:UIControlStateNormal];
    
    [self.audioButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MAIN_PAGE" withSubTitle:@"czaudio"] forState:UIControlStateNormal];
    
    [self.shadeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MAIN_PAGE" withSubTitle:@"dshades"] forState:UIControlStateNormal];
    
    [self.closeShadeHolderViewButton
        setTitle:SHLanguageText.done
     forState:UIControlStateNormal
     ];
    
    [self.closeShadeHolderViewButton setRoundedRectangleBorder];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"MOOD_NAME"]];
    
    [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: [UIView textWhiteColor]} range:NSMakeRange(0, string.length)];
    
    self.moodNameTextField.attributedPlaceholder = string;
    
    [self.selectImageButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SELECT_ICON"] forState:UIControlStateNormal];
    
    [self.recordButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"RECORD"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - getter && setter


- (NSMutableArray *)moodImageNames {
    
    if (!_moodImageNames) {
        _moodImageNames = [NSMutableArray arrayWithObjects:@"mood_romantic", @"mood_bye", @"mood_dining", @"mood_meeting", @"mood_night", @"mood_party", @"mood_study", @"mood_tv", nil];
    }
    return _moodImageNames;
}


@end
