//
//  SHZoneHVACViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/24.
//  Copyright © 2017年 Mark Liu. All rights reserved.
/*
 说明：模式与风速模式中
 1.HVAC控制的指令中，只有193B会显示实际值
 2.其它的操作指令只返回目标值
 
 E0ED中的模式坐标，只是模式/风速列表中的下标索引
 193B中的返回是真实的值和目标值 
 
 状态的显示
 快速按钮的状态的匹配
 没有返回时，再读取一次状态
 */

#import "SHZoneHVACControlViewController.h"

@interface SHZoneHVACControlViewController ()

// ============= 约束条件

/// 控制按钮的起始位置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonStartY;


/// 空调标志基准高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *acflagHeightConstraint;

/// 空调标志基准宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *acflagWidthConstraint;


/// 中间小图标宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlMiddleIconViewHeightConstraint;

/// 中间小图标宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlMiddleIconViewWidthConstraint;

/// 所有的空调按钮父视图的基础高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonSuperViewBaseHeightConstraint;

///// 所有的操作空调的按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonHeightConstraint;

// ==========================

/// 边框背景
@property (weak, nonatomic) IBOutlet UIImageView *actemborderImageView;

/// 空调的基本配置信息
@property (nonatomic, strong) SHHVACSetUpInfo *havcSetUpInfo;

/// 空高开关的安钮
@property (weak, nonatomic) IBOutlet UIButton *turnAcButton;

/// 控制空调的显示视图
@property (weak, nonatomic) IBOutlet UIView *controlView;

// MARK: - 温度

/// 显示显示占位区域
@property (weak, nonatomic) IBOutlet UIView *temperatureView;

/// 当前温度
@property (weak, nonatomic) IBOutlet UILabel *currentTempertureLabel;

/// 模式温度
@property (weak, nonatomic) IBOutlet UILabel *modelTemperatureLabel;

// MARK: - 功能控制部分

// MARK: -

/// 增加温度按钮
@property (weak, nonatomic) IBOutlet UIButton *addTemperatureButton;

/// 降低温度按钮
@property (weak, nonatomic) IBOutlet UIButton *reduceTemperatureButton;

/// 风速指示
@property (weak, nonatomic) IBOutlet UIImageView *fanImageView;

/// 风速指示按钮数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *fanSppedButtons;

/// 风速图征名称
@property (strong, nonatomic) NSArray* fanSpeedImageName;

/// 模式图片名称
@property (strong, nonatomic) NSArray* acModelImageName;

// MARk: -

// 控制模式

/// 工作模式图片
@property (weak, nonatomic) IBOutlet UIImageView *modelImageView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *acModelButtons;

// MARK: -

// 快速控制

/// 快速制冷
@property (weak, nonatomic) IBOutlet UIButton *coldFastControlButton;

/// 快速凉快
@property (weak, nonatomic) IBOutlet UIButton *coolFastControlButton;

/// 快速暖和
@property (weak, nonatomic) IBOutlet UIButton *warmFastControlButton;

/// 快速制热
@property (weak, nonatomic) IBOutlet UIButton *hotFastControlButton;

// MARK: - 有交模式

/// 有效的 fanModel
@property (strong, nonatomic) NSMutableArray *fanSpeedList;

/// 有效的 acModel
@property (strong, nonatomic) NSMutableArray *acModelList;

/// 红外控制
@property (assign, nonatomic) BOOL isIREmitter;

/// 红外控制空调的的所有设备
@property (strong, nonatomic) NSArray *iREmitterControlACDevices;

@end

@implementation SHZoneHVACControlViewController

// MARK: - 解析

/// 收到广播数据
- (void)analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    NSUInteger count = socketData.additionalData.count;
    Byte recivedData[count];
    
    for (int i = 0; i < count; i++) {
        
        recivedData[i] =
        ([socketData.additionalData[i] integerValue]) & 0xFF;
    }
    
    if (socketData.operatorCode == 0xE3E8 &&
        socketData.subNetID == self.currentHVAC.temperatureSensorSubNetID &&
        socketData.deviceID == self.currentHVAC.temperatureSensorDeviceID) {
        
        // 返回摄氏温度有效
        if (!recivedData[0]) {
            return;
        }
        
        // 获得传感器的温度
        self.currentHVAC.sensorTemperature = recivedData[self.currentHVAC.temperatureSensorChannelNo + 8] ? (0 - recivedData[self.currentHVAC.temperatureSensorChannelNo]) : recivedData[self.currentHVAC.temperatureSensorChannelNo];
        
        // 获得温度 设置空调相关的内容
        [self setACStatus];
    }
    
    // 空调部分 (coolmaster固件修改以后再将注释恢复)
    else /*if ((subNetID == self.currentHVAC.subnetID)  &&
          (deviceID == self.currentHVAC.deviceID)) */ {
              
              // 判断设备类型 (后续版本直接要求用户设置数据库中的acType为IR)
              self.isIREmitter =
              [self.iREmitterControlACDevices containsObject:@(socketData.deviceType)];
              
              switch (socketData.operatorCode) {
                      
                      // DDP控制面板发出的数据 而HVAC/IR/Relay得到的响应
                  case 0x193B: {
                      
                      if (socketData.subNetID != self.currentHVAC.subnetID ||
                          socketData.deviceID != self.currentHVAC.deviceID) {
                          break;
                      }
                      
                      // 在增加单个继电器控制空调的功能前,
                      // HVAC中,0X193B的返回长度是13
                      // IR 中 0X193B的返回长度是14 且顺序与HVAC保持一致,后面多出来的参数暂时没用上
                      // 增加单个继电器控制控制空调的0X193B的返回长度有变化是15。
                      
                      // 普通HAVC 不需要执行 if 语句
                      // 继电器控制空调 需要依据最后一个参数的通道号 && 可变参数的度是15 来判断
                      if ((count == 15)               &&
                          (recivedData[count - 1] != self.currentHVAC.channelNo)) {
                          break;
                      }
                      
                      // coolmaster 需要判断是哪个AcNumber && 可变参数
                      if (self.currentHVAC.acTypeID == SHAirConditioningTypeCoolMaster &&
                          (recivedData[0] != self.currentHVAC.acNumber)) {
                          break;
                      }
                      
                      // 获得温度单位 是否为摄氏温度
                      BOOL isCelsiusFlag = (recivedData[1] == 0);
                      
                      if (self.havcSetUpInfo.isCelsius != isCelsiusFlag) {
                          
                          self.havcSetUpInfo.isCelsius = isCelsiusFlag;
                          
                          [[SHSQLManager shareSQLManager] updateHVACSetUpInfoTempertureFlag:self.havcSetUpInfo.isCelsius];
                      }
                      
                      self.currentHVAC.indoorTemperature = [SHHVAC realTemperature:recivedData[2]];
                      
                      self.currentHVAC.coolTemperture = [SHHVAC realTemperature:recivedData[3]];
                      
                      self.currentHVAC.heatTemperture = [SHHVAC realTemperature:recivedData[4]];
                      
                      self.currentHVAC.autoTemperture = [SHHVAC realTemperature:recivedData[5]];
                      
                      self.currentHVAC.isTurnOn = recivedData[8];
                      
                      self.currentHVAC.acMode = recivedData[9];
                      
                      self.currentHVAC.fanSpeed = recivedData[10];
                  }
                      break;
                      
                      // 返回模式
                  case 0xE125: {
                      
                      if (socketData.subNetID != self.currentHVAC.subnetID ||
                          socketData.deviceID != self.currentHVAC.deviceID) {
                          break;
                      }
                      
                      [self.fanSpeedList removeAllObjects];
                      
                      Byte fanModelLength = recivedData[0];
                      
                      for (Byte i = 1; i <= fanModelLength; i++) {
                          
                          [self.fanSpeedList addObject:@(recivedData[i])];
                      }
                      
                      // 工作模式
                      [self.acModelList removeAllObjects];
                      
                      Byte acModelLength = recivedData[5];
                      for (Byte i = 1; i <= acModelLength; i++) {
                          
                          [self.acModelList  addObject:@(recivedData[i + 5])];
                      }
                      
                      // 读到模式后再读状态
                      [self readHVACCurrentStatuts];
                  }
                      
                  case 0xE3D9: {
                      
                      if (socketData.subNetID != self.currentHVAC.subnetID ||
                          socketData.deviceID != self.currentHVAC.deviceID) {
                          break;
                      }
                      
                      Byte operatorKind = recivedData[0];
                      
                      Byte operatorResult = recivedData[1];
                      
                      switch (operatorKind) {
                              
                          case SHAirConditioningControlTypeOnAndOff: {
                              
                              self.currentHVAC.isTurnOn = operatorResult;
                          }
                              break;
                              
                          case SHAirConditioningControlTypeCoolTemperatureSet: {
                              
                              self.currentHVAC.coolTemperture =
                              [SHHVAC realTemperature:operatorResult];
                              
                          }
                              break;
                              
                          case SHAirConditioningControlTypeFanSpeedSet: {
                              
                              self.currentHVAC.fanSpeed = operatorResult;
                          }
                              break;
                              
                          case SHAirConditioningControlTypeAcModeSet: {
                              
                              self.currentHVAC.acMode = operatorResult;
                          }
                              break;
                              
                          case SHAirConditioningControlTypeHeatTemperatureSet: {
                              
                              self.currentHVAC.heatTemperture =
                              [SHHVAC realTemperature:operatorResult];
                          }
                              break;
                              
                          case SHAirConditioningControlTypeAutoTemperatureSet: {
                              
                              self.currentHVAC.autoTemperture = [SHHVAC realTemperature:operatorResult];
                          }
                              break;
                              
                          default:
                              break;
                      }
                  }
                      break;
                      
                  case 0xE0ED: {
                      
                      if (self.currentHVAC.acTypeID == SHAirConditioningTypeCoolMaster) {
                          
                          if (socketData.subNetID != self.currentHVAC.temperatureSensorSubNetID ||
                              socketData.deviceID != self.currentHVAC.temperatureSensorDeviceID) {
                              break;
                          }
                          
                          // 非coolmaster控制空调模块
                      } else {
                          
                          if (socketData.subNetID != self.currentHVAC.subnetID ||
                              socketData.deviceID != self.currentHVAC.deviceID) {
                              break;
                          }
                      }
                      
                      // HVAC的E0ED返回 只有8 个字节
                      // 如果用户配置的是HVAC 直接执行
                      // 如果是DDP或者是Relay要判断 可变参数的最后一个是通道号
                      
                      Byte whichAc = (self.currentHVAC.acTypeID ==
                                      SHAirConditioningTypeCoolMaster) ? (self.currentHVAC.acNumber - 1): self.currentHVAC.channelNo;
                      
                      if ((count != 8) &&
                          ((recivedData[count - 1]) != whichAc)) {
                          break;
                      }
                      
                      
                      self.currentHVAC.isTurnOn = recivedData[0];
                      
                      self.currentHVAC.indoorTemperature = [SHHVAC realTemperature:recivedData[4]];
                      
                      self.currentHVAC.fanSpeed = [self.fanSpeedList[(recivedData[2] & 0x0F)] integerValue];
                      
                      self.currentHVAC.acMode = [self.acModelList[((recivedData[2] & 0xF0) >> 4)] integerValue];
                      
                      self.currentHVAC.coolTemperture = [SHHVAC realTemperature:recivedData[1]];
                      
                      self.currentHVAC.heatTemperture = [SHHVAC realTemperature:recivedData[5]];
                      
                      self.currentHVAC.autoTemperture = [SHHVAC realTemperature:recivedData[7]];
                      
                      // 读到了状态，再读温度范围
                      [self readHVACTemperatureRange];
                  }
                      break;
                      
                      // 获得温度单位
                  case 0xE121: {
                      
                      if (socketData.subNetID != self.currentHVAC.subnetID ||
                          socketData.deviceID != self.currentHVAC.deviceID) {
                          break;
                      }
                      
                      // 获得温度单位 是否为摄氏温度
                      BOOL isCelsiusFlag =
                      (self.isIREmitter || (self.currentHVAC.acTypeID == SHAirConditioningTypeIr)) ?
                      (recivedData[0] != 0) :
                      (recivedData[0] == 0);
                      
                      if (self.havcSetUpInfo.isCelsius != isCelsiusFlag) {
                          
                          self.havcSetUpInfo.isCelsius = isCelsiusFlag;
                          
                          [[SHSQLManager shareSQLManager] updateHVACSetUpInfoTempertureFlag:self.havcSetUpInfo.isCelsius];
                      }
                  }
                      break;
                      
                      // 获得不同模式的温度范围
                  case 0x1901: {
                      
                      if (socketData.subNetID != self.currentHVAC.subnetID ||
                         socketData.deviceID != self.currentHVAC.deviceID) {
                          break;
                      }
                      
                      // 说明：由于协议中没有与温度传感器正负，而是使用了补码的方式来表示
                      
                      // 制冷温度范围
                      self.currentHVAC.startCoolTemperatureRange = [SHHVAC realTemperature:recivedData[0]];
                      
                      self.currentHVAC.endCoolTemperatureRange = [SHHVAC realTemperature:recivedData[1]];
                      
                      // 制热温度范
                      self.currentHVAC.startHeatTemperatureRange =
                      [SHHVAC realTemperature:recivedData[2]];
                      
                      self.currentHVAC.endHeatTemperatureRange =
                      [SHHVAC realTemperature:recivedData[3]];
                      
                      // 自动模式温度范围
                      self.currentHVAC.startAutoTemperatureRange = [SHHVAC realTemperature:recivedData[4]];
                      
                      self.currentHVAC.endAutoTemperatureRange = [SHHVAC realTemperature:recivedData[5]];
                  }
                      break;
                      
                  default:
                      break;
                      
              }
              
              // 空调部分设置内容
              [self setACStatus];
          }
}


// MARK: - 解析数据后完成UI的设置

/// 设置空调的状态
- (void)setACStatus {
  
    // 1.设置显示开和关
    self.controlView.hidden = !self.currentHVAC.isTurnOn;
    self.turnAcButton.selected = self.currentHVAC.isTurnOn;
    
    // 2.设置环境温度
    
    // 都有值求平均
    if (self.currentHVAC.indoorTemperature && self.currentHVAC.sensorTemperature) {
        
        NSInteger avgTemp = (self.havcSetUpInfo.isCelsius ? (self.currentHVAC.indoorTemperature + self.currentHVAC.sensorTemperature) : (self.currentHVAC.indoorTemperature + [SHHVAC centigradeConvertToFahrenheit:self.currentHVAC.sensorTemperature])) * 0.5;
        
        self.currentTempertureLabel.text = [NSString stringWithFormat:@"%@%@", @(avgTemp), self.havcSetUpInfo.isCelsius ? @"°C" : @"°F"];
        
        // 只有空调本身的值
    } else if (self.currentHVAC.indoorTemperature) {
        
        self.currentTempertureLabel.text = [NSString stringWithFormat:@"%@%@", @(self.currentHVAC.indoorTemperature), self.havcSetUpInfo.isCelsius ? @"°C" : @"°F"];
        
        // 只有传感器
    } else if (self.currentHVAC.sensorTemperature) {
        
        self.currentTempertureLabel.text =  self.havcSetUpInfo.isCelsius ? [NSString stringWithFormat:@"%@ °C", @(self.currentHVAC.sensorTemperature)] : [NSString stringWithFormat:@"%@ °F", @((NSInteger)([SHHVAC centigradeConvertToFahrenheit:self.currentHVAC.sensorTemperature]))];
        
        // 都是0
    } else {
        
        // self.currentTempertureLabel.text = @"N/A";
    }
    
    // 3.设置风速等级
    for (NSUInteger index = 0; index < self.fanSppedButtons.count; index++) {
        
        UIButton *fanSpeedButton = self.fanSppedButtons[index];
        
        fanSpeedButton.enabled = [self.fanSpeedList containsObject:@(index)];
        
        [fanSpeedButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        if (fanSpeedButton.isEnabled) {
            
            fanSpeedButton.selected = NO;
            
            [fanSpeedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    // 风速指示
    self.fanImageView.image = [UIImage imageNamed:self.fanSpeedImageName[self.currentHVAC.fanSpeed]];
    
    [self.fanSppedButtons[self.currentHVAC.fanSpeed] setSelected:YES];
    
    
    // 4.设置工作模式
    for (NSUInteger index = 0; index < self.acModelButtons.count; index++) {
        
        UIButton *acModelButton = self.acModelButtons[index];
        
        acModelButton.enabled = [self.acModelList containsObject:@(index)];
        
        [acModelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        if (acModelButton.isEnabled) {
            
            acModelButton.selected = NO;
            [acModelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    // 模式指示
    self.modelImageView.image = [UIImage imageNamed:self.acModelImageName[self.currentHVAC.acMode]];
    
    [self.acModelButtons[self.currentHVAC.acMode] setSelected:YES];
    
    NSString *unit = self.havcSetUpInfo.isCelsius ? @"°C" : @"°F";
    
    switch (self.currentHVAC.acMode) {
            
        case SHAirConditioningModeTypeCool: {
            
            self.modelTemperatureLabel.text =
            [NSString stringWithFormat:@"%@ %@",
             @(self.currentHVAC.coolTemperture) , unit];
        }
            break;
            
        case SHAirConditioningModeTypeHeat: {
            
            self.modelTemperatureLabel.text =
            [NSString stringWithFormat:@"%@ %@",
             @(self.currentHVAC.heatTemperture) ,unit];
        }
            break;
            
        case SHAirConditioningModeTypeFan: {
            
            self.modelTemperatureLabel.text =
            [NSString stringWithFormat:@"%@ %@",
             @(self.currentHVAC.coolTemperture) ,unit];
        }
            break;
            
        case SHAirConditioningModeTypeAuto: {
            
            self.modelTemperatureLabel.text =
            [NSString stringWithFormat:@"%@ %@",
             @(self.currentHVAC.autoTemperture) ,unit];
        }
            break;
            
        default:
            break;
    }
    
    
    self.hotFastControlButton.enabled =
    [self.acModelButtons[SHAirConditioningModeTypeHeat] isEnabled];
    
    self.warmFastControlButton.enabled =
    [self.acModelButtons[SHAirConditioningModeTypeHeat] isEnabled];
    
    self.coldFastControlButton.enabled =
    [self.acModelButtons[SHAirConditioningModeTypeCool] isEnabled];
    
    self.coolFastControlButton.enabled =
    [self.acModelButtons[SHAirConditioningModeTypeCool] isEnabled];
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
    
    [self changeAcModel:self.currentHVAC.acMode temperature:temperature];
}

/// 降低温度
- (IBAction)lowerTemperature {
    
    NSRange range = [self.modelTemperatureLabel.text rangeOfString:@"°"];
    
    if (range.location == NSNotFound) {
        return;
    }
    
    NSInteger temperature =  [[self.modelTemperatureLabel.text substringToIndex:range.location] integerValue];
    
    --temperature;
    
    [self changeAcModel:self.currentHVAC.acMode temperature:temperature];
}


/// 修改模式温度
- (void)changeAcModel:(SHAirConditioningModeType)acModel temperature:(NSInteger)temperature {
    
    Byte temperatureData[2] = { 0 };
    
    switch (acModel) {
            
        case SHAirConditioningModeTypeHeat: { // 制热
            
            temperatureData[0] = SHAirConditioningControlTypeHeatTemperatureSet;
            
            if (temperature < self.currentHVAC.startHeatTemperatureRange || temperature > self.currentHVAC.endHeatTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
        }
            break;
            
        case SHAirConditioningModeTypeFan:
        case SHAirConditioningModeTypeCool: {
            
            temperatureData[0] = SHAirConditioningControlTypeCoolTemperatureSet;
            
            if (temperature < self.currentHVAC.startCoolTemperatureRange || temperature > self.currentHVAC.endCoolTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
        }
            break;
            
        case SHAirConditioningModeTypeAuto: {
            
            temperatureData[0] = SHAirConditioningControlTypeAutoTemperatureSet;
            
            if (temperature < self.currentHVAC.startAutoTemperatureRange || temperature > self.currentHVAC.endAutoTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    self.modelTemperatureLabel.text =
    [NSString stringWithFormat:@"%@ %@",
     @(temperature) , self.havcSetUpInfo.isCelsius ? @"°C" : @"°F"];
    
    // 如果是负数使用补码
    temperatureData[1] = [SHHVAC realTemperature:temperature];
    
    [self controlAirControlType:temperatureData[0] value:temperatureData[1]];
    
    
    [NSThread sleepForTimeInterval:0.12];
    
    // 继电器控制方式
    [self controlAirConditioning:self.currentHVAC.isTurnOn
                        fanSpeed:self.currentHVAC.fanSpeed
                         acModel:acModel
                modelTemperature:[SHHVAC realTemperature:temperature]
        isChangeModelTemperature:YES];
}

/// 风速变化
- (IBAction)fanSpeedChange:(UIButton *)fanSpeedButton {
    
    NSUInteger index = [self.fanSppedButtons indexOfObject:fanSpeedButton];
    
    [self changeHVACFanSpeed:index];
}

/// 控制HVAC的风速
- (void)changeHVACFanSpeed:(Byte)fanSpeed {
    
    if (self.currentHVAC.fanSpeed == fanSpeed) {
        return ;
    }
    
    [self.fanSppedButtons[self.currentHVAC.fanSpeed] setSelected:NO];
    
    [self.fanSppedButtons[fanSpeed] setSelected:YES];
    
    
    if (self.currentHVAC.acTypeID == SHAirConditioningTypeCoolMaster) {
        
        [self controlAirConditioning:self.currentHVAC.isTurnOn
                            fanSpeed:fanSpeed
                             acModel:self.currentHVAC.acMode
                    modelTemperature:0
            isChangeModelTemperature:NO];
        
        
        return ;
    }
    
    // 通用HVAC
    [self controlAirControlType:SHAirConditioningControlTypeFanSpeedSet value:fanSpeed];
}

/// 模式变化
- (IBAction)acModelChange:(UIButton *)acModelButton {
    
    NSUInteger index = [self.acModelButtons indexOfObject:acModelButton];
    
    [self controlHVACMode:index];
}

/// 切换空调的模式
- (void)controlHVACMode:(SHAirConditioningModeType)acModel {
    
    if (self.currentHVAC.acMode == acModel) {
        return ;
    }
    
    [self.acModelButtons[self.currentHVAC.acMode] setSelected:NO];
    
    [self.acModelButtons[acModel] setSelected:YES];
    
    if (self.currentHVAC.acTypeID == SHAirConditioningTypeCoolMaster) {
        
        [self controlAirConditioning:self.currentHVAC.isTurnOn
                            fanSpeed:self.currentHVAC.fanSpeed
                             acModel:acModel
                    modelTemperature:0
            isChangeModelTemperature:NO];
        
        return ;
    }
    
    [self controlAirControlType:SHAirConditioningControlTypeAcModeSet value:acModel];
}

/// 快速制冷
- (IBAction)coldFastControlButtonClick {
    
    // 切换模式
    [self controlHVACMode:SHAirConditioningModeTypeCool];
    
    // 设置温度
    [self changeAcModel:SHAirConditioningModeTypeCool
            temperature:self.havcSetUpInfo.tempertureOfCold];
}

/// 快速凉快
- (IBAction)coolFastControlButtonClick {
    
    // 切换模式
    [self controlHVACMode:SHAirConditioningModeTypeCool];
    
    // 设置温度
    [self changeAcModel:SHAirConditioningModeTypeCool
            temperature:self.havcSetUpInfo.tempertureOfCool];
    
}

/// 快速暖和
- (IBAction)warmFastControlButtonClick {
    
    // 切换模式
    [self controlHVACMode:SHAirConditioningModeTypeHeat];
    
    // 设置温度
    [self changeAcModel:SHAirConditioningModeTypeHeat
            temperature:self.havcSetUpInfo.tempertureOfWarm];
}

/// 快速制热
- (IBAction)hotFastControlButtonClick {
    
    // 切换模式
    [self controlHVACMode:SHAirConditioningModeTypeHeat];
    
    // 设置温度
    [self changeAcModel:SHAirConditioningModeTypeHeat
            temperature:self.havcSetUpInfo.tempertureOfHot];
}

/// 开关空调
- (IBAction)turnOnAndOffHVAC{
    
    self.controlView.hidden = !self.currentHVAC.isTurnOn;
    
    [self controlAirControlType:SHAirConditioningControlTypeOnAndOff
                          value:!self.currentHVAC.isTurnOn];
    
    [NSThread sleepForTimeInterval:0.12];
    
    // 继电器控制方式
    [self controlAirConditioning:!self.currentHVAC.isTurnOn
                        fanSpeed:self.currentHVAC.fanSpeed
                         acModel:self.currentHVAC.acMode
                modelTemperature:0
        isChangeModelTemperature:NO];
}

/// 控制HVAC的普通指令 0xE3D8
- (void)controlAirControlType:(Byte)type value:(NSInteger)value {
    
    NSArray *acData = @[@(type), @(value)];
    [SHSocketTools sendDataWithOperatorCode:0xE3D8
                                   subNetID:self.currentHVAC.subnetID
                                   deviceID:self.currentHVAC.deviceID
                             additionalData:acData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
}

/// 控制空调的通用方式 0x193A
- (void)controlAirConditioning:(BOOL)powerOn
                      fanSpeed:(SHAirConditioningFanSpeedType) fanSpeed
                       acModel:(SHAirConditioningModeType)acModel
              modelTemperature:(NSInteger)modelTemperature
      isChangeModelTemperature:(BOOL)isChangeModelTemperature {
    
    Byte controlData[14] = { 0 };
    
    controlData[0] = self.currentHVAC.channelNo ? 1 : self.currentHVAC.acNumber; // default value is 1
    controlData[1] = !self.havcSetUpInfo.isCelsius;
    controlData[2] = self.currentHVAC.indoorTemperature;
    
    controlData[3] = self.currentHVAC.coolTemperture;
    controlData[4] = self.currentHVAC.heatTemperture;
    controlData[5] = self.currentHVAC.autoTemperture;
    
    if (isChangeModelTemperature) {
        
        switch (acModel) {
                
            case SHAirConditioningModeTypeCool:
            case SHAirConditioningModeTypeFan: {
                
                controlData[3] = modelTemperature;
            }
                break;
                
            case SHAirConditioningModeTypeHeat: {
                
                controlData[4] = modelTemperature;
            }
                break;
                
            case SHAirConditioningModeTypeAuto: {
                
                controlData[5] = modelTemperature;
            }
                break;
                
            default:
                break;
        }
    }
    
    controlData[7] = self.currentHVAC.acMode << 4 | self.currentHVAC.fanSpeed;
    controlData[8] = powerOn;
    controlData[9] = acModel;
    controlData[10] = fanSpeed;
    controlData[13]= self.currentHVAC.channelNo;
    
    NSMutableArray *acData = [NSMutableArray array];
    
    for (int i = 0; i < 14; i++) {
        
        acData[i] = @(controlData[i]);
    }
    
    [SHSocketTools sendDataWithOperatorCode:0x193A
                                   subNetID:self.currentHVAC.subnetID
                                   deviceID:self.currentHVAC.deviceID
                             additionalData:acData remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     
     ];
}

/// 读取状态
- (void)readDevicesStatus {
    
    Byte subNetID = self.currentHVAC.subnetID;
    Byte deviceID = self.currentHVAC.deviceID;
    
    // 1.读取温度单位
    [SHSocketTools sendDataWithOperatorCode:0xE120
                                   subNetID:subNetID
                                   deviceID:deviceID
                             additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:false
                                      isDMX:false
     ];
    
    // 2. 读取传感器的温度
    [SHSocketTools sendDataWithOperatorCode:0xE3E7 subNetID:self.currentHVAC.temperatureSensorSubNetID deviceID:self.currentHVAC.temperatureSensorDeviceID additionalData:@[@1] remoteMacAddress:SHSocketTools.remoteControlMacAddress needReSend:true isDMX:false];
 
 
    // 3.读取空调的工作模式与风速模式
    [SHSocketTools sendDataWithOperatorCode:0xE124
                                   subNetID:subNetID
                                   deviceID:deviceID
                             additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
}

/// 读取HVAC的温度范围
- (void)readHVACTemperatureRange {
    
    [SHSocketTools sendDataWithOperatorCode:0x1900
                                   subNetID:self.currentHVAC.subnetID
                                   deviceID:self.currentHVAC.deviceID
                             additionalData:@[] remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
}

/// 读取HVAC的状态
- (void)readHVACCurrentStatuts {
    
    Byte additionalData = self.currentHVAC.channelNo;
    
    if (self.currentHVAC.acTypeID == SHAirConditioningTypeCoolMaster) {
        additionalData = self.currentHVAC.acNumber - 1;
    }
    
    Byte subNetID = self.currentHVAC.subnetID;
    Byte deviceID = self.currentHVAC.deviceID;
    
    // coolmaster控制， 由于固件不支持读状态(返回都是8个0)，
    // 所以需要用户指定DDP来间接读取。
    if (self.currentHVAC.acTypeID == SHAirConditioningTypeCoolMaster) {
        
        subNetID = self.currentHVAC.temperatureSensorSubNetID;
        deviceID = self.currentHVAC.temperatureSensorDeviceID;
    }
    
    [SHSocketTools sendDataWithOperatorCode:0xE0EC
                                   subNetID:subNetID
                                   deviceID:deviceID
                             additionalData:@[@(additionalData)] remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
}

// MARK: - UI

// °C °F

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self readDevicesStatus];
    [self setACStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获得配置信息
    self.havcSetUpInfo = [[SHSQLManager shareSQLManager] getHVACSetUpInfo];
    
    // DDP/CTP 是不需要通道的
    if (!self.currentHVAC.temperatureSensorChannelNo) {
        
        self.currentHVAC.temperatureSensorChannelNo = 1;
    }
    
    // 界面初始化
    [self setUpUi];
}

/// 初始化UI
- (void)setUpUi {
    
    self.navigationItem.title = self.currentHVAC.acRemark;
    
    // 控制功能区域
    self.turnAcButton.imageView.contentMode =
    UIViewContentModeScaleAspectFit;
    
    self.controlView.hidden = YES;
    
    NSUInteger maxIndex = self.fanSppedButtons.count - 1;
    for (UIButton *fanSpeedButton in self.fanSppedButtons) {
        
        fanSpeedButton.enabled = NO;
        
        NSUInteger index = [self.fanSppedButtons indexOfObject:fanSpeedButton];
        
        [fanSpeedButton setTitle:([[SHLanguageTools shareLanguageTools] getTextFromPlist:@"HVAC_IN_ZONE" withSubTitle:@"FAN_BUTTON_NAMES"] [maxIndex - index]) forState:UIControlStateNormal];
        
        [fanSpeedButton setRoundedRectangleBorder];
        
        if ([UIDevice is_iPad]) {
            
            fanSpeedButton.titleLabel.font = [UIView suitFontForPad];
        }
    }
    
    for (UIButton *acModelButton in self.acModelButtons) {
        
        acModelButton.enabled = NO;
        
        NSUInteger index = [self.acModelButtons indexOfObject:acModelButton];
        
        [acModelButton setTitle:([[SHLanguageTools shareLanguageTools] getTextFromPlist:@"HVAC_IN_ZONE" withSubTitle:@"MODE_BUTTON_NAMES"] [index]) forState:UIControlStateNormal];
        
        [acModelButton setRoundedRectangleBorder];
        
        if ([UIDevice is_iPad]) {
            
            acModelButton.titleLabel.font = [UIView suitFontForPad];
        }
    }
    
    // 快速控制  -- 新版本改成数字显示
    NSString *unit = self.havcSetUpInfo.isCelsius ? @"°C" : @"°F";
    
    [self.coldFastControlButton setTitle:[NSString stringWithFormat:@"%@%@", @(self.havcSetUpInfo.tempertureOfCold), unit] forState:UIControlStateNormal];
    
    [self.coolFastControlButton setTitle: [NSString stringWithFormat:@"%@%@", @(self.havcSetUpInfo.tempertureOfCool), unit] forState:UIControlStateNormal];
    
    [self.warmFastControlButton setTitle: [NSString stringWithFormat:@"%@%@", @(self.havcSetUpInfo.tempertureOfWarm), unit] forState:UIControlStateNormal];
    
    [self.hotFastControlButton setTitle: [NSString stringWithFormat:@"%@%@", @(self.havcSetUpInfo.tempertureOfHot), unit] forState:UIControlStateNormal];
    
    [self.addTemperatureButton setRoundedRectangleBorder];
    [self.reduceTemperatureButton setRoundedRectangleBorder];
    [self.coldFastControlButton setRoundedRectangleBorder];
    [self.coolFastControlButton setRoundedRectangleBorder];
    [self.warmFastControlButton setRoundedRectangleBorder];
    [self.hotFastControlButton setRoundedRectangleBorder];
    
    
    if ([UIDevice is_iPad]) {
        
        self.currentTempertureLabel.font = [UIView suitLargerFontForPad];
        self.modelTemperatureLabel.font = [UIView suitLargerFontForPad];
        
        self.reduceTemperatureButton.titleLabel.font = [UIView suitFontForPad];
        self.addTemperatureButton.titleLabel.font = [UIView suitFontForPad];
        
        
        self.coldFastControlButton.titleLabel.font = [UIView suitFontForPad];
        self.coolFastControlButton.titleLabel.font = [UIView suitFontForPad];
        self.warmFastControlButton.titleLabel.font = [UIView suitFontForPad];
        self.hotFastControlButton.titleLabel.font = [UIView suitFontForPad];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.acflagWidthConstraint.constant = navigationBarHeight;
        self.acflagHeightConstraint.constant = navigationBarHeight;
        
        // 控制空调部分
        self.controlButtonSuperViewBaseHeightConstraint.constant = navigationBarHeight + navigationBarHeight;
        
        self.controlButtonHeightConstraint.constant = navigationBarHeight + (self.isPortrait ? tabBarHeight : statusBarHeight);
        
        // 中心小图标
        self.controlMiddleIconViewWidthConstraint.constant = navigationBarHeight + statusBarHeight;
        self.controlMiddleIconViewHeightConstraint.constant = navigationBarHeight + statusBarHeight;
        
    } else {
        
        if ([UIDevice is4_0inch] ||
            [UIDevice is3_5inch]) {
            
            if ([UIDevice is3_5inch]) {
                
                self.acflagWidthConstraint.constant = defaultHeight;
                self.acflagHeightConstraint.constant = defaultHeight;
                
                self.controlButtonHeightConstraint.constant = defaultHeight;
                
                self.controlButtonSuperViewBaseHeightConstraint.constant =
                navigationBarHeight;
                
                self.controlButtonStartY.constant = statusBarHeight;
            }
            
        } else {
            
            self.controlButtonSuperViewBaseHeightConstraint.constant =
            navigationBarHeight + statusBarHeight;
            
            self.controlButtonHeightConstraint.constant = navigationBarHeight;
        }
    }
}

// MARK: - getter && setter

- (NSArray *)iREmitterControlACDevices {
    
    if (!_iREmitterControlACDevices) {
        
        _iREmitterControlACDevices = [NSArray arrayWithObjects:
                                      @300,
                                      @301,
                                      @302,
                                      @303,
                                      @304,
                                      @305,
                                      @309,
                                      @319,
                                      @320,
                                      nil
                                      ];
    }
    
    return _iREmitterControlACDevices;
}

- (NSArray *)fanSpeedImageName {
    
    if (!_fanSpeedImageName) {
        
        _fanSpeedImageName = [NSArray arrayWithObjects:
                              @"autofan",
                              @"highfan",
                              @"mediumfan",
                              @"lowfan",
                              nil];
    }
    return _fanSpeedImageName;
}

- (NSArray *)acModelImageName {
    
    if (!_acModelImageName) {
        
        _acModelImageName = [NSArray arrayWithObjects:
                             @"coolModel",
                             @"heatModel",
                             @"fanModel",
                             @"autoModel",
                             nil];
    }
    return _acModelImageName;
}

- (NSMutableArray *)fanSpeedList {
    
    if (!_fanSpeedList) {
        
        _fanSpeedList = [NSMutableArray array];
    }
    
    return _fanSpeedList;
}

- (NSMutableArray *)acModelList {
    
    if (!_acModelList) {
        
        _acModelList = [NSMutableArray array];
    }
    
    return _acModelList;
}

@end
