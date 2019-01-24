//
//  SHSecurityViewController.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHViewController.h"

@class SHSecurityZone;

@interface SHSecurityControlViewController : SHViewController

/// 安防区域
@property (strong, nonatomic) SHSecurityZone *securityZone;

@end
