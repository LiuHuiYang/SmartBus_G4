//
//  SHZoneDmxGroupViewController.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/4.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

@class SHDmxGroup;

@interface SHZoneDmxGroupViewController : SHTabBarController

/// 通过指定的dmxGroup进行初始化控制器
- (instancetype)initWithDmxGroup:(SHDmxGroup *)dmxGroup;

@end
