//
//  SHSchedual.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/20.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 计划执行类型
typedef NS_ENUM(NSUInteger, SHSchdualControlItemType) {
    
    SHSchdualControlItemTypeMarco = 1,
    
    SHSchdualControlItemTypeMood,
    
    SHSchdualControlItemTypeLight,
    
    SHSchdualControlItemTypeHVAC,
    
    SHSchdualControlItemTypeAudio,
    
    SHSchdualControlItemTypeShade,
    
    SHSchdualControlItemTypeFloorHeating

} ;

/// 执行的频率 ， 默认只执行一次
typedef NS_ENUM(NSUInteger, SHSchdualFrequency) {

    SHSchdualFrequencyOneTime,
    SHSchdualFrequencyDayily,
    SHSchdualFrequencyWeekly
};

/// 执行的星天 从1开始，避免默认值的影响，与执行频率不同，
typedef NS_ENUM(NSInteger, SHSchdualWeek) {

    SHSchdualWeekNone = 0,
    SHSchdualWeekSunday,
    SHSchdualWeekMonday ,
    SHSchdualWeekTuesday ,
    SHSchdualWeekWednesday ,
    SHSchdualWeekThursday ,
    SHSchdualWeekFriday,
    SHSchdualWeekSaturday
};

@interface SHSchedual : NSObject

/// 所有指令
@property (strong, nonatomic) NSMutableArray *commands;

/// 记录的序号
@property (assign, nonatomic) NSUInteger id;

/// 计划的序号
@property (assign, nonatomic) NSUInteger scheduleID;

/// 计划的名称
@property (copy, nonatomic) NSString *scheduleName;

/// 是否开启计划
@property (assign, nonatomic) BOOL enabledSchedule;

/// 控制类型ID  // 从1开始
@property (assign, nonatomic) SHSchdualControlItemType controlledItemID;

/// 区域ID (数据库使用的是 TEXT)
@property (assign, nonatomic) NSUInteger zoneID;

/// 执行频率 (数据库使用的是 TEXT)
@property (assign, nonatomic) SHSchdualFrequency frequencyID;

/// 执行的是星期天
@property (assign, nonatomic) BOOL withSunday;

/// 执行的星期一
@property (assign, nonatomic) BOOL withMonday;

/// 执行的星期二
@property (assign, nonatomic) BOOL withTuesday;

/// 执行的星期三
@property (assign, nonatomic) BOOL withWednesday;

/// 执行的星期四
@property (assign, nonatomic) BOOL withThursday;

/// 执行的星期五
@property (assign, nonatomic) BOOL withFriday;

/// 执行的星期六
@property (assign, nonatomic) BOOL withSaturday;

/// 执行的小时 [TEXT]
@property (assign, nonatomic) Byte executionHours;

/// 执行的分钟 [TEXT]
@property (assign, nonatomic) Byte executionMins;

/// 执行的日期
@property (copy, nonatomic) NSString *executionDate;

/// 包含了声音
@property (assign, nonatomic) BOOL haveSound;

 
/// 字典转换为模型
+ (instancetype)schedualWithDictionary:(NSDictionary *)dictionary;

/// 获得需要执行的星期
- (NSMutableArray *)getExecutWeekDays;

@end
