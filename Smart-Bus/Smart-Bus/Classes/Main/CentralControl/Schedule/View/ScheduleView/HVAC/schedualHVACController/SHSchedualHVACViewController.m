//
//  SHSchedualHVACViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSchedualHVACViewController.h"

@interface SHSchedualHVACViewController ()

/// 分组视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupViewHeightConstraint;

/// 按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonWidthConstraint;

// MARK ==============
    
/// 使用摄氏温度
@property (assign, nonatomic) BOOL isCelsius;

/// 空高开关的按钮
@property (weak, nonatomic) IBOutlet UIButton *turnAcButton;

/// 模式温度
@property (weak, nonatomic) IBOutlet UILabel *modelTemperatureLabel;

// MARK: - 功能控制部分

// MARK: -

// 风速控制

/// 风速指示
@property (weak, nonatomic) IBOutlet UIImageView *fanImageView;

/// 低风速
@property (weak, nonatomic) IBOutlet SHCommandButton *lowFanButton;

/// 中风速
@property (weak, nonatomic) IBOutlet SHCommandButton *middleFanButton;

/// 高风速
@property (weak, nonatomic) IBOutlet SHCommandButton *highFanButton;

/// 自动风速
@property (weak, nonatomic) IBOutlet SHCommandButton *autoFanButton;

// MARk: -

// 控制模式

/// 工作模式图片
@property (weak, nonatomic) IBOutlet UIImageView *modelImageView;

/// 制冷模式
@property (weak, nonatomic) IBOutlet SHCommandButton *coldModelButton;

/// 通风模式
@property (weak, nonatomic) IBOutlet SHCommandButton *fanModelButton;

/// 制热模式
@property (weak, nonatomic) IBOutlet SHCommandButton *hotModelButton;

/// 自动模式
@property (weak, nonatomic) IBOutlet SHCommandButton *autoModelButton;

/// 增加温度按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *upTemperatureButton;

/// 减小温度按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *lowerTemperatureButton;

@end

@implementation SHSchedualHVACViewController
    
// MARK: - 解析

- (void)analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    if ((socketData.subNetID != self.schedualHVAC.subnetID) || (socketData.deviceID != self.schedualHVAC.deviceID)) {
        return;
    }
    
    NSUInteger count = socketData.additionalData.count;
    Byte recivedData[count];
    
    for (int i = 0; i < count; i++) {
        
        recivedData[i] =
        ([socketData.additionalData[i] integerValue]) & 0xFF;
    }
    
    switch (socketData.operatorCode) {
            
            // 获得温度单位
        case 0xE121: {
            
            // 获得温度单位 是否为摄氏温度
            BOOL isCelsiusFlag = (recivedData[0] == 0);
            
            self.isCelsius = isCelsiusFlag;
        }
            
            break;
            
            // 获得不同模式的温度范围
        case 0x1901: {
            
            // 说明：由于协议中没有与温度传感器正负，而是使用了补码的方式来表示
            
            // 制冷温度范围
            self.schedualHVAC.startCoolTemperatureRange =
                [SHHVAC realTemperature:recivedData[0]];
            
            self.schedualHVAC.endCoolTemperatureRange =
                [SHHVAC realTemperature:recivedData[1]];
            
            // 制热温度范围
            self.schedualHVAC.startHeatTemperatureRange =
                [SHHVAC realTemperature:recivedData[2]];
            
            self.schedualHVAC.endHeatTemperatureRange =
                [SHHVAC realTemperature:recivedData[3]];
            
            // 自动模式温度范围
            self.schedualHVAC.startAutoTemperatureRange =
                [SHHVAC realTemperature:recivedData[4]];
            
            self.schedualHVAC.endAutoTemperatureRange =
                [SHHVAC realTemperature:recivedData[5]];
        }
            
            break;
            
        default:
            break;
    }
}
    

    // MARK: - 控制
    
    /// 增加温度
- (IBAction)upTemperature {
    
    // 获得当前温度值
    NSRange range = [self.modelTemperatureLabel.text rangeOfString:@"°"];
    
    if (range.location == NSNotFound) {
        return;
    }
    
    NSInteger temperature =  [[self.modelTemperatureLabel.text substringToIndex:range.location] integerValue];
    
    ++temperature;
    
    [self changeModelTemperature:temperature];
}
    
    /// 降低温度
- (IBAction)lowerTemperature {
    
    NSRange range = [self.modelTemperatureLabel.text rangeOfString:@"°"];
    
    if (range.location == NSNotFound) {
        return;
    }
    
    NSInteger temperature =  [[self.modelTemperatureLabel.text substringToIndex:range.location] integerValue];
    
    --temperature;
    
    [self changeModelTemperature:temperature];
}
    
    
    /// 修改模式温度
- (void)changeModelTemperature:(NSInteger)temperature {
   
    switch (self.schedualHVAC.schedualMode) {
        
        case SHAirConditioningModeTypeHeat: {
            
            if (temperature < self.schedualHVAC.startHeatTemperatureRange || temperature > self.schedualHVAC.endHeatTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
        }
            break;
            
        case SHAirConditioningModeTypeFan:
        case SHAirConditioningModeTypeCool: {
            
            if (temperature < self.schedualHVAC.startCoolTemperatureRange || temperature > self.schedualHVAC.endCoolTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
        }
            break;
            
        case SHAirConditioningModeTypeAuto: {
            
            if (temperature < self.schedualHVAC.startAutoTemperatureRange || temperature > self.schedualHVAC.endAutoTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
        }
            break;
            
        default:
            break;
    }
    
    // 显示温度
    self.modelTemperatureLabel.text =
        [NSString stringWithFormat:@"%@%@",
        @(temperature) ,self.isCelsius ? @"°C" : @"°F"];
}
    
    /// 低风速
- (IBAction)lowFanButtonClick {
    
    [self changeHVACFanSpeed:self.lowFanButton Value:SHAirConditioningFanSpeedTypeLow];
}
    
    /// 中风速
- (IBAction)middleFanButtonClick {
    
    [self changeHVACFanSpeed:self.middleFanButton Value:SHAirConditioningFanSpeedTypeMedial];
}
    
    /// 高风速
- (IBAction)highFanButtonClick {
    
    [self changeHVACFanSpeed:self.highFanButton Value:SHAirConditioningFanSpeedTypeHigh];
}
    
    /// 自动风速
- (IBAction)autoFanButtonClick {
    
    [self changeHVACFanSpeed:self.autoFanButton Value:SHAirConditioningFanSpeedTypeAuto];
}

/// 控制HVAC的风速
- (void)changeHVACFanSpeed:(UIButton *)selectModelButton Value:(Byte)fanSpeed {
    
    self.schedualHVAC.schedualFanSpeed = fanSpeed;
    
    self.middleFanButton.selected = NO;
    self.lowFanButton.selected = NO;
    self.highFanButton.selected = NO;
    self.autoFanButton.selected = NO;
    
    // 选中的按钮
    selectModelButton.selected = YES;

    switch (fanSpeed) {
        
        case SHAirConditioningFanSpeedTypeAuto: {
            
            self.fanImageView.image = [UIImage imageNamed:@"autofan"];
        }
        break;
        
        case SHAirConditioningFanSpeedTypeHigh: {
            
            self.fanImageView.image = [UIImage imageNamed:@"highfan"];
        }
        break;
        
        case SHAirConditioningFanSpeedTypeMedial: {
            
            self.fanImageView.image = [UIImage imageNamed:@"mediumfan"];
        }
        break;
        
        case SHAirConditioningFanSpeedTypeLow: {
            
            self.fanImageView.image = [UIImage imageNamed:@"lowfan"];
        }
        break;
        
        default:
        break;
    }
}
    
    /// 制冷模式
- (IBAction)coldModelButtonClick {
    
    [self controlHVACSelectButton:self.coldModelButton acModeValue:SHAirConditioningModeTypeCool setTempertureKind:SHAirConditioningControlTypeCoolTemperatureSet temperture:self.schedualHVAC.coolTemperture];
}
    
    /// 通风模式
- (IBAction)fanModelButtonClick {
    
    [self controlHVACSelectButton:self.fanModelButton acModeValue:SHAirConditioningModeTypeFan setTempertureKind:SHAirConditioningControlTypeCoolTemperatureSet temperture:self.schedualHVAC.coolTemperture];
}
    
    /// 制热模式
- (IBAction)hotModelButtonClick {
    
    [self controlHVACSelectButton:self.hotModelButton acModeValue:SHAirConditioningModeTypeHeat setTempertureKind:SHAirConditioningControlTypeHeatTemperatureSet temperture:self.schedualHVAC.heatTemperture];
}
    
    /// 自动控制模式
- (IBAction)autoModelButtonClick {
    
    [self controlHVACSelectButton:self.autoModelButton acModeValue:SHAirConditioningModeTypeAuto setTempertureKind:SHAirConditioningControlTypeAutoTemperatureSet temperture:self.schedualHVAC.autoTemperture];
}
    
    
/// 快速控制空调
- (void)controlHVACSelectButton:(UIButton *)selectModelButton acModeValue:(SHAirConditioningModeType)modeKind setTempertureKind:(Byte)tempertureKind temperture:(Byte )temperature {
    
    self.upTemperatureButton.enabled = YES;
    self.lowerTemperatureButton.enabled = YES;
    
    self.autoModelButton.selected = NO;
    self.coldModelButton.selected = NO;
    self.hotModelButton.selected = NO;
    self.fanModelButton.selected = NO;
    
    // 选中的按钮
    selectModelButton.selected = YES;
    self.schedualHVAC.schedualMode = modeKind;
    
    NSString *unit = self.isCelsius ? @"°C" : @"°F";
    
    switch (modeKind) {
        
        case SHAirConditioningModeTypeCool: {
            
            self.modelTemperatureLabel.text =
                [NSString stringWithFormat:@"%@%@",
                    @(self.schedualHVAC.coolTemperture), unit
                ];
            
            self.modelImageView.image = [UIImage imageNamed:@"coolModel"];
        }
        break;
        
        case SHAirConditioningModeTypeHeat: {
            
            self.modelTemperatureLabel.text =
                [NSString stringWithFormat:@"%@%@",
                    @(self.schedualHVAC.heatTemperture), unit
                ];
            
            self.modelImageView.image = [UIImage imageNamed:@"heatModel"];
        }
        break;
        
        case SHAirConditioningModeTypeFan: {
            
            self.modelTemperatureLabel.text =
                [NSString stringWithFormat:@"%@%@",
                    @(self.schedualHVAC.coolTemperture), unit
                ];
            
            self.modelImageView.image = [UIImage imageNamed:@"fanModel"];
        }
        break;
        
        case SHAirConditioningModeTypeAuto: {
            
            self.modelTemperatureLabel.text =
                [NSString stringWithFormat:@"%@%@",
                    @(self.schedualHVAC.autoTemperture), unit
                ];
            
            self.modelImageView.image = [UIImage imageNamed:@"autoModel"];
        }
        break;
        
        default:
        break;
    }
}
    
    /// 开关空调
- (IBAction)turnOnAndOffHVAC{
    
    self.turnAcButton.selected = !self.turnAcButton.selected;
    
    self.schedualHVAC.schedualIsTurnOn = self.turnAcButton.selected;
}
    
    /// 读取状态
- (void)readDevicesStatus {
    
    // 1.读取温度单位
    [SHSocketTools sendDataWithOperatorCode:0xE120 subNetID:self.schedualHVAC.subnetID deviceID:self.schedualHVAC.deviceID additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:false isDMX:false];
    
    [NSThread sleepForTimeInterval:0.05];
    
    // 2.读取空调的温度范围
    [SHSocketTools sendDataWithOperatorCode:0x1900 subNetID:self.schedualHVAC.subnetID deviceID:self.schedualHVAC.deviceID additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:false isDMX:false];
}
    
    /// 关闭界面
- (void)close {
    
    // 模式温度必须是最后离开时显示的哪个
    NSRange range = [self.modelTemperatureLabel.text rangeOfString:@"°"];
    
    if (range.location == NSNotFound) {
        return;
    }
    
    NSInteger temperature =  [[self.modelTemperatureLabel.text substringToIndex:range.location] integerValue];
    
    self.schedualHVAC.schedualTemperature = temperature;
    
    [self dismissViewControllerAnimated:YES
                             completion:nil
    ];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.groupViewHeightConstraint.constant = tabBarHeight + tabBarHeight;
        
        self.controlButtonWidthConstraint.constant = navigationBarHeight + statusBarHeight;
        self.controlButtonHeightConstraint.constant = navigationBarHeight + statusBarHeight;
    
    } else if ([UIDevice is3_5inch] || [UIDevice is4_0inch]) {
    
        self.groupViewHeightConstraint.constant = navigationBarHeight;
        self.controlButtonHeightConstraint.constant = tabBarHeight;
        self.controlButtonWidthConstraint.constant = tabBarHeight;
        
    }
}
    
/// 配置空调只获得有关操作的数据，其它数据一律不要
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self readDevicesStatus];
}
    
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if (!self.schedualHVAC.schedualEnable) {
        return ;
    }
    
    // 设置默认值
    self.turnAcButton.selected = self.schedualHVAC.schedualIsTurnOn;
    
    // 设置风速
    switch (self.schedualHVAC.schedualFanSpeed) {
        
        case SHAirConditioningFanSpeedTypeAuto: {
            
            [self changeHVACFanSpeed:self.autoFanButton Value:SHAirConditioningFanSpeedTypeAuto];
        }
        break;
        
        case SHAirConditioningFanSpeedTypeHigh: {
            
            [self changeHVACFanSpeed:self.highFanButton Value:SHAirConditioningFanSpeedTypeHigh];
        }
        break;
        
        case SHAirConditioningFanSpeedTypeMedial: {
            
            [self changeHVACFanSpeed:self.middleFanButton Value:SHAirConditioningFanSpeedTypeMedial];
        }
        break;
        
        case SHAirConditioningFanSpeedTypeLow: {
            
            [self changeHVACFanSpeed:self.lowFanButton Value:SHAirConditioningFanSpeedTypeLow];
        }
        break;
        
        default:
        break;
    }
    
    // 设置模式
    switch (self.schedualHVAC.schedualMode) {
        
        case SHAirConditioningModeTypeCool: {
        
            [self controlHVACSelectButton:self.coldModelButton acModeValue:SHAirConditioningModeTypeCool setTempertureKind:SHAirConditioningControlTypeCoolTemperatureSet temperture:self.schedualHVAC.schedualTemperature];
        }
        break;
        
        case SHAirConditioningModeTypeHeat: {
            
            [self controlHVACSelectButton:self.hotModelButton acModeValue:SHAirConditioningModeTypeHeat setTempertureKind:SHAirConditioningControlTypeHeatTemperatureSet temperture:self.schedualHVAC.schedualTemperature];
        }
        
        break;
        
        case SHAirConditioningModeTypeFan: {
            
            [self controlHVACSelectButton:self.fanModelButton acModeValue:SHAirConditioningModeTypeFan setTempertureKind:SHAirConditioningControlTypeCoolTemperatureSet temperture:self.schedualHVAC.schedualTemperature];
        }
        break;
        
        case SHAirConditioningModeTypeAuto: {
            
            [self controlHVACSelectButton:self.autoModelButton acModeValue:SHAirConditioningModeTypeAuto setTempertureKind:SHAirConditioningControlTypeAutoTemperatureSet temperture:self.schedualHVAC.schedualTemperature];
        }
        break;
        
        default:
        break;
    }
    
    // 设置模式温度
    self.modelTemperatureLabel.text = [NSString stringWithFormat:@"%tu%@", self.schedualHVAC.schedualTemperature ,self.isCelsius ? @"°C" : @"°F"];
    
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isCelsius = YES;
  
    self.navigationItem.title = @"Schedule HVAC";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"close" hightlightedImageName:@"close" addTarget:self action:@selector(close) isLeft:YES];
  
   
    [self.lowFanButton setTitle:
     [SHHVAC getFanSpeedName:SHAirConditioningFanSpeedTypeLow]
                       forState:UIControlStateNormal];
    
    [self.middleFanButton setTitle:[SHHVAC getFanSpeedName:SHAirConditioningFanSpeedTypeMedial] forState:UIControlStateNormal];
    
    [self.highFanButton setTitle:[SHHVAC getFanSpeedName:SHAirConditioningFanSpeedTypeHigh] forState:UIControlStateNormal];
    
    [self.autoFanButton setTitle:
     [SHHVAC getFanSpeedName:SHAirConditioningFanSpeedTypeAuto]
                        forState:UIControlStateNormal];
    
    // 模式控制
    
    [self.coldModelButton setTitle:
     [SHHVAC getModeName:SHAirConditioningModeTypeCool]
                          forState:UIControlStateNormal];
    
    [self.hotModelButton setTitle:
     [SHHVAC getModeName:SHAirConditioningModeTypeHeat]
                         forState:UIControlStateNormal];
    
    [self.fanModelButton setTitle:[SHHVAC getModeName:SHAirConditioningModeTypeFan] forState:UIControlStateNormal];
    
    [self.autoModelButton setTitle:
     [SHHVAC getModeName:SHAirConditioningModeTypeAuto]
                          forState:UIControlStateNormal];
    
    self.upTemperatureButton.enabled = NO;
    self.lowerTemperatureButton.enabled = NO;
    
    [self.turnAcButton setRoundedRectangleBorder];
    
    [self.upTemperatureButton setRoundedRectangleBorder];
    [self.lowerTemperatureButton setRoundedRectangleBorder];
    
    [self.lowFanButton setRoundedRectangleBorder];
    [self.middleFanButton setRoundedRectangleBorder];
    [self.highFanButton setRoundedRectangleBorder];
    [self.autoFanButton setRoundedRectangleBorder];
    
    [self.coldModelButton setRoundedRectangleBorder];
    [self.hotModelButton setRoundedRectangleBorder];
    [self.fanModelButton setRoundedRectangleBorder];
    [self.autoModelButton setRoundedRectangleBorder];
    
    if ([UIDevice is_iPad]) {
        
        self.modelTemperatureLabel.font = [UIView suitLargerFontForPad];
    }
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
@end
