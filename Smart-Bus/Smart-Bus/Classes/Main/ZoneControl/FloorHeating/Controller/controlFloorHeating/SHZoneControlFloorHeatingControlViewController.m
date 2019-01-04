//
//  SHZoneControlFloorHeatingViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/7.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHZoneControlFloorHeatingControlViewController.h"
 

@interface SHZoneControlFloorHeatingControlViewController ()

// MARK: - 约束条件

/// 顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

/// pickerView的顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerViewTopConstraint;

/// 分组基准高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupViewHeightConstraint;

/// 控制按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonHeightConstraint;

/// 控制按钮的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonWidthConstraint;

// MARK: - UI属性

/// 显示显示View
@property (weak, nonatomic) IBOutlet UIView *temperatureView;

/// 室内温度边框
@property (weak, nonatomic) IBOutlet UIImageView *indoorTemperatureBorderView;

/// 室外温度边框
@property (weak, nonatomic) IBOutlet UIImageView *outdoorTemperatureBorderView;

/// 开关地热
@property (weak, nonatomic) IBOutlet UIButton *turnFloorHeatingButton;

/// 室内温度
@property (weak, nonatomic) IBOutlet UILabel *indoorTemperatureLabel;

/// 室外温度
@property (weak, nonatomic) IBOutlet UILabel *outdoorTemperatureLabel;

/// 增加温度按钮
@property (weak, nonatomic) IBOutlet UIButton *addTemperatureButton;

/// 降低温度按钮
@property (weak, nonatomic) IBOutlet UIButton *reduceTemperatureButton;

/// 模式温度
@property (weak, nonatomic) IBOutlet UILabel *modelTemperatureLabel;

/// 控制面板
@property (weak, nonatomic) IBOutlet UIView *controlView;

/// 手动模式按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *manualButton;

/// 白天模式按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *dayButton;

/// 夜间模式
@property (weak, nonatomic) IBOutlet SHCommandButton *nightButton;

/// 离开模式按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *awayButton;

/// 定时器模式按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *timerButton;


/// 白天开始时间
@property (weak, nonatomic) IBOutlet UIButton *dayTimeButton;

/// 白天结束时间
@property (weak, nonatomic) IBOutlet UIButton *nightTimeButton;

/// 日期选择
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

/// 选择的按钮
@property (strong, nonatomic) UIButton *selecTimeButton;

/// 设置过传感器温度
@property (assign, nonatomic) BOOL isSetSensorTemperature;

@end

@implementation SHZoneControlFloorHeatingControlViewController

// MARK: - 响应数据

- (void)analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    NSUInteger count = socketData.additionalData.count;
    Byte recivedData[count];
    
    for (int i = 0; i < count; i++) {
        
        recivedData[i] =
        ([socketData.additionalData[i] integerValue]) & 0xFF;
    }
    
    switch (socketData.operatorCode) {
            
        case 0xEFFF: {
        }
            break;
            
            // 地热操作
        case 0xE3D9: {
            
            if ((socketData.subNetID != self.currentFloorHeating.subnetID) ||
                
                (socketData.deviceID != self.currentFloorHeating.deviceID) ||
                
                (recivedData[2] != self.currentFloorHeating.channelNo)) {
                
                return;
            }
            
            Byte operatorKind = recivedData[0];
            
            Byte operatorResult = recivedData[1];
            
            switch (operatorKind) {
                    
                case SHFloorHeatingControlTypeOnAndOff: {
                    
                    self.currentFloorHeating.isTurnOn = operatorResult;
                }
                    break;
                    
                    
                case SHFloorHeatingControlTypeModelSet: {
                    
                    self.currentFloorHeating.floorHeatingModeType = operatorResult;
                }
                    break;
                    
                    
                case SHFloorHeatingControlTypeTemperatureSet: {
                    
                    self.currentFloorHeating.manualTemperature = operatorResult;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
            // 获得模式温度与传感器的地址
        case 0x03C8: {
            
            if ((socketData.subNetID != self.currentFloorHeating.subnetID) ||
                
                (socketData.deviceID != self.currentFloorHeating.deviceID) ||
                
                (recivedData[0] != self.currentFloorHeating.channelNo) ) {
                
                return;
            }
            
            // 获得每个模式下的温度
            self.currentFloorHeating.manualTemperature =
                recivedData[1];
            
            self.currentFloorHeating.dayTemperature =
                recivedData[3];
            
            self.currentFloorHeating.nightTemperature =
                recivedData[5];
            
            self.currentFloorHeating.awayTemperature =
                recivedData[7];
            
            // 传感器的地址
            self.currentFloorHeating.insideSensorSubNetID =
                recivedData[9];
            
            self.currentFloorHeating.insideSensorDeviceID =
                recivedData[10];
            
            self.currentFloorHeating.insideSensorChannelNo =
                recivedData[11];
            
            // 读取温度
            [SHSocketTools
             sendDataWithOperatorCode:0xE3E7 subNetID:self.currentFloorHeating.insideSensorSubNetID
             deviceID:self.currentFloorHeating.insideSensorDeviceID
             additionalData:@[@1] remoteMacAddress:SHSocketTools.remoteControlMacAddress
             needReSend:false
             isDMX:false];
            
        }
            break;
            
        case 0x03CA: { // 设置定时器的时间
            
            if ((socketData.subNetID != self.currentFloorHeating.subnetID) ||
                
                (socketData.deviceID != self.currentFloorHeating.deviceID) ) {
                return;
            }
            
            // 读取一下值就可以了 读取定时器模式下的开始与结束时间
            [SHSocketTools sendDataWithOperatorCode:0x03CB subNetID:self.currentFloorHeating.subnetID deviceID:self.currentFloorHeating.deviceID additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:false isDMX:false];
        }
            break;
            
            // 获得定时器模式下的开始与结束时间
        case 0x03CC: {
            
            if ((socketData.subNetID != self.currentFloorHeating.subnetID) ||
                
                (socketData.deviceID != self.currentFloorHeating.deviceID) ) {
                
                return;
            }
            
            // 白天运行的开始时间
            self.currentFloorHeating.dayTimeHour =
                recivedData[0];
            self.currentFloorHeating.dayTimeMinute =
                recivedData[1];
            
            // 白天运行的结束时间
            self.currentFloorHeating.nightTimeHour =
                recivedData[2];
            self.currentFloorHeating.nightTimeMinute =
                recivedData[3];
            
        }
            break;
            
        case 0xE3DB: { // 获得开关状态
            
            if ((socketData.subNetID != self.currentFloorHeating.subnetID) ||
                
                (socketData.deviceID != self.currentFloorHeating.deviceID) ||
                
                (recivedData[2] != self.currentFloorHeating.channelNo) ) {
                
                return;
            }
            
            Byte operatorKind = recivedData[0];
            Byte operatorResult = recivedData[1];
            
            switch (operatorKind) {
                    
                case SHFloorHeatingControlTypeOnAndOff: {
                    
                    self.currentFloorHeating.isTurnOn = operatorResult;
                }
                    break;
                    
                case SHFloorHeatingControlTypeModelSet: {
                    
                    self.currentFloorHeating.floorHeatingModeType = operatorResult;
                }
                    break;
                    
                default:
                    break;
            }
        }
            
        case 0xE3E8: { // 温度传感器 与 地热本身没有什么关系
            
            // 返回摄氏温度有效
            if (!recivedData[0]) {
                return;
            }
            
            // 室内温度 // 0:+ / 1:-
            if (socketData.subNetID == self.currentFloorHeating.insideSensorSubNetID &&
                
                socketData.deviceID == self.currentFloorHeating.insideSensorDeviceID) {
                
                self.currentFloorHeating.insideTemperature =
                recivedData[0 +
                            self.currentFloorHeating.insideSensorChannelNo + 8] ?
                (0 - recivedData[0 +
                                 self.currentFloorHeating.insideSensorChannelNo]) :
                recivedData[0 +
                            self.currentFloorHeating.insideSensorChannelNo];
            }
            
            // 室外温度 // 0:+ / 1:-
            if (socketData.subNetID == self.currentFloorHeating.outsideSensorSubNetID &&
                
                socketData.deviceID == self.currentFloorHeating.outsideSensorDeviceID) {
                
                self.currentFloorHeating.outsideTemperature = recivedData[0 + self.currentFloorHeating.outsideSensorChannelNo + 8] ? (0 - recivedData[0 + self.currentFloorHeating.outsideSensorChannelNo]) :
                
                recivedData[0 + self.currentFloorHeating.outsideSensorChannelNo];
            }
            
            self.isSetSensorTemperature = YES;
        }
            break;
            
        default:
            break;
    }
    
    // 设置UI
    if (socketData.operatorCode == 0xE3D9 ||
        socketData.operatorCode == 0xE3DB ||
        socketData.operatorCode == 0x03CC ||
        socketData.operatorCode == 0x03C8 ||
        socketData.operatorCode == 0xE3E8) {
        
        [self setFloorHeatingStatus];
    }
} 

// MARK: - 点击响应事件


/// 选择日期
- (IBAction)selectDate {
    
    NSString *timeString =
    [NSString stringWithFormat:@"%02tu:%02tu",
        [NSDate getCurrentDateComponentsFrom:self.datePicker.date].hour,
        [NSDate getCurrentDateComponentsFrom:self.datePicker.date].minute];
    
    [self.selecTimeButton setTitle:timeString forState:UIControlStateNormal];
}

- (IBAction)dayTimeButtonClick {
    
    if (self.selecTimeButton != self.dayTimeButton) {
        
        self.selecTimeButton.selected = NO;
    }
    
    self.dayTimeButton.selected = !self.dayTimeButton.selected;
    
    self.dayTimeButton.selected ? [self showDatePicker] : [self hidenDatePicker];
    
    if (self.dayTimeButton.selected) {
        
        self.selecTimeButton = self.dayTimeButton;
    }
}

/// 白天结束时间
- (IBAction)nightTimeButtonClick {
    
    if (self.selecTimeButton != self.nightTimeButton) {
        
        self.selecTimeButton.selected = NO;
    }
    
    self.nightTimeButton.selected = !self.nightTimeButton.selected;
    
    self.nightTimeButton.selected ? [self showDatePicker] : [self hidenDatePicker];
    
    if (self.nightTimeButton.selected) {
        
        self.selecTimeButton = self.nightTimeButton;
    }
    
}

/// 显示日期选择器
- (void)showDatePicker {
 
    CGFloat scale = [UIDevice is_iPad] ? 1.8 : 1.3;
    CGFloat moveMarign = pickerViewHeight * scale;
    
    if (self.topConstraint.constant >= 0) {
        
        if (CGAffineTransformEqualToTransform(self.datePicker.transform, CGAffineTransformIdentity)) {
            self.datePicker.transform = CGAffineTransformMakeScale(scale, scale);
        }
        
        self.topConstraint.constant -= moveMarign;
        self.datePickerViewTopConstraint.constant -= moveMarign;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
}


/// 隐藏日期选择器
- (void)hidenDatePicker {
 
    CGFloat scale = [UIDevice is_iPad] ? 1.8 : 1.3;
    CGFloat moveMarign = pickerViewHeight * scale;
    
    if (self.topConstraint.constant < 0) {
        
        self.selecTimeButton = nil;
        self.topConstraint.constant += moveMarign;
        self.datePickerViewTopConstraint.constant += moveMarign;
        
        self.datePicker.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"SYSTEM_PROMPT"] message:@"Is the update time determined ?" isCustom:YES];
    
    [alertView addAction: [TYAlertAction actionWithTitle:SHLanguageText.no style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
        // 读取定时器模式下的开始与结束时间
        [SHSocketTools sendDataWithOperatorCode:0x03CB subNetID:self.currentFloorHeating.subnetID deviceID:self.currentFloorHeating.deviceID additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:false isDMX:false];
        
    }] ];
    
    [alertView addAction:[TYAlertAction  actionWithTitle:SHLanguageText.yes style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        // 获得设置好的时间
        Byte updatedayTimeHour = [[[self.dayTimeButton.currentTitle componentsSeparatedByString:@":"] firstObject] integerValue];
        
        Byte updatedayTimeMinute = [[[self.dayTimeButton.currentTitle componentsSeparatedByString:@":"] lastObject] integerValue];
        
        Byte updateNightTimeHour = [[[self.nightTimeButton.currentTitle componentsSeparatedByString:@":"] firstObject] integerValue];
        
        Byte updateNightTimeMinute = [[[self.nightTimeButton.currentTitle componentsSeparatedByString:@":"] lastObject] integerValue];
        
        
        NSArray *time = @[@(updatedayTimeHour), @(updatedayTimeMinute),
                          @(updateNightTimeHour), @(updateNightTimeMinute)];
        
        [SHSocketTools sendDataWithOperatorCode:0x03C9
                                       subNetID:self.currentFloorHeating.subnetID
                                       deviceID:self.currentFloorHeating.deviceID
                                 additionalData:time
                               remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                     needReSend:true
                                          isDMX:false
        ];
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    alertController.backgoundTapDismissEnable = YES;
    
    [self presentViewController:alertController animated:YES completion:nil];
}


/// 降低温度按钮
- (IBAction)reduceTemperatureButtonClick {
    
    if (self.currentFloorHeating.floorHeatingModeType !=
        SHFloorHeatingModeTypeManual) {
        return;
    }
    
    // 5 ~ 32度
    
    Byte temperature = self.currentFloorHeating.manualTemperature - 1;
    
    if (temperature < SHFloorHeatingManualTemperatureRangeCentigradeMinimumValue || temperature > SHFloorHeatingManualTemperatureRangeCentigradeMaximumValue) {
        
        [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
        
        return;
    }
    
    NSArray *temperatureData = @[@(SHFloorHeatingControlTypeTemperatureSet),
                                 @(temperature),
                                 @(self.currentFloorHeating.channelNo)
                             ];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:self.currentFloorHeating.subnetID
                                   deviceID:self.currentFloorHeating.deviceID
                             additionalData:temperatureData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
}


/// 增加地热温度
- (IBAction)addTemperatureButtonClick {
    
    if (self.currentFloorHeating.floorHeatingModeType !=
        SHFloorHeatingModeTypeManual) {
        return;
    }
    
    // 5 ~ 32度
    
    Byte temperature = self.currentFloorHeating.manualTemperature + 1;
    
    if (temperature < SHFloorHeatingManualTemperatureRangeCentigradeMinimumValue
        || temperature > SHFloorHeatingManualTemperatureRangeCentigradeMaximumValue) {
        
        [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
        
        return;
    }
    
    NSArray *temperatureData = @[@(SHFloorHeatingControlTypeTemperatureSet),
                                 @(temperature),
                                 @(self.currentFloorHeating.channelNo)
                                 ];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:self.currentFloorHeating.subnetID
                                   deviceID:self.currentFloorHeating.deviceID
                             additionalData:temperatureData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
}


/// 地热的开启与关闭
- (IBAction)turnOnButtonClick {
    
    NSArray *onOff = @[@(SHFloorHeatingControlTypeOnAndOff),
                       @(!self.currentFloorHeating.isTurnOn),
                       @(self.currentFloorHeating.channelNo)
                    ];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:self.currentFloorHeating.subnetID
                                   deviceID:self.currentFloorHeating.deviceID
                             additionalData:onOff
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
}

/// 点击手动模式
- (IBAction)manualButtonClick {
    
    [self changeFloorHeatingModel:SHFloorHeatingModeTypeManual];
}

/// 点击白天模式
- (IBAction)dayButtonClick {
    
    [self changeFloorHeatingModel:SHFloorHeatingModeTypeDay];
}

/// 点击夜间模式
- (IBAction)nightButtonClick {
    
    [self changeFloorHeatingModel:SHFloorHeatingModeTypeNight];
}

/// 点击离开模式
- (IBAction)awayButtonClick {
    
    [self changeFloorHeatingModel:SHFloorHeatingModeTypeAway];
}

/// 进入闹钟(定时器)模式
- (IBAction)alarmButtonClick {
    
    [self changeFloorHeatingModel:SHFloorHeatingModeTypeTimer];
}



/**
 切换地热的模式

 @param model 模式值
 */
- (void)changeFloorHeatingModel:(SHFloorHeatingModeType)model {
   
    NSArray *modelData = @[@(SHFloorHeatingControlTypeModelSet),
                       @(model),
                       @(self.currentFloorHeating.channelNo)
                       ];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:self.currentFloorHeating.subnetID
                                   deviceID:self.currentFloorHeating.deviceID
                             additionalData:modelData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
}

// MARK: - 设置与读取状态

/// 设置地热的状态
- (void)setFloorHeatingStatus {
    
    // 1.设置显示开关
    self.controlView.hidden = !self.currentFloorHeating.isTurnOn;
    
    self.turnFloorHeatingButton.selected = self.currentFloorHeating.isTurnOn;
    
    // 2.不同的模式温度
    switch (self.currentFloorHeating.floorHeatingModeType) {
      
        case SHFloorHeatingModeTypeManual: {
         
            self.modelTemperatureLabel.text =
            [NSString stringWithFormat:@"%@ °C\n%@ °F",
                 @(self.currentFloorHeating.manualTemperature),
                 @([SHHVAC centigradeConvertToFahrenheit:
                              self.currentFloorHeating.manualTemperature])];
        }
            
            break;
    
        case SHFloorHeatingModeTypeDay: {
            
            self.modelTemperatureLabel.text =
                [NSString stringWithFormat:@"%@ °C\n%@ °F",
                 @(self.currentFloorHeating.dayTemperature),
                 @([SHHVAC centigradeConvertToFahrenheit:
                               self.currentFloorHeating.dayTemperature])];
        }
            break;
    
        case SHFloorHeatingModeTypeNight: {
         
            self.modelTemperatureLabel.text =
                [NSString stringWithFormat:@"%@ °C\n%@ °F",
                 
                @(self.currentFloorHeating.nightTemperature),
                @([SHHVAC centigradeConvertToFahrenheit:
                             self.currentFloorHeating.nightTemperature])];
        }
            
            break;

        case SHFloorHeatingModeTypeAway: {
            
            self.modelTemperatureLabel.text =
            [NSString stringWithFormat:@"%@ °C\n%@ °F",     @(self.currentFloorHeating.awayTemperature),
                @([SHHVAC centigradeConvertToFahrenheit:
                             self.currentFloorHeating.awayTemperature])];
        }
            
            break;

        case SHFloorHeatingModeTypeTimer: {
            
            NSString *startTime = [NSString stringWithFormat:@"%02d:%02d", self.currentFloorHeating.dayTimeHour,
                self.currentFloorHeating.dayTimeMinute];
            
            NSString *nightTime = [NSString stringWithFormat:@"%02d:%02d", self.currentFloorHeating.nightTimeHour, self.currentFloorHeating.nightTimeMinute];
            
            if ([NSDate validateWithStartTime:startTime withExpireTime:nightTime]) {
                
                self.modelTemperatureLabel.text =
                    [NSString stringWithFormat:@"%@ °C\n%@ °F",
                        @(self.currentFloorHeating.dayTemperature),
                        @([SHHVAC centigradeConvertToFahrenheit:
                                 self.currentFloorHeating.dayTemperature])];
                
            } else {
                
                self.modelTemperatureLabel.text =
                    [NSString stringWithFormat:@"%@ °C\n%@ °F",
                     @(self.currentFloorHeating.nightTemperature),
                     @([SHHVAC centigradeConvertToFahrenheit:
                                  self.currentFloorHeating.nightTemperature])];
            }
        }
            break;
            
        default:
            break;
    }
    
 
    // 显示控制温度按钮
    self.reduceTemperatureButton.hidden =
        self.currentFloorHeating.floorHeatingModeType !=
        SHFloorHeatingModeTypeManual;
    
    self.addTemperatureButton.hidden =
        self.currentFloorHeating.floorHeatingModeType !=
        SHFloorHeatingModeTypeManual;
    
    // 显示当前模式
    self.manualButton.selected =
        self.currentFloorHeating.floorHeatingModeType ==
        SHFloorHeatingModeTypeManual;
    
    self.dayButton.selected =
        self.currentFloorHeating.floorHeatingModeType ==
        SHFloorHeatingModeTypeDay;
    
    self.nightButton.selected =
        self.currentFloorHeating.floorHeatingModeType ==
        SHFloorHeatingModeTypeNight;
    
    self.awayButton.selected =
        self.currentFloorHeating.floorHeatingModeType ==
        SHFloorHeatingModeTypeAway;
    
    self.timerButton.selected =
        self.currentFloorHeating.floorHeatingModeType ==
        SHFloorHeatingModeTypeTimer;
    
    // 4.设置定时器时间
    [self.dayTimeButton setTitle:[NSString stringWithFormat:@"%02d:%02d",
         self.currentFloorHeating.dayTimeHour,
         self.currentFloorHeating.dayTimeMinute]
                        forState:UIControlStateNormal];
    
    [self.nightTimeButton setTitle:[NSString stringWithFormat:@"%02d:%02d", self.currentFloorHeating.nightTimeHour,
        self.currentFloorHeating.nightTimeMinute]
                          forState:UIControlStateNormal];
    
    // 5.设置温度
  
    self.indoorTemperatureLabel.text = [NSString stringWithFormat:@"%@ °C\n%@ °F", @(self.currentFloorHeating.insideTemperature),
        @([SHHVAC centigradeConvertToFahrenheit:self.currentFloorHeating.insideTemperature])];
    
    if (self.currentFloorHeating.insideTemperature <= 0) {
        
        self.indoorTemperatureLabel.text = @"N/A";
    }
    
    self.outdoorTemperatureLabel.text = [NSString stringWithFormat:@"%@ °C\n%@ °F",
        @(self.currentFloorHeating.outsideTemperature),
                                         
        @([SHHVAC centigradeConvertToFahrenheit:self.currentFloorHeating.outsideTemperature])];
    
    if (!self.currentFloorHeating.outsideTemperature &&
        !self.isSetSensorTemperature) {
        
        self.outdoorTemperatureLabel.text = @"N/A";
    }
}

/// 读取状态
- (void)readDevicesStatus {
    
    // 读取定时器模式下的开始与结束时间
    [SHSocketTools sendDataWithOperatorCode:0x03CB
                                   subNetID:self.currentFloorHeating.subnetID
                                   deviceID:self.currentFloorHeating.deviceID
                             additionalData:@[]
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
    
    // 读取模式匹配温度与传感器的地址
    [SHSocketTools sendDataWithOperatorCode:0x03C7
                                   subNetID:self.currentFloorHeating.subnetID
                                   deviceID:self.currentFloorHeating.deviceID
                             additionalData:@[@(self.currentFloorHeating.channelNo)]
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
    
    // 读取室外温度 (读摄氏温度)
    [SHSocketTools sendDataWithOperatorCode:0xE3E7
                                   subNetID:self.currentFloorHeating.outsideSensorSubNetID
                                   deviceID:self.currentFloorHeating.outsideSensorDeviceID
                             additionalData:@[@(1)]
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
    
    // 读取开关状态
    NSArray *onOffStatus = @[@(SHFloorHeatingControlTypeOnAndOff),
                             @(self.currentFloorHeating.channelNo)];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3DA
                                   subNetID:self.currentFloorHeating.subnetID
                                   deviceID:self.currentFloorHeating.deviceID
                             additionalData:onOffStatus
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
    
    // 读取模式状态
    NSArray *modelStatus = @[@(SHFloorHeatingControlTypeModelSet),
                             @(self.currentFloorHeating.channelNo)];
    
    [SHSocketTools sendDataWithOperatorCode:0xE3DA
                                   subNetID:self.currentFloorHeating.subnetID
                                   deviceID:self.currentFloorHeating.deviceID
                             additionalData:modelStatus
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
}



// MARK: - UI初始化

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is3_5inch] || [UIDevice is4_0inch]) {
        
        self.groupViewHeightConstraint.constant = navigationBarHeight;
        self.controlButtonWidthConstraint.constant = tabBarHeight;
        self.controlButtonHeightConstraint.constant = tabBarHeight;
        
    } else if ([UIDevice is_iPad]) {
        
        self.groupViewHeightConstraint.constant =  self.isPortrait ? (navigationBarHeight + navigationBarHeight) : (tabBarHeight + tabBarHeight);
        
        self.controlButtonHeightConstraint.constant = self.isPortrait ? (navigationBarHeight + statusBarHeight) : (tabBarHeight + statusBarHeight);
        self.controlButtonWidthConstraint.constant = self.isPortrait ? (navigationBarHeight + statusBarHeight) : (tabBarHeight + statusBarHeight);
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setFloorHeatingStatus]; // 先设置默认状态再 读状态
    [self readDevicesStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.currentFloorHeating.floorHeatingRemark; // [NSString stringWithFormat:@"%@ : %zd - %zd - %zd", self.currentFloorHeating.floorHeatingRemark, self.currentFloorHeating.subnetID, self.currentFloorHeating.deviceID, self.currentFloorHeating.channelNo];
    
        self.controlView.hidden = YES;
    
    [self.datePicker setValue:[UIView textWhiteColor] forKey:@"textColor"];
//    self.datePicker.hidden = NO;
    
    [self.addTemperatureButton setRoundedRectangleBorder];
    [self.reduceTemperatureButton setRoundedRectangleBorder];
    [self.manualButton setRoundedRectangleBorder];
    [self.dayButton setRoundedRectangleBorder];
    [self.nightButton setRoundedRectangleBorder];
    [self.awayButton setRoundedRectangleBorder];
    [self.timerButton setRoundedRectangleBorder];
    [self.dayTimeButton setRoundedRectangleBorder];
    [self.nightTimeButton setRoundedRectangleBorder];
    
    
    if ([UIDevice is_iPad]) {
        
        self.outdoorTemperatureLabel.font = [UIView suitLargerFontForPad];
        self.indoorTemperatureLabel.font = [UIView suitLargerFontForPad];
        self.modelTemperatureLabel.font = [UIView suitLargerFontForPad];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
