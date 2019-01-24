//
//  SHSQLManager.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/9.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//
/*
 
 SQL语句使用注意:
    在执行DDL语句，由于放在字符串中，可以不加''来包含字段名和表名，
 但使用了字符串的值虽然使用的拼接，但在SQL中还要在用''来包括所得出的字符串。
 
 */

#import "SHSQLManager.h"

// 在数据库中可以iconList直接查询到
const NSUInteger maxIconIDForDataBase = 10;

@interface SHSQLManager ()

@end

@implementation SHSQLManager

 
// MARK: - 9合1

/// 查询当前区域中的所有9in1
- (NSMutableArray *)getNineInOneForZone:(NSUInteger)zoneID {
    
    NSString *ligtSql = [NSString stringWithFormat:@"select ID, ZoneID, NineInOneID, NineInOneName, SubnetID, DeviceID, SwitchIDforControlSure, SwitchIDforControlUp, SwitchIDforControlDown, SwitchIDforControlLeft, SwitchIDforControlRight, SwitchNameforControl1, SwitchIDforControl1,  SwitchNameforControl2, SwitchIDforControl2, SwitchNameforControl3, SwitchIDforControl3,  SwitchNameforControl4, SwitchIDforControl4, SwitchNameforControl5, SwitchIDforControl5, SwitchNameforControl6, SwitchIDforControl6,  SwitchNameforControl7, SwitchIDforControl7, SwitchNameforControl8, SwitchIDforControl8, SwitchIDforNumber0, SwitchIDforNumber1,  SwitchIDforNumber2, SwitchIDforNumber3, SwitchIDforNumber4, SwitchIDforNumber5, SwitchIDforNumber6, SwitchIDforNumber7, SwitchIDforNumber8, SwitchIDforNumber9, SwitchIDforNumberAsterisk, SwitchIDforNumberPound, SwitchNameforSpare1, SwitchIDforSpare1,  SwitchNameforSpare2, SwitchIDforSpare2, SwitchNameforSpare3, SwitchIDforSpare3, SwitchNameforSpare4, SwitchIDforSpare4,  SwitchNameforSpare5, SwitchIDforSpare5,  SwitchNameforSpare6, SwitchIDforSpare6, SwitchNameforSpare7, SwitchIDforSpare7, SwitchNameforSpare8, SwitchIDforSpare8, SwitchNameforSpare9, SwitchIDforSpare9, SwitchNameforSpare10, SwitchIDforSpare10, SwitchNameforSpare11, SwitchIDforSpare11, SwitchNameforSpare12, SwitchIDforSpare12 from NineInOneInZone where ZoneID = %tu order by NineInOneID;", zoneID];
    
    NSArray *array = [SHSQLiteManager.shared selectProprty:ligtSql];
    
    NSMutableArray *nineInOnes = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
    
        [nineInOnes addObject:
            [[SHNineInOne alloc] initWithDict:dict]
        ];
    }
    
    return nineInOnes;
}

/// 更新9in1
- (BOOL)updateNineInOneInZone:(SHNineInOne *)nineInOne {
    
    NSString *updateSQL = [NSString stringWithFormat:@"update NineInOneInZone set                                      \
                           NineInOneName = '%@',                \
                           SubnetID = %d, DeviceID = %d,        \
                           \
                           SwitchIDforControlSure = %tu,        \
                           SwitchIDforControlUp = %tu,          \
                           SwitchIDforControlDown = %tu,        \
                           SwitchIDforControlLeft = %tu,        \
                           SwitchIDforControlRight = %tu,       \
                           \
                           SwitchNameforControl1 = '%@',        \
                           SwitchIDforControl1 = %tu,           \
                           SwitchNameforControl2 = '%@',        \
                           SwitchIDforControl2 = %tu,           \
                           SwitchNameforControl3 = '%@',        \
                           SwitchIDforControl3 = %tu,           \
                           SwitchNameforControl4 = '%@',        \
                           SwitchIDforControl4 = %tu,           \
                           SwitchNameforControl5 = '%@',        \
                           SwitchIDforControl5 = %tu,           \
                           SwitchNameforControl6 = '%@',        \
                           SwitchIDforControl6 = %tu,           \
                           SwitchNameforControl7 = '%@',        \
                           SwitchIDforControl7 = %tu,           \
                           SwitchNameforControl8 = '%@',        \
                           SwitchIDforControl8 = %tu,           \
                           \
                           SwitchIDforNumber0 = %tu,            \
                           SwitchIDforNumber1 = %tu,            \
                           SwitchIDforNumber2 = %tu,            \
                           SwitchIDforNumber3 = %tu,            \
                           SwitchIDforNumber4 = %tu,            \
                           SwitchIDforNumber5 = %tu,            \
                           SwitchIDforNumber6 = %tu,            \
                           SwitchIDforNumber7 = %tu,            \
                           SwitchIDforNumber8 = %tu,            \
                           SwitchIDforNumber9 = %tu,            \
                           SwitchIDforNumberAsterisk = %tu,     \
                           SwitchIDforNumberPound = %tu,         \
                           \
                           SwitchNameforSpare1 = '%@',          \
                           SwitchIDforSpare1 = %tu,             \
                           SwitchNameforSpare2 = '%@',          \
                           SwitchIDforSpare2 = %tu,             \
                           SwitchNameforSpare3 = '%@',          \
                           SwitchIDforSpare3 = %tu,             \
                           SwitchNameforSpare4 = '%@',          \
                           SwitchIDforSpare4 = %tu,             \
                           SwitchNameforSpare5 = '%@',          \
                           SwitchIDforSpare5 = %tu,             \
                           SwitchNameforSpare6 = '%@',          \
                           SwitchIDforSpare6 = %tu,             \
                           SwitchNameforSpare7 = '%@',          \
                           SwitchIDforSpare7 = %tu,             \
                           SwitchNameforSpare8 = '%@',          \
                           SwitchIDforSpare8 = %tu,             \
                           SwitchNameforSpare9 = '%@',          \
                           SwitchIDforSpare9 = %tu,             \
                           SwitchNameforSpare10 = '%@',          \
                           SwitchIDforSpare10 = %tu,             \
                           SwitchNameforSpare11 = '%@',          \
                           SwitchIDforSpare11 = %tu,             \
                           SwitchNameforSpare12 = '%@',          \
                           SwitchIDforSpare12 = %tu              \
                           \
                           where ZoneID = %tu and NineInOneID = %tu;",
                           
                           nineInOne.nineInOneName, nineInOne.subnetID, nineInOne.deviceID, nineInOne.switchIDforControlSure, nineInOne.switchIDforControlUp, nineInOne.switchIDforControlDown, nineInOne.switchIDforControlLeft, nineInOne.switchIDforControlRight,
                           
                           nineInOne.switchNameforControl1, nineInOne.switchIDforControl1,
                           nineInOne.switchNameforControl2, nineInOne.switchIDforControl2,
                           nineInOne.switchNameforControl3, nineInOne.switchIDforControl3,
                           nineInOne.switchNameforControl4, nineInOne.switchIDforControl4,
                           nineInOne.switchNameforControl5, nineInOne.switchIDforControl5,
                           nineInOne.switchNameforControl6, nineInOne.switchIDforControl6,
                           nineInOne.switchNameforControl7, nineInOne.switchIDforControl7,
                           nineInOne.switchNameforControl8, nineInOne.switchIDforControl8,
                           
                           nineInOne.switchIDforNumber0,
                           nineInOne.switchIDforNumber1,
                           nineInOne.switchIDforNumber2,
                           nineInOne.switchIDforNumber3,
                           nineInOne.switchIDforNumber4,
                           nineInOne.switchIDforNumber5,
                           nineInOne.switchIDforNumber6,
                           nineInOne.switchIDforNumber7,
                           nineInOne.switchIDforNumber8,
                           nineInOne.switchIDforNumber9,
                           nineInOne.switchIDforNumberAsterisk,
                           nineInOne.switchIDforNumberPound,
                           
                           nineInOne.switchNameforSpare1,
                           nineInOne.switchIDforSpare1,
                           nineInOne.switchNameforSpare2,
                           nineInOne.switchIDforSpare2,
                           nineInOne.switchNameforSpare3,
                           nineInOne.switchIDforSpare3,
                           nineInOne.switchNameforSpare4,
                           nineInOne.switchIDforSpare4,
                           nineInOne.switchNameforSpare5,
                           nineInOne.switchIDforSpare5,
                           nineInOne.switchNameforSpare6,
                           nineInOne.switchIDforSpare6,
                           nineInOne.switchNameforSpare7,
                           nineInOne.switchIDforSpare7,
                           nineInOne.switchNameforSpare8,
                           nineInOne.switchIDforSpare8,
                           nineInOne.switchNameforSpare9,
                           nineInOne.switchIDforSpare9,
                           nineInOne.switchNameforSpare10,
                           nineInOne.switchIDforSpare10,
                           nineInOne.switchNameforSpare11,
                           nineInOne.switchIDforSpare11,
                           nineInOne.switchNameforSpare12,
                           nineInOne.switchIDforSpare12,
                           
                           nineInOne.zoneID, nineInOne.nineInOneID];
    
    return [SHSQLiteManager.shared executeSql:updateSQL];
}

/// 删除当前的9in1设备
- (BOOL)deleteNineInOneInZone:(SHNineInOne *)nineInOne {
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from NineInOneInZone Where zoneID = %tu and SubnetID = %d and DeviceID = %d and NineInOneID = %tu;", nineInOne.zoneID, nineInOne.subnetID, nineInOne.deviceID, nineInOne.nineInOneID];
    
    return [SHSQLiteManager.shared executeSql:deleteSql];
}

/// 删除区域中的9in1
- (BOOL)deleteZoneNineInOnes:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from NineInOneInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [SHSQLiteManager.shared executeSql:deleteSql];
}

/// 增加一个新的NineInOne
- (BOOL)insertNewNineInOne:(SHNineInOne *)nineInOne {
    
    NSString *sql = [NSString stringWithFormat:@"insert into NineInOneInZone (ZoneID, NineInOneID, NineInOneName, SubnetID, DeviceID,              \
                     SwitchIDforControlSure, SwitchIDforControlUp,      \
                     SwitchIDforControlDown, SwitchIDforControlLeft,    \
                     SwitchIDforControlRight,                           \
                     \
                     SwitchNameforControl1, SwitchIDforControl1,        \
                     SwitchNameforControl2, SwitchIDforControl2,        \
                     SwitchNameforControl3, SwitchIDforControl3,        \
                     SwitchNameforControl4, SwitchIDforControl4,        \
                     SwitchNameforControl5, SwitchIDforControl5,        \
                     SwitchNameforControl6, SwitchIDforControl6,        \
                     SwitchNameforControl7, SwitchIDforControl7,        \
                     SwitchNameforControl8, SwitchIDforControl8,         \
                     \
                     SwitchIDforNumber0, SwitchIDforNumber1,    \
                     SwitchIDforNumber2, SwitchIDforNumber3,    \
                     SwitchIDforNumber4, SwitchIDforNumber5,    \
                     SwitchIDforNumber6, SwitchIDforNumber7,    \
                     SwitchIDforNumber8, SwitchIDforNumber9,    \
                     SwitchIDforNumberAsterisk, SwitchIDforNumberPound, \
                     \
                     SwitchNameforSpare1, SwitchIDforSpare1,    \
                     SwitchNameforSpare2, SwitchIDforSpare2,    \
                     SwitchNameforSpare3, SwitchIDforSpare3,    \
                     SwitchNameforSpare4, SwitchIDforSpare4,    \
                     SwitchNameforSpare5, SwitchIDforSpare5,    \
                     SwitchNameforSpare6, SwitchIDforSpare6,    \
                     SwitchNameforSpare7, SwitchIDforSpare7,    \
                     SwitchNameforSpare8, SwitchIDforSpare8,    \
                     SwitchNameforSpare9, SwitchIDforSpare9,    \
                     SwitchNameforSpare10, SwitchIDforSpare10,  \
                     SwitchNameforSpare11, SwitchIDforSpare11,  \
                     SwitchNameforSpare12, SwitchIDforSpare12  \
                     ) \
                     \
                     values(%tu, %tu, '%@', %d, %d, %tu, %tu, %tu, %tu, %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu, '%@', %tu);",
                     nineInOne.zoneID,
                     nineInOne.nineInOneID,
                     nineInOne.nineInOneName,
                     nineInOne.subnetID,
                     nineInOne.deviceID,
                     
                     nineInOne.switchIDforControlSure,
                     nineInOne.switchIDforControlUp,
                     nineInOne.switchIDforControlDown,
                     nineInOne.switchIDforControlLeft,
                     nineInOne.switchIDforControlRight,
                     
                     nineInOne.switchNameforControl1,
                     nineInOne.switchIDforControl1,
                     nineInOne.switchNameforControl2,
                     nineInOne.switchIDforControl2,
                     nineInOne.switchNameforControl3,
                     nineInOne.switchIDforControl3,
                     nineInOne.switchNameforControl4,
                     nineInOne.switchIDforControl4,
                     nineInOne.switchNameforControl5,
                     nineInOne.switchIDforControl5,
                     nineInOne.switchNameforControl6,
                     nineInOne.switchIDforControl6,
                     nineInOne.switchNameforControl7,
                     nineInOne.switchIDforControl7,
                     nineInOne.switchNameforControl8,
                     nineInOne.switchIDforControl8,
                     
                     nineInOne.switchIDforNumber0,
                     nineInOne.switchIDforNumber1,
                     nineInOne.switchIDforNumber2,
                     nineInOne.switchIDforNumber3,
                     nineInOne.switchIDforNumber4,
                     nineInOne.switchIDforNumber5,
                     nineInOne.switchIDforNumber6,
                     nineInOne.switchIDforNumber7,
                     nineInOne.switchIDforNumber8,
                     nineInOne.switchIDforNumber9,
                     nineInOne.switchIDforNumberAsterisk,
                     nineInOne.switchIDforNumberPound,
                     
                     nineInOne.switchNameforSpare1,
                     nineInOne.switchIDforSpare1,
                     nineInOne.switchNameforSpare2,
                     nineInOne.switchIDforSpare2,
                     nineInOne.switchNameforSpare3,
                     nineInOne.switchIDforSpare3,
                     nineInOne.switchNameforSpare4,
                     nineInOne.switchIDforSpare4,
                     nineInOne.switchNameforSpare5,
                     nineInOne.switchIDforSpare5,
                     nineInOne.switchNameforSpare6,
                     nineInOne.switchIDforSpare6,
                     nineInOne.switchNameforSpare7,
                     nineInOne.switchIDforSpare7,
                     nineInOne.switchNameforSpare8,
                     nineInOne.switchIDforSpare8,
                     nineInOne.switchNameforSpare9,
                     nineInOne.switchIDforSpare9,
                     nineInOne.switchNameforSpare10,
                     nineInOne.switchIDforSpare10,
                     nineInOne.switchNameforSpare11,
                     nineInOne.switchIDforSpare11,
                     nineInOne.switchNameforSpare12,
                     nineInOne.switchIDforSpare12
                     ];
    
    return [SHSQLiteManager.shared executeSql:sql];
    
}

/// 获得当前区域中的最大的NineInOneID
- (NSUInteger)getMaxNineInOneIDForZone:(NSUInteger)zoneID {
    
    NSString *sql = [NSString stringWithFormat:@"select max(NineInOneID) from NineInOneInZone where ZoneID = %tu;", zoneID];
    
    id resID = [[[SHSQLiteManager.shared selectProprty:sql] lastObject] objectForKey:@"max(NineInOneID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 增加9合1
- (BOOL)addNineInOne {
    
    NSString *selectSQL = [NSString stringWithFormat:@"select Distinct SystemID from systemDefnition where SystemID = %tu;", SHSystemDeviceTypeNineInOne];
    
    // 如果不存在
    if ([[SHSQLiteManager.shared selectProprty:selectSQL] count]) {
        
        return YES;
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into systemDefnition (SystemID, SystemName) values(%tu, '%@');", SHSystemDeviceTypeNineInOne, @"9in1"];
    
    return [SHSQLiteManager.shared executeSql:insertSQL];
}


// MARK: - Schedual

/// 获得指定的计划
- (SHSchedual *)getSchedualFor:(NSUInteger)findSchedualID {
    
    NSArray *scheduals = [self getAllSchdule];
    
    for (SHSchedual *schedual in scheduals) {
        
        if (schedual.scheduleID == findSchedualID) {
            return schedual;
        }
    }
    
    return nil;
}

/// 获得计划的命令集
- (NSMutableArray *)getSchedualCommands:(NSUInteger)findSchedualID {
    
    NSString *sql = [NSString stringWithFormat:@"select ID, ScheduleID, typeID, parameter1, parameter2, parameter3, parameter4, parameter5, parameter6 from ScheduleCommands where ScheduleID = %tu;", findSchedualID];
    
    NSArray *array = [SHSQLiteManager.shared selectProprty:sql];
    
    NSMutableArray *commands = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [commands addObject:
            [[SHSchedualCommand alloc] initWithDict:dict]
        ];
    }
    
    return commands;
}

// MARK: - schedaul 相关的操作

/// 获得所有的计划
- (NSMutableArray *)getAllSchdule {
    
    NSString *schduleSql = @"select ID, ScheduleID, ScheduleName, EnabledSchedule, ControlledItemID, ZoneID, FrequencyID, WithSunday, WithMonday, WithTuesday, WithWednesday, WithThursday, WithFriday, WithSaturday, ExecutionHours, ExecutionMins, ExecutionDate, HaveSound from Schedules;";
    
    NSArray *array = [SHSQLiteManager.shared selectProprty:schduleSql];
    
    NSMutableArray *schdules = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        SHSchedual *schdule = [SHSchedual schedualWithDictionary:dict];
        
        [schdules addObject: schdule];
    }
    
    return schdules;
}

/// 获得最大的计划ID
- (NSUInteger)getMaxScheduleID {
    
    // 获得结果ID
    id resID = [[[SHSQLiteManager.shared selectProprty:@"select max(scheduleID) from Schedules"] lastObject] objectForKey:@"max(scheduleID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 更新计划
- (BOOL)updateSchedule:(SHSchedual *)schedual {
    
    NSString *updateScheduleSql = [NSString stringWithFormat:@"update Schedules set ScheduleName = '%@', EnabledSchedule = %tu, ControlledItemID = %tu, ZoneID = %tu, FrequencyID = %tu, WithSunday = %d, WithMonday = %d, WithTuesday = %d, WithWednesday = %d, WithThursday = %d, WithFriday = %d, WithSaturday = %d, ExecutionHours = %d, ExecutionMins = %d, ExecutionDate = '%@', HaveSound = %tu where ScheduleID = %tu;",
                                   schedual.scheduleName,
                                   schedual.enabledSchedule,
                                   schedual.controlledItemID,
                                   schedual.zoneID,
                                   schedual.frequencyID,
                                   schedual.withSunday,
                                   schedual.withMonday,
                                   schedual.withTuesday,
                                   schedual.withWednesday,
                                   schedual.withThursday,
                                   schedual.withFriday,
                                   schedual.withSaturday,
                                   schedual.executionHours,
                                   schedual.executionMins,
                                   schedual.executionDate,
                                   schedual.haveSound,
                                   schedual.scheduleID];
    
    return [SHSQLiteManager.shared executeSql:updateScheduleSql];
}

/// 获得Schedual中的最大的ID
- (NSUInteger)getMaxSchedualID {
    
    // 获得结果ID
    id resID = [[[SHSQLiteManager.shared selectProprty:@"select max(ID) from Schedules"] lastObject] objectForKey:@"max(ID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 获得ScheduleCommands中的最大ID
- (NSUInteger)getMaxIDForSchedualCommand {
    
    // 获得结果ID
    id resID = [[[SHSQLiteManager.shared selectProprty:@"select max(ID) from ScheduleCommands"] lastObject] objectForKey:@"max(ID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 插入计划要执行的命令
- (void)insertNewSchedualeCommand:(SHSchedualCommand *)schedualCommand {
    
    NSUInteger maxID = [self getMaxIDForSchedualCommand] + 1;
    
    NSString *inserCommandSql = [NSString stringWithFormat:@"insert into ScheduleCommands values(%tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu);", maxID, schedualCommand.scheduleID, schedualCommand.typeID, schedualCommand.parameter1, schedualCommand.parameter2, schedualCommand.parameter3, schedualCommand.parameter4, schedualCommand.parameter5, schedualCommand.parameter6];
    
    [SHSQLiteManager.shared executeSql:inserCommandSql];
    
    //    // 查找要的计划命令集
    //    NSMutableArray *commands = [self getSchedualCommands:schedualCommand.scheduleID];
    //
    //    // 没有找到，还不存在，直接插入
    //    if (!commands.count) {
    //
    //        // 新增
    //        NSUInteger maxID = [self getMaxIDForSchedualCommand] + 1;
    //
    //        NSString *inserCommandSql = [NSString stringWithFormat:@"insert into ScheduleCommands values(%zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd);", maxID, schedualCommand.scheduleID, schedualCommand.typeID, schedualCommand.parameter1, schedualCommand.parameter2, schedualCommand.parameter3, schedualCommand.parameter4, schedualCommand.parameter5, schedualCommand.parameter6];
    //
    //        [self executeSql:inserCommandSql];
    //
    //        return;
    //    }
    //
    //    // 更新
    //    NSString *updateCommandSql = [NSString stringWithFormat:@"update ScheduleCommands set parameter1 = %zd, parameter2 = %zd, parameter3 = %zd, parameter4 = %zd, parameter5 = %zd, parameter6 = %zd where typeID = %zd and ScheduleID = %zd;", schedualCommand.parameter1, schedualCommand.parameter2, schedualCommand.parameter3, schedualCommand.parameter4, schedualCommand.parameter5, schedualCommand.parameter6, schedualCommand.typeID, schedualCommand.scheduleID];
    //
    //    [self executeSql:updateCommandSql];
}

/// 插入新的计划
- (void)insertNewScheduale:(SHSchedual *)schedual {
    
    NSUInteger maxScedualID = [self getMaxSchedualID] + 1;
    
    NSString *insertSql = [NSString stringWithFormat:
                           @"insert into Schedules values                   \
                           (%tu, %tu, '%@', %d, %tu, %tu, %tu,             \
                           %d, %d, %d, %d, %d, %d, %d, %d, %d, '%@', %tu); ",
                           
                           maxScedualID, schedual.scheduleID,
                           schedual.scheduleName, (schedual.enabledSchedule ? 1 : 0),
                           schedual.controlledItemID, schedual.zoneID,
                           schedual.frequencyID,
                           
                           schedual.withSunday, schedual.withMonday,
                           schedual.withTuesday, schedual.withWednesday,
                           schedual.withThursday, schedual.withFriday,
                           schedual.withSaturday, schedual.executionHours,
                           schedual.executionMins, schedual.executionDate,
                           schedual.haveSound
                           ];
    
    // 插入新的 schedual
    [SHSQLiteManager.shared executeSql:insertSql];
}

/// 删除计划及命令
- (BOOL)deleteScheduale:(SHSchedual *)schedual {
    
    // 1. 删除命令
    NSString *schdualSql = [NSString stringWithFormat:
                            @"delete from Schedules where ScheduleID = %tu;", schedual.scheduleID];
    
    BOOL deleteSchdual = [SHSQLiteManager.shared executeSql:schdualSql];
    
    // 2. 删除计划中的命令
    NSString *commandSql = [NSString stringWithFormat:
                            @"delete from ScheduleCommands where ScheduleID = %tu;",
                            schedual.scheduleID];
    
    BOOL deleteCommand = [SHSQLiteManager.shared executeSql:commandSql];
    
    return deleteSchdual && deleteCommand;
}

/// 删除schedual中的执行 指令
- (BOOL)deleteSchedualeCommand:(SHSchedual *)schedual {
    
    NSString *deleteCommandSql = [NSString stringWithFormat:
                                  @"delete from ScheduleCommands where ScheduleID = %tu and typeID = %tu;",
                                  schedual.scheduleID,
                                  schedual.controlledItemID];
    
    return [SHSQLiteManager.shared executeSql:deleteCommandSql];
}
 
// MARK: - 多媒体设备的操作
 

/// 获得当前区域的投影仪
- (NSMutableArray *)getMediaProjectorFor:(NSUInteger)zoneID {
    
    NSString *tvSql = [NSString stringWithFormat:@"select ID, remark, ZoneID, SubnetID, DeviceID, UniversalSwitchIDforOn, UniversalSwitchStatusforOn, UniversalSwitchIDforOff, UniversalSwitchStatusforOff, UniversalSwitchIDfoMenu, UniversalSwitchIDfoUp, UniversalSwitchIDforDown, UniversalSwitchIDforLeft, UniversalSwitchIDforRight, UniversalSwitchIDforOK, UniversalSwitchIDforSource, IRMacroNumberForProjectorSpare0, IRMacroNumberForProjectorSpare1, IRMacroNumberForProjectorSpare2, IRMacroNumberForProjectorSpare3, IRMacroNumberForProjectorSpare4, IRMacroNumberForProjectorSpare5 from ProjectorInZone where ZoneID = %tu order by id;",  zoneID];
    
    NSArray *array = [SHSQLiteManager.shared selectProprty:tvSql];
    
    if (!array.count) {
        return nil;
    }
    
    NSMutableArray *projectors = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [projectors addObject:
            [[SHMediaProjector alloc] initWithDict:dict]
        ];
    }
    
    return projectors;
}


/// 删除投影仪
- (BOOL)deleteProjectorInZone:(SHMediaProjector *)mediaProjector {
    
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from ProjectorInZone Where zoneID = %tu \
                           and SubnetID = %d and DeviceID = %d;",
                           
                           mediaProjector.zoneID,
                           mediaProjector.subnetID,
                           mediaProjector.deviceID];
    
    return [SHSQLiteManager.shared executeSql:deleteSql];
}

/// 删除区域中的投影仪
- (BOOL)deleteZoneProjectors:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from ProjectorInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [SHSQLiteManager.shared executeSql:deleteSql];
}

/// 保存投影仪数据
- (void)saveMediaProjectorInZone:(SHMediaProjector *)mediaProjector {
    
    NSString *saveSql = [NSString stringWithFormat:
                         @"update ProjectorInZone set remark = '%@',        \
                         SubnetID = %d, DeviceID = %d,  \
                         UniversalSwitchIDforOn = %tu,          \
                         UniversalSwitchStatusforOn = %tu,      \
                         UniversalSwitchIDforOff = %tu,         \
                         UniversalSwitchStatusforOff = %tu,     \
                                                                \
                         UniversalSwitchIDfoUp = %tu,           \
                         UniversalSwitchIDforDown = %tu,        \
                         UniversalSwitchIDforLeft = %tu,        \
                         UniversalSwitchIDforRight = %tu,       \
                         UniversalSwitchIDforOK = %tu,          \
                         UniversalSwitchIDfoMenu = %tu,         \
                         UniversalSwitchIDforSource = %tu,      \
                                                                \
                         IRMacroNumberForProjectorSpare0 = %tu, \
                         IRMacroNumberForProjectorSpare1 = %tu, \
                         IRMacroNumberForProjectorSpare2 = %tu, \
                         IRMacroNumberForProjectorSpare3 = %tu, \
                         IRMacroNumberForProjectorSpare4 = %tu, \
                         IRMacroNumberForProjectorSpare5 = %tu  \
                         Where zoneID = %tu;",
                         
                         mediaProjector.remark,
                         mediaProjector.subnetID,
                         mediaProjector.deviceID,
                         
                         mediaProjector.universalSwitchIDforOn,
                         mediaProjector.universalSwitchStatusforOn,
                         mediaProjector.universalSwitchIDforOff,
                         mediaProjector.universalSwitchStatusforOff,
                         
                         mediaProjector.universalSwitchIDfoUp,
                         mediaProjector.universalSwitchIDforDown,
                         mediaProjector.universalSwitchIDforLeft,
                         mediaProjector.universalSwitchIDforRight,
                         mediaProjector.universalSwitchIDforOK,
                         mediaProjector.universalSwitchIDfoMenu,
                         mediaProjector.universalSwitchIDforSource,
                         
                        mediaProjector.iRMacroNumberForProjectorSpare0,
                         
                        mediaProjector.iRMacroNumberForProjectorSpare1,
                        mediaProjector.iRMacroNumberForProjectorSpare2,
                        mediaProjector.iRMacroNumberForProjectorSpare3,
                        mediaProjector.iRMacroNumberForProjectorSpare4,
                        mediaProjector.iRMacroNumberForProjectorSpare5,
                         
                        mediaProjector.zoneID
                         ];
    
    [SHSQLiteManager.shared executeSql:saveSql];
}

/// 增加新的投影仪
- (NSInteger)insertNewMediaProjector:(SHMediaProjector *)mediaProjector {
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into ProjectorInZone (remark, ZoneID, SubnetID, DeviceID, UniversalSwitchIDforOn, UniversalSwitchStatusforOn, UniversalSwitchIDforOff, UniversalSwitchStatusforOff, UniversalSwitchIDfoUp, UniversalSwitchIDforDown, UniversalSwitchIDforLeft, UniversalSwitchIDforRight, UniversalSwitchIDforOK, UniversalSwitchIDfoMenu, UniversalSwitchIDforSource, IRMacroNumberForProjectorSpare0, IRMacroNumberForProjectorSpare1, IRMacroNumberForProjectorSpare2, IRMacroNumberForProjectorSpare3, IRMacroNumberForProjectorSpare4, IRMacroNumberForProjectorSpare5) values('%@', %tu, %d, %d, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu);",
                           mediaProjector.remark,
                           mediaProjector.zoneID,
                           mediaProjector.subnetID,
                           mediaProjector.deviceID,
                           
                           mediaProjector.universalSwitchIDforOn,
                           mediaProjector.universalSwitchStatusforOn,
                           mediaProjector.universalSwitchIDforOff,
                           mediaProjector.universalSwitchStatusforOff,
                           
                           mediaProjector.universalSwitchIDfoUp,
                           mediaProjector.universalSwitchIDforDown,
                           mediaProjector.universalSwitchIDforLeft,
                           mediaProjector.universalSwitchIDforRight,
                           mediaProjector.universalSwitchIDforOK,
                           mediaProjector.universalSwitchIDfoMenu,
                           mediaProjector.universalSwitchIDforSource,
                           
                           mediaProjector.iRMacroNumberForProjectorSpare0,
                           mediaProjector.iRMacroNumberForProjectorSpare1,
                           mediaProjector.iRMacroNumberForProjectorSpare2,
                           mediaProjector.iRMacroNumberForProjectorSpare3,
                           mediaProjector.iRMacroNumberForProjectorSpare4,
                           mediaProjector.iRMacroNumberForProjectorSpare5];
    
    BOOL res = [SHSQLiteManager.shared executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        return [[[[SHSQLiteManager.shared selectProprty:@"select max(ID) from ProjectorInZone;"] lastObject] objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}
 

// MARK: - 区域图片操作

/// 根据名称获得图片
- (SHIcon *)getIcon:(NSString *)iconName {
    
    NSString *selectSQL = [NSString stringWithFormat:@"select iconID, iconName, iconData from iconList where iconName = '%@';", iconName];
    
    return [[SHIcon alloc] initWithDict:[[SHSQLiteManager.shared selectProprty:selectSQL] lastObject]];
}

/// 获得最大的图标ID
- (NSUInteger)getMaxIconID {
    
    // 获得结果ID
    id resID = [[[SHSQLiteManager.shared selectProprty:@"select max(iconID) from iconList"] lastObject] objectForKey:@"max(iconID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 删除一个图片记录
- (BOOL)deleteIcon:(SHIcon *)icon {
    
    NSString *iconSql = [NSString stringWithFormat:@"delete from iconList where iconID = %tu;", icon.iconID];
    
    return [SHSQLiteManager.shared executeSql:iconSql];
}

/// 插入一个新图片
- (BOOL)inserNewIcon:(SHIcon *)icon {
    
    __block BOOL res = YES;
    [SHSQLiteManager.shared.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        // 这种语法相当怪异
        res = [db executeUpdate:@"INSERT INTO iconList (iconID, iconName, iconData) VALUES (?, ?, ?);", @(icon.iconID), icon.iconName, icon.iconData];
    }];
    
    return res;
}

/// 查询所有的图标
- (NSMutableArray *)getAllIcons {
    
    NSString *iconsSql = @"select iconID, iconName, iconData from iconList order by iconID";
    
    NSArray *array = [SHSQLiteManager.shared selectProprty:iconsSql];
    
    NSMutableArray *icons = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [icons addObject:[[SHIcon alloc] initWithDict:dict]];
    }
    
    return icons;
}

/// 增加图片的二进制字段
- (BOOL)addZoneIconData {
    
    if (![SHSQLiteManager.shared isColumnName:@"iconData" consistinTable:@"iconList"]) {
        
        // 增加remark
        [SHSQLiteManager.shared executeSql:@"ALTER TABLE iconList ADD iconData DATA;"];
        
        // 原来沙盒中的图全部获取出来，导入到数据库当中
        NSString *imagesSQL = [NSString stringWithFormat:@"select iconID, iconName from iconList where iconID > %tu;", maxIconIDForDataBase];
        
        NSArray *array = [SHSQLiteManager.shared selectProprty:imagesSQL];
        
        /// 有数据
        if (array.count) {
            
            for (NSDictionary *dict in array) {
                
                SHIcon *icon = [[SHIcon alloc] init];
                icon.iconID = [dict[@"iconID"] integerValue];
                icon.iconName = dict[@"iconName"];
                
                icon.iconData = UIImagePNGRepresentation([UIImage getZoneControlImageForZones:icon.iconName]);
                
                // 更新进入到数据  先删除原来的数据，再插入新数据 == 先前使用的更新，二进制总是有问题，加载时崩溃，所以使用这种方案
                [self deleteIcon:icon];
                [self inserNewIcon:icon];
            }
            
            // 执行到了这里，图片都处理完成了，直接删除这个文件夹
            [[NSFileManager defaultManager] removeItemAtPath:[UIImage zoneControlImageFloderPath] error:nil];
        }
    }
    
    return YES;
}


/// 创建数据库
- (instancetype)init {
    
    if (self = [super init]) {
     
        // 增加9in1
        [self addNineInOne];
        
        // 增加图片的二进制数据
        [self addZoneIconData];
    }
    
    return self;
}

SingletonImplementation(SQLManager)

@end
