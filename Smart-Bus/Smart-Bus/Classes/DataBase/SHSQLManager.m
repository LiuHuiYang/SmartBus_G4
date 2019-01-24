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
      
        // 增加图片的二进制数据
        [self addZoneIconData];
    }
    
    return self;
}

SingletonImplementation(SQLManager)

@end
