//
//  SHSchduleLightView.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSchduleLightView : UIView

/// 计划模型
@property (strong, nonatomic) SHSchedual *schedual;

/// light
+ (instancetype)schduleLightView;


@end
