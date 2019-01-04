//
//  SHSchduleHVACView.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSchduleHVACView : UIView

/// 计划模型
@property (strong, nonatomic) SHSchedual *schedual;

/// HVAC
+ (instancetype)schduleHVACView;

@end
