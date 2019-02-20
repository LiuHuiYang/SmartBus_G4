//
//  SHSchedual.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/20.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchedual.h"

@implementation SHSchedual

/// 字典转换为模型
+ (instancetype)schedualWithDictionary:(NSDictionary *)dictionary {

    SHSchedual *schedual = [[self alloc] init];
    
    schedual.id = [dictionary[@"ID"] integerValue];
    schedual.scheduleID = [dictionary[@"ScheduleID"] integerValue];
    schedual.scheduleName = dictionary[@"ScheduleName"];
    schedual.enabledSchedule = [dictionary[@"EnabledSchedule"] integerValue];
    schedual.frequencyID = [dictionary[@"FrequencyID"] integerValue];
    schedual.controlledItemID = [dictionary[@"ControlledItemID"] integerValue];
    schedual.zoneID = [dictionary[@"ZoneID"] integerValue];
    schedual.executionDate = dictionary[@"ExecutionDate"];
    schedual.haveSound = [dictionary[@"HaveSound"] integerValue];
    
    // 星期
    schedual.withSunday = [dictionary[@"WithSunday"] integerValue];
    schedual.withMonday = [dictionary[@"WithMonday"] integerValue];
    schedual.withTuesday = [dictionary[@"WithTuesday"] integerValue];
    schedual.withWednesday = [dictionary[@"WithWednesday"] integerValue];
    schedual.withThursday = [dictionary[@"WithThursday"] integerValue];
    schedual.withFriday = [dictionary[@"WithFriday"] integerValue];
    schedual.withSaturday = [dictionary[@"WithSaturday"] integerValue];
    
    schedual.executionHours = [dictionary[@"ExecutionHours"] integerValue];
    schedual.executionMins = [dictionary[@"ExecutionMins"] integerValue];

    return schedual;
}

/// 获得需要执行的星期
- (NSMutableArray *)getExecutWeekDays {

    NSMutableArray *array = [NSMutableArray array];
    
    if (self.withSunday) {
        
        [array addObject:@(SHSchdualWeekSunday)];
    }
    
    if (self.withMonday) {
        
        [array addObject:@(SHSchdualWeekMonday)];
    }
    
    if (self.withTuesday) {
        
        [array addObject:@(SHSchdualWeekTuesday)];
    }
    
    if (self.withWednesday) {
        
        [array addObject:@(SHSchdualWeekWednesday)];
    }
    
    if (self.withThursday) {
        
        [array addObject:@(SHSchdualWeekThursday)];
    }
    
    if (self.withFriday) {
        
        [array addObject:@(SHSchdualWeekFriday)];
    }
    
    if (self.withSaturday) {
        
        [array addObject:@(SHSchdualWeekSaturday)];
    }
    
    return array;
}

// MARK: - getter && setter

- (NSMutableArray *)commands {
    
    if (!_commands) {
        
        _commands = [NSMutableArray array];
    }
    
    return _commands;
}

@end
