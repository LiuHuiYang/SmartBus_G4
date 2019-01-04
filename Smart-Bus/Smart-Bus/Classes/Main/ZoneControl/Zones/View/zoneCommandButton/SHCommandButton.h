//
//  SHCommandButton.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/11.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

/*
    这个按钮是通用的 统一格式的 按钮
    具体的属性是由在不同的设备区域或场景中通过设置来确定
 */

#import <UIKit/UIKit.h>


/// 安防区域模型
typedef NS_ENUM(NSUInteger, SHSecurityType) {
    
    SHSecurityTypeNone = 0,
    SHSecurityTypeVacation = 1,
    SHSecurityTypeAway = 2,
    SHSecurityTypeNight = 3,
    SHSecurityTypeNightGeust = 4,
    SHSecurityTypeDay  = 5,
    SHSecurityTypeDisarm = 6,
    SHSecurityTypePanic = 1007,  // 后面两个不同
    SHSecurityTypeAmbulance = 1008
    
} ;

@interface SHCommandButton : UIButton

/// 录制成功 (录制场景时使用)
@property (assign, nonatomic) BOOL recordSuccess;

/// 安防类型
@property (assign, nonatomic) SHSecurityType securityType;

@end
