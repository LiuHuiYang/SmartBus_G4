//
//  SHAreaControlViewController.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/13.
//  Copyright © 2017年 SmartHome. All rights reserved.
//


@interface SHAreaControlViewController : SHTabBarController
 
/// 通过指定的区域进行初始化控制器
- (instancetype)initWithZone:(SHZone *)zone;

@end
