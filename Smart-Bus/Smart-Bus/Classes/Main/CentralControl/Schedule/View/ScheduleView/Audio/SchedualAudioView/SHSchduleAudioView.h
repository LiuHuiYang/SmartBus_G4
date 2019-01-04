//
//  SHSchduleAudioView.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/22.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSchduleAudioView : UIView

/// 计划模型
@property (strong, nonatomic) SHSchedual *schedual;

/// Audio
+ (instancetype)schduleAudioView;

@end
