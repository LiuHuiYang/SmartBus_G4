//
//  SHSchedualEditViewController.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/20.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHViewController.h"

@interface SHSchedualEditViewController : SHViewController

/// 是否为增加的计算
@property (assign, nonatomic) BOOL isAddSedual;

/// 编辑的计划
@property (strong, nonatomic) SHSchedual *schedual;

@end
