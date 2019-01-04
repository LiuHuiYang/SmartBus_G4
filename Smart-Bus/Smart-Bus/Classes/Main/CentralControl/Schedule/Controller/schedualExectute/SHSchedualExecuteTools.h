//
//  SHSchedualExecuteTools.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/4.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 后台任务标示
 */
typedef NS_ENUM(Byte, SHApplicationBackgroundTask) {
    
    SHApplicationBackgroundTaskOpen = 1,  // 打开
    SHApplicationBackgroundTaskClose = 2// 关闭
};


@interface SHSchedualExecuteTools : NSObject



/// 更新计划
- (void)updateSchduals;

/// 实初始化定时器
- (void)initSchedualTimer;



SingletonInterface(SchedualExecuteTools)

@end
