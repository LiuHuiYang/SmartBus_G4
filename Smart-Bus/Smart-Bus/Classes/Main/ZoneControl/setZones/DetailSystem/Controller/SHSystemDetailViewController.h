//
//  SHSystemDetailViewController.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/15.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHViewController.h"

@interface SHSystemDetailViewController : SHViewController

/// 区域模型
@property (strong, nonatomic) SHZone *zone;

/// 系统ID
@property (assign, nonatomic) SHSystemDeviceType systemType;

/// 设备名称
@property (copy, nonatomic) NSString *deviceName;

@end
