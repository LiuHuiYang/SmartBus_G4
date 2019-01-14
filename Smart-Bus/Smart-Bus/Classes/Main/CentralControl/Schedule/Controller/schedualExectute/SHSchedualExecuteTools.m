//
//  SHSchedualExecuteTools.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/4.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchedualExecuteTools.h"

@interface SHSchedualExecuteTools ()

/// 定时器
@property (nonatomic, weak) NSTimer *schedualTimer;

/// 执行的计划列表
@property (strong, nonatomic) NSMutableArray *schedulesActivate;

@end

@implementation SHSchedualExecuteTools


// MARK: - 收到通知的响应
 
/// 接到了执行计划的时间通知
- (void)recvieTimeForSchedualNotification {
    
    // 1.获得当前时间
    NSDateComponents * currentComponents = [NSDate getCurrentDateComponents];
    
    // 2.开始遍历需要执行的计划
    for (SHSchedual *schedual in self.schedulesActivate) {
        
        // 匹配频率
        switch (schedual.frequencyID) {
                
                // 只执行一次
            case SHSchdualFrequencyOneTime: {
                
                NSDateComponents *executeComponents = [NSDate getDateComponentsForDateFormatString:@"MM-dd HH:mm" byDateString:schedual.executionDate];
                
                if (executeComponents.month ==
                    currentComponents.month &&
                    executeComponents.day ==
                    currentComponents.day &&
                    executeComponents.hour ==
                    currentComponents.hour &&
                    executeComponents.minute ==
                    currentComponents.minute) {
                    
                    [SHScheduleCommandTools executeSchdule:schedual];
                }
            }
                break;
                
                // 每天执行一次
            case SHSchdualFrequencyDayily: {
                
                NSDateComponents *executeComponents = [NSDate getDateComponentsForDateFormatString:@"HH:mm" byDateString:schedual.executionDate];
                
                if (currentComponents.hour == executeComponents.hour &&
                    currentComponents.minute == executeComponents.minute) {
                    
                    [SHScheduleCommandTools executeSchdule:schedual];
                }
            }
                break;
                
                // 每周
            case SHSchdualFrequencyWeekly: {
                
                // 获得当前时间
                switch (currentComponents.weekday) {
                        
                        // 星期天
                    case SHSchdualWeekSunday: {
                        
                        if (schedual.withSunday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [SHScheduleCommandTools executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期一
                    case SHSchdualWeekMonday: {
                        
                        if (schedual.withMonday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [SHScheduleCommandTools executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期二
                    case SHSchdualWeekTuesday: {
                        
                        if (schedual.withTuesday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [SHScheduleCommandTools executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期三
                    case SHSchdualWeekWednesday: {
                        
                        if (schedual.withWednesday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [SHScheduleCommandTools executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期四
                    case SHSchdualWeekThursday: {
                        
                        if (schedual.withThursday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [SHScheduleCommandTools executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期五
                    case SHSchdualWeekFriday: {
                        
                        if (schedual.withFriday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [SHScheduleCommandTools executeSchdule:schedual];
                        }
                    }
                        break;
                        
                        // 星期六
                    case SHSchdualWeekSaturday: {
                        
                        if (schedual.withSaturday && currentComponents.hour == schedual.executionHours &&
                            currentComponents.minute == schedual.executionMins) {
                            
                            [SHScheduleCommandTools executeSchdule:schedual];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    }
}

// MARK: - 定时器的准备工作

/// 实初始化定时器
- (void)initSchedualTimer {
    
    // 初始化计划表
    [self updateSchduals];

    // 增加计划执行的 定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(prepareTimerForSchedual) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.schedualTimer = timer;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvieTimeForSchedualNotification) name:SHSchedualPrepareExecuteNotification object:nil];

}

/// 每分钟发出一次通知
- (void)prepareTimerForSchedual {
    
    if (!([[NSDate getCurrentDateComponents] second])) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHSchedualPrepareExecuteNotification object:nil];
    }
}

// MARK: - 更新执行计划

/// 更新计划
- (void)updateSchduals {
    
    NSMutableArray *scheduals = [[SHSQLManager shareSQLManager] getAllSchdule];
    
    [self.schedulesActivate removeAllObjects];
    
    for (SHSchedual *schedual in scheduals) {
        
        if (schedual.enabledSchedule && ![self.schedulesActivate containsObject:schedual]) {
            
            [self.schedulesActivate addObject:schedual];
        }
    }
}


// MARK: - getter && setter

/// 执行的计划数组
- (NSMutableArray *)schedulesActivate {
    
    if (!_schedulesActivate) {
        
        _schedulesActivate = [NSMutableArray array];
    }
    
    return _schedulesActivate;
}

// MARK: - 销毁

/// 移除定时器 && 通知
- (void)dealloc {
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 定时器失效
    [self.schedualTimer invalidate];
    self.schedualTimer = nil;
}

// MARK: 单例

SingletonImplementation(SchedualExecuteTools)

@end
