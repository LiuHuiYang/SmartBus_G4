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

/// 数据库的名称
NSString * dataBaseName = @"SMART-BUS.sqlite";

/// 沙盒记录版本
NSString * const sandboxVersionKey = @"sandboxVersionKey";

// 在数据库中可以iconList直接查询到
const NSUInteger maxIconIDForDataBase = 10;

@interface SHSQLManager ()


@end

@implementation SHSQLManager

// MARK: - DMX


/// 更新通道
- (BOOL)updateDmxChannel:(SHDmxChannel *)dmxChannel {
    
    NSString *updateChannelSQL = [NSString stringWithFormat:@"update    \
                                  dmxChannelInZone set remark = '%@',    \
                                  channelType = %tu, SubnetID = %d,    \
                                  DeviceID = %d, channelNo = %d where \
                                  id = %tu;",
                                  dmxChannel.remark,
                                  dmxChannel.channelType,
                                  dmxChannel.subnetID,
                                  dmxChannel.deviceID,
                                  dmxChannel.channelNo,
                                  dmxChannel.id];
    
    
    return [self executeSql:updateChannelSQL];
}

/// 删除通道
- (BOOL)deleteDmxChannel:(SHDmxChannel *)dmxChannel {
    
    NSString *deleteChannelSQL = [NSString stringWithFormat:@"delete from   \
                                  dmxChannelInZone where ZoneID = %tu and   \
                                  groupID = %tu and SubnetID = %d and  \
                                  DeviceID = %d and channelNo = %d;",
                                  dmxChannel.zoneID,
                                  dmxChannel.groupID,
                                  dmxChannel.subnetID,
                                  dmxChannel.deviceID,
                                  dmxChannel.channelNo];
    
    return [self executeSql:deleteChannelSQL];
}

/// 删除区域中的所有DMX
- (BOOL)deleteZoneDMXs:(NSUInteger)zoneID {
    
    // 删除通道
    NSString *deleteChannelSQL =
        [NSString stringWithFormat:
            @"delete from dmxChannelInZone where ZoneID = %tu;",
            zoneID
        ];
    
    BOOL deleteChannel = [self executeSql:deleteChannelSQL];
    
    // 删除分组
    NSString *deleteGroupSQL =
        [NSString stringWithFormat:
            @"delete from dmxGroupInZone where ZoneID = %tu;",
            zoneID
        ];
    
    BOOL deleteGroup = [self executeSql:deleteGroupSQL];
    
    return deleteChannel && deleteGroup;
}

/// 增加新的通道
- (NSInteger)insertNewDmxChannnel:(SHDmxChannel *)dmxChannel {
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into  \
                           dmxChannelInZone (ZoneID, groupID, groupName)    \
                           values(%tu, %tu, '%@');",
                           dmxChannel.zoneID,
                           dmxChannel.groupID,
                           dmxChannel.groupName];
    
    
    BOOL res = [self executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        // 获得ID号
        NSString *string = [NSString stringWithFormat:@"select max(ID) from dmxChannelInZone;"];
        
        maxID =  [[[[self selectProprty:string] lastObject] objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}

/// 更新分组信息
- (BOOL)updateDmxGroup:(SHDmxGroup *)dmxGroup {
    
    NSString *updateSQL =
        [NSString stringWithFormat:
            @"update dmxGroupInZone set groupName = '%@'   \
            where ZoneID = %tu and groupID = %tu; ",
         
            dmxGroup.groupName, dmxGroup.zoneID, dmxGroup.groupID
        ];
    
    return [self executeSql:updateSQL];
}

/// 增加新的分组
- (BOOL)insertNewDmxGroup:(SHDmxGroup *)dmxGroup {
    
    NSString *insertSQL =
        [NSString stringWithFormat:
            @"insert into dmxGroupInZone(ZoneID, groupID)   \
                values(%tu, %tu);",
            dmxGroup.zoneID, dmxGroup.groupID
        ];
    
    return [self executeSql:insertSQL];
}

/// 获得指定区域的最大分组ID
- (NSUInteger)getMaxDmxGrooupGroupIDFor:(NSUInteger)zoneID {
    
    NSString *maxGroupIDsql =
        [NSString stringWithFormat:
            @"select max(groupID) from dmxGroupInZone   \
            where ZoneID = %tu;", zoneID
        ];
    
    id resID = [[[self selectProprty:maxGroupIDsql] lastObject]
                objectForKey:@"max(groupID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 删除指定的DMX分组
- (BOOL)deleteDmxGroup:(SHDmxGroup *)dmxGroup {
    
    // 删除分组
    NSString *deleteGruopSQL =
        [NSString stringWithFormat:
            @"delete from dmxGroupInZone where ZoneID = %tu and   \
                                groupID = %tu;",
              dmxGroup.zoneID, dmxGroup.groupID
        ];
    
    BOOL deleteGroup = [self executeSql:deleteGruopSQL];
    
    // 同时删除通道
    NSString *deleteChannelSQL =
        [NSString stringWithFormat:
            @"delete from dmxChannelInZone where ZoneID = %tu and   \
            groupID = %tu;",
         
         dmxGroup.zoneID, dmxGroup.groupID
        ];
    
    BOOL deleteChannel = [self executeSql:deleteChannelSQL];
    
    return deleteGroup && deleteChannel;
}

/// 获得分组的通道
- (NSMutableArray *)getDmxGroupChannels:(SHDmxGroup *)dmxGroup {
    
    NSString *selectSQL =
        [NSString stringWithFormat:
            @"select ID, ZoneID, groupID, groupName, remark,    \
            channelType, SubnetID, DeviceID, channelNo from     \
            dmxChannelInZone where ZoneID = %tu and groupID = %tu;",
                           dmxGroup.zoneID, dmxGroup.groupID
        ];
    
    NSArray *array = [self selectProprty:selectSQL];
    
    NSMutableArray *channels = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [channels addObject:
            [[SHDmxChannel alloc] initWithDict:dict]
        ];
    }
    
    return channels;
}


/// 获得指定区域的DMX分组
- (NSMutableArray *)getZoneDmxGroup:(NSUInteger)zoneID {
    
    NSString *selectSQL =
        [NSString stringWithFormat:
                @"select ID, ZoneID, groupID, groupName from    \
                dmxGroupInZone    where ZoneID = %tu;",
            zoneID
        ];
    
    NSArray *array = [self selectProprty:selectSQL];
    
    NSMutableArray *group = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [group addObject:[[SHDmxGroup alloc] initWithDict:dict]];
    }
    
    return group;
}


/// 增加DMX的字段
- (BOOL)addZoneDMX {

    NSString *selectSQL =
        [NSString stringWithFormat:
            @"select Distinct SystemID from systemDefnition     \
            where SystemID = %tu;",
            SHSystemDeviceTypeDmx
        ];
    
    if ([[self selectProprty:selectSQL] count]) {
        
        return YES;
    }
    
    NSString *insertSQL =
        [NSString stringWithFormat:
            @"insert into systemDefnition (SystemID, SystemName)    \
                values(%tu, '%@');",
            SHSystemDeviceTypeDmx, @"dmx"
        ];
    
    return [self executeSql:insertSQL];
}


// MARK: - 9合1

/// 查询当前区域中的所有9in1
- (NSMutableArray *)getNineInOneForZone:(NSUInteger)zoneID {
    
    NSString *ligtSql = [NSString stringWithFormat:@"select ID, ZoneID, NineInOneID, NineInOneName, SubnetID, DeviceID, SwitchIDforControlSure, SwitchIDforControlUp, SwitchIDforControlDown, SwitchIDforControlLeft, SwitchIDforControlRight, SwitchNameforControl1, SwitchIDforControl1,  SwitchNameforControl2, SwitchIDforControl2, SwitchNameforControl3, SwitchIDforControl3,  SwitchNameforControl4, SwitchIDforControl4, SwitchNameforControl5, SwitchIDforControl5, SwitchNameforControl6, SwitchIDforControl6,  SwitchNameforControl7, SwitchIDforControl7, SwitchNameforControl8, SwitchIDforControl8, SwitchIDforNumber0, SwitchIDforNumber1,  SwitchIDforNumber2, SwitchIDforNumber3, SwitchIDforNumber4, SwitchIDforNumber5, SwitchIDforNumber6, SwitchIDforNumber7, SwitchIDforNumber8, SwitchIDforNumber9, SwitchIDforNumberAsterisk, SwitchIDforNumberPound, SwitchNameforSpare1, SwitchIDforSpare1,  SwitchNameforSpare2, SwitchIDforSpare2, SwitchNameforSpare3, SwitchIDforSpare3, SwitchNameforSpare4, SwitchIDforSpare4,  SwitchNameforSpare5, SwitchIDforSpare5,  SwitchNameforSpare6, SwitchIDforSpare6, SwitchNameforSpare7, SwitchIDforSpare7, SwitchNameforSpare8, SwitchIDforSpare8, SwitchNameforSpare9, SwitchIDforSpare9, SwitchNameforSpare10, SwitchIDforSpare10, SwitchNameforSpare11, SwitchIDforSpare11, SwitchNameforSpare12, SwitchIDforSpare12 from NineInOneInZone where ZoneID = %tu order by NineInOneID;", zoneID];
    
    NSMutableArray *array = [self selectProprty:ligtSql];
    
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
    
    return [self executeSql:updateSQL];
}

/// 删除当前的9in1设备
- (BOOL)deleteNineInOneInZone:(SHNineInOne *)nineInOne {
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from NineInOneInZone Where zoneID = %tu and SubnetID = %d and DeviceID = %d and NineInOneID = %tu;", nineInOne.zoneID, nineInOne.subnetID, nineInOne.deviceID, nineInOne.nineInOneID];
    
    return [self executeSql:deleteSql];
}

/// 删除区域中的9in1
- (BOOL)deleteZoneNineInOnes:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from NineInOneInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
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
    
    return [self executeSql:sql];
    
}

/// 获得当前区域中的最大的NineInOneID
- (NSUInteger)getMaxNineInOneIDForZone:(NSUInteger)zoneID {
    
    NSString *sql = [NSString stringWithFormat:@"select max(NineInOneID) from NineInOneInZone where ZoneID = %tu;", zoneID];
    
    id resID = [[[self selectProprty:sql] lastObject] objectForKey:@"max(NineInOneID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 增加9合1
- (BOOL)addNineInOne {
    
    NSString *selectSQL = [NSString stringWithFormat:@"select Distinct SystemID from systemDefnition where SystemID = %tu;", SHSystemDeviceTypeNineInOne];
    
    // 如果不存在
    if ([[self selectProprty:selectSQL] count]) {
        
        return YES;
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into systemDefnition (SystemID, SystemName) values(%tu, '%@');", SHSystemDeviceTypeNineInOne, @"9in1"];
    
    return [self executeSql:insertSQL];
}

// MARK: - 地热

/// 查询当前区域中的所有地热
- (NSMutableArray *)getFloorHeatingForZone:(NSUInteger)zoneID {
    
    NSString *ligtSql = [NSString stringWithFormat:@"select id, ZoneID, FloorHeatingID, FloorHeatingRemark, SubnetID, DeviceID, ChannelNo, outsideSensorSubNetID, outsideSensorDeviceID, outsideSensorChannelNo from FloorHeatingInZone where ZoneID = %tu order by FloorHeatingID;", zoneID];
    
    NSMutableArray *array = [self selectProprty:ligtSql];
    
    NSMutableArray *floorHeatings = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        [floorHeatings addObject:
            [[SHFloorHeating alloc] initWithDict:dict]
        ];
    }
    
    return floorHeatings;
}

/// 更新当前地热设备的数据
- (void)updateFloorHeatingInZone:(SHFloorHeating *)floorHeating {
    
    NSString *updateSql = [NSString stringWithFormat:
                           @"update FloorHeatingInZone set ZoneID = %tu,    \
                           FloorHeatingID = %tu, FloorHeatingRemark = '%@', \
                           SubnetID = %d, DeviceID = %d, ChannelNo = %d,    \
                           outsideSensorSubNetID = %d,                      \
                           outsideSensorDeviceID = %d,                      \
                           outsideSensorChannelNo = %d Where zoneID = %tu   \
                           and FloorHeatingID = %tu;",
                           
                           floorHeating.zoneID,
                           floorHeating.floorHeatingID,
                           floorHeating.floorHeatingRemark,
                           floorHeating.subnetID,
                           floorHeating.deviceID,
                           floorHeating.channelNo,
                           floorHeating.outsideSensorSubNetID,
                           floorHeating.outsideSensorDeviceID,
                           floorHeating.outsideSensorChannelNo,
                           floorHeating.zoneID,
                           floorHeating.floorHeatingID
                           ];
    
    [self executeSql:updateSql];
}

/// 增加地热
- (BOOL)insertNewFloorHeating:(SHFloorHeating *)floorHeating {
    
    NSString *sql = [NSString stringWithFormat:
                     @"insert into FloorHeatingInZone (ZoneID, FloorHeatingID, \
                     FloorHeatingRemark, SubnetID, DeviceID, ChannelNo,        \
                     outsideSensorSubNetID, outsideSensorDeviceID,             \
                     outsideSensorChannelNo)                                   \
                     values(%tu, %tu, '%@', %d, %d, %d, %d, %d, %d);",
                     
                     floorHeating.zoneID,
                     floorHeating.floorHeatingID,
                     floorHeating.floorHeatingRemark,
                     floorHeating.subnetID,
                     floorHeating.deviceID,
                     floorHeating.channelNo,
                     floorHeating.outsideSensorSubNetID,
                     floorHeating.outsideSensorDeviceID,
                     floorHeating.outsideSensorChannelNo];
    
    return [self executeSql:sql];
}

/// 删除当前的地热设备
- (BOOL)deleteFloorHeatingInZone:(SHFloorHeating *)floorHeating {
    
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from FloorHeatingInZone Where           \
                           zoneID = %tu and SubnetID = %d and DeviceID = %d \
                           and ChannelNo = %d and FloorHeatingID = %tu;",
                           floorHeating.zoneID,
                           floorHeating.subnetID,
                           floorHeating.deviceID,
                           floorHeating.channelNo,
                           floorHeating.floorHeatingID
                           ];
    
    return [self executeSql:deleteSql];
}

/// 删除区域中的地热
- (BOOL)deleteZoneFloorHeatings:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from FloorHeatingInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
}


/// 获得当前区域中的最大的FloorHeatingInZone
- (NSUInteger)getMaxFloorHeatingIDForZone:(NSUInteger)zoneID {
    
    NSString *sql = [NSString stringWithFormat:@"select max(FloorHeatingID) from FloorHeatingInZone where ZoneID = %tu;", zoneID];
    
    id resID = [[[self selectProprty:sql] lastObject] objectForKey:@"max(FloorHeatingID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 增加系统地热的系统ID
- (BOOL)addFloorHeating {
    
    NSString *selectSQL = [NSString stringWithFormat:@"select Distinct SystemID from systemDefnition where SystemID = %tu;", SHSystemDeviceTypeFloorHeating];
    
    // 如果不存在
    if ([[self selectProprty:selectSQL] count]) {
        
        return YES;
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into systemDefnition (SystemID, SystemName) values(%tu, '%@');", SHSystemDeviceTypeFloorHeating, @"FloorHeating"];
    
    return [self executeSql:insertSQL];
}

// MARK: - Mood

/// 增加延时字段
- (void)addMoodCommandDelaytime {
    
    if (![self isColumnName:@"DelayMillisecondAfterSend" consistinTable:@"MoodCommands"]) {
        
        // 增加remark
        [self executeSql:@"ALTER TABLE MoodCommands ADD DelayMillisecondAfterSend INTEGER NOT NULL DEFAULT 100;"];
    }
}


- (NSMutableArray *)getAllMoodCommandsFor:(SHMood *)mood {
    
    NSString *sql = [NSString stringWithFormat:@"select ID, ZoneID, MoodID, deviceType, SubnetID, DeviceID, deviceName, Parameter1, Parameter2, Parameter3, Parameter4, Parameter5, Parameter6, DelayMillisecondAfterSend from MoodCommands where ZoneID = %tu and MoodID = %tu order by id;", mood.zoneID, mood.moodID];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *commands = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        SHMoodCommand *command =
            [[SHMoodCommand alloc] initWithDict:dict];
        
        [commands addObject:command];
    }
    
    return commands;
}

/// 更新指令
- (BOOL)updateMoodCommand:(SHMoodCommand *)command {
    
    NSString *updateSQL = [NSString stringWithFormat:
                           @"update MoodCommands set deviceName = '%@',     \
                           deviceType = %tu, SubnetID = %d, DeviceID = %d,  \
                           Parameter1 = %tu, Parameter2 = %tu,      \
                           Parameter3 = %tu, Parameter4 = %tu,      \
                           Parameter5 = %tu, Parameter6 = %tu       \
                           Where zoneID = %tu and MoodID = %tu      \
                           and ID = %tu;",
                           
                           command.deviceName, command.deviceType,
                           command.subnetID, command.deviceID,
                           command.parameter1, command.parameter2,
                           command.parameter3, command.parameter4,
                           command.parameter5, command.parameter6,
                           command.zoneID, command.moodID, command.id
                           ];
    
    return [self executeSql:updateSQL];
}

/// 删除场景模式中指定的命令
- (BOOL)deleteMoodCommand:(SHMoodCommand *)command {
    
    NSString *commandSql = [NSString stringWithFormat:
                            @"delete from MoodCommands where ZoneID = %tu   \
                            and MoodID = %tu and ID = %tu;",
                            command.zoneID, command.moodID, command.id
                            ];
    
    return [self executeSql:commandSql];
}

/// 删除当前的模式
- (BOOL)deleteCurrentMood:(SHMood *)mood {
    
    // 删除场景
    NSString *moodsql = [NSString stringWithFormat:
                         @"delete from MoodInZone where ZoneID = %tu and    \
                         MoodID = %tu;",
                         mood.zoneID, mood.moodID
                         ];
    
    BOOL moodRes = [self executeSql:moodsql];
    
    // 删除场景中的命令集
    NSString *commandSql = [NSString stringWithFormat:
                            @"delete from MoodCommands where        \
                            ZoneID = %tu and MoodID = %tu;",
                            mood.zoneID, mood.moodID
                            ];
    
    BOOL commandRes = [self executeSql:commandSql];
    
    return moodRes && commandRes;
}

/// 删除区域中的模式
- (BOOL)deleteZoneMoods:(NSUInteger)zoneID {

    BOOL result = NO;
    
    // 删除命令
    NSString *commandSql =
        [NSString stringWithFormat:
            @"delete from MoodCommands where ZoneID = %tu;",
            zoneID
        ];
    
    result = [self executeSql:commandSql];
    
    // 删除场景
    NSString *moodsql =
        [NSString stringWithFormat:
            @"delete from MoodInZone where ZoneID = %tu;",
            zoneID
        ];
    
    result = [self executeSql:moodsql];
    
    return result;
}

/// 插入当前模式的命令
- (BOOL)insertNewMoodCommandFor:(SHMoodCommand *)command {
    
    NSString *commandSql = [NSString stringWithFormat:
                            @"insert into MoodCommands values           \
                            (%tu, %tu, %tu, %tu, %d, %d, '%@', %tu,     \
                            %tu, %tu, %tu, %tu, %tu, %tu);",
                            
                            command.id,
                            command.zoneID,
                            command.moodID,
                            command.deviceType,
                            
                            command.subnetID,
                            command.deviceID,
                            
                            command.deviceName,
                            command.parameter1,
                            command.parameter2,
                            command.parameter3,
                            command.parameter4,
                            command.parameter5,
                            command.parameter6,
                            command.delayMillisecondAfterSend
                            ];
    
    
    return [self executeSql:commandSql];
}

/// 更新模式
- (BOOL)updateMood:(SHMood *)mood {
    
    NSString *updateSql = [NSString stringWithFormat:
                           @"update MoodInZone set MoodName = '%@',     \
                           MoodIconName = '%@' Where zoneID = %tu       \
                           and MoodID = %tu;",
                           mood.moodName, mood.moodIconName,
                           mood.zoneID, mood.moodID
                           ];
    
    return [self executeSql:updateSql];
}

/// 插入当前区域的新模式
- (BOOL)insertNewMood:(SHMood *)mood {
    
    NSString *moodSql = [NSString stringWithFormat:@"insert into MoodInZone values(%tu, %tu, %tu, '%@', '%@', %tu);",
        
                         [self getMaxIDForMood] + 1,
                         mood.zoneID,
                         mood.moodID,
                         mood.moodName,
                         mood.moodIconName,
                         mood.isSystemMood
                         ];
    
    return [self executeSql:moodSql];
}

/// 模式命令的最大ID
- (NSUInteger)getMoodCommandMaxID {
    
    NSString *moodIDSql = [NSString stringWithFormat:@"select max(ID) from MoodCommands;"];
    
    // 获得结果ID
    id resID = [[[self selectProprty:moodIDSql] lastObject] objectForKey:@"max(ID)"];
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 模式表中的最大ID
- (NSUInteger)getMaxIDForMood {
    
    NSString *moodIDSql = [NSString stringWithFormat:@"select max(ID) from MoodInZone;"];
    
    // 获得结果ID
    id resID = [[[self selectProprty:moodIDSql] lastObject] objectForKey:@"max(ID)"];
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 获得当前区域的最大模式ID
- (NSUInteger)getMaxMoodIDFor:(NSUInteger)zoneID {
    
    NSString *moodIDSql = [NSString stringWithFormat:@"select max(MoodID) from MoodInZone where zoneID = %tu;", zoneID];
    
    // 获得结果ID
    id resID = [[[self selectProprty:moodIDSql] lastObject] objectForKey:@"max(MoodID)"];
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}


/// 查询所有的模式按钮
- (NSMutableArray *)getAllMoodFor:(NSUInteger)zoneID {
    
    NSString *moodSql = [NSString stringWithFormat:@"select ZoneID, MoodID, MoodName, MoodIconName, IsSystemMood from MoodInZone where ZoneID = %tu order by MoodID;", zoneID];
    
    NSMutableArray *array = [self selectProprty:moodSql];
    NSMutableArray *moods = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        
        [moods addObject:
            ([[SHMood alloc] initWithDict:dict])
         ];
    }
    
    return moods;
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
    
    NSArray *array = [self selectProprty:sql];
    
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
    
    NSArray *array = [self selectProprty:schduleSql];
    
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
    id resID = [[[self selectProprty:@"select max(scheduleID) from Schedules"] lastObject] objectForKey:@"max(scheduleID)"];
    
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
    
    return [self executeSql:updateScheduleSql];
}

/// 获得Schedual中的最大的ID
- (NSUInteger)getMaxSchedualID {
    
    // 获得结果ID
    id resID = [[[self selectProprty:@"select max(ID) from Schedules"] lastObject] objectForKey:@"max(ID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 获得ScheduleCommands中的最大ID
- (NSUInteger)getMaxIDForSchedualCommand {
    
    // 获得结果ID
    id resID = [[[self selectProprty:@"select max(ID) from ScheduleCommands"] lastObject] objectForKey:@"max(ID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 插入计划要执行的命令
- (void)insertNewSchedualeCommand:(SHSchedualCommand *)schedualCommand {
    
    NSUInteger maxID = [self getMaxIDForSchedualCommand] + 1;
    
    NSString *inserCommandSql = [NSString stringWithFormat:@"insert into ScheduleCommands values(%tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu);", maxID, schedualCommand.scheduleID, schedualCommand.typeID, schedualCommand.parameter1, schedualCommand.parameter2, schedualCommand.parameter3, schedualCommand.parameter4, schedualCommand.parameter5, schedualCommand.parameter6];
    
    [self executeSql:inserCommandSql];
    
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
    [self executeSql:insertSql];
}

/// 删除计划及命令
- (BOOL)deleteScheduale:(SHSchedual *)schedual {
    
    // 1. 删除命令
    NSString *schdualSql = [NSString stringWithFormat:
                            @"delete from Schedules where ScheduleID = %tu;", schedual.scheduleID];
    
    BOOL deleteSchdual = [self executeSql:schdualSql];
    
    // 2. 删除计划中的命令
    NSString *commandSql = [NSString stringWithFormat:
                            @"delete from ScheduleCommands where ScheduleID = %tu;",
                            schedual.scheduleID];
    
    BOOL deleteCommand = [self executeSql:commandSql];
    
    return deleteSchdual && deleteCommand;
}

/// 删除schedual中的执行 指令
- (BOOL)deleteSchedualeCommand:(SHSchedual *)schedual {
    
    NSString *deleteCommandSql = [NSString stringWithFormat:
                                  @"delete from ScheduleCommands where ScheduleID = %tu and typeID = %tu;",
                                  schedual.scheduleID,
                                  schedual.controlledItemID];
    
    return [self executeSql:deleteCommandSql];
}
 
// MARK: - 多媒体设备的操作

/// 增加多媒体设备注释
- (void)addMediaDeviceRemark {
    
    // 1.电视
    if (![self isColumnName:@"remark" consistinTable:@"TVInZone"]) {
        
        // 增加remark
        [self executeSql:@"ALTER TABLE TVInZone ADD remark TEXT NOT NULL DEFAULT 'TV';"];
    }
    
    // 2.AppleTV
    if (![self isColumnName:@"remark" consistinTable:@"AppleTVInZone"]) {
        
        // 增加remark
        [self executeSql:@"ALTER TABLE AppleTVInZone ADD remark TEXT NOT NULL DEFAULT 'APPLE TV';"];
    }
    
    
    // 3.DVD
    if (![self isColumnName:@"remark" consistinTable:@"DVDInZone"]) {
        
        // 增加remark
        [self executeSql:@"ALTER TABLE DVDInZone ADD remark TEXT NOT NULL DEFAULT 'DVD';"];
    }
    
    // 4.ProjectorInZone
    if (![self isColumnName:@"remark" consistinTable:@"ProjectorInZone"]) {
        
        // 增加remark
        [self executeSql:@"ALTER TABLE ProjectorInZone ADD remark TEXT NOT NULL DEFAULT 'PROJECTOR';"];
    }
    
    
    // 5.卫星电视
    // 4.ProjectorInZone
    if (![self isColumnName:@"remark" consistinTable:@"SATInZone"]) {
        
        // 增加remark
        [self executeSql:@"ALTER TABLE SATInZone ADD remark TEXT NOT NULL DEFAULT 'SATELLITE TV';"];
    }
}


/// 获得当前区域中的电视
- (NSMutableArray *)getMediaTVFor:(NSUInteger)zoneID {
    
    NSString *tvSql = [NSString stringWithFormat:@"select ID, remark, ZoneID, SubnetID, DeviceID, UniversalSwitchIDforOn, UniversalSwitchStatusforOn, UniversalSwitchIDforOff, UniversalSwitchStatusforOff, UniversalSwitchIDforCHAdd, UniversalSwitchIDforCHMinus, UniversalSwitchIDforVOLUp, UniversalSwitchIDforVOLDown, UniversalSwitchIDforMute, UniversalSwitchIDforMenu, UniversalSwitchIDforSource, UniversalSwitchIDforOK, UniversalSwitchIDfor0, UniversalSwitchIDfor1, UniversalSwitchIDfor2, UniversalSwitchIDfor3, UniversalSwitchIDfor4, UniversalSwitchIDfor5, UniversalSwitchIDfor6, UniversalSwitchIDfor7, UniversalSwitchIDfor8, UniversalSwitchIDfor9, IRMacroNumberForTVStart0, IRMacroNumberForTVStart1, IRMacroNumberForTVStart2, IRMacroNumberForTVStart3, IRMacroNumberForTVStart4, IRMacroNumberForTVStart5 from TVInZone where ZoneID = %tu order by id;", zoneID];
    
    NSArray *array = [self selectProprty:tvSql];
    
    if (!array.count) {
        return nil;
    }
    
    NSMutableArray *tvs = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [tvs addObject:
            [[SHMediaTV alloc] initWithDict:dict]
        ];
    }
    
    return tvs;
}

/// 删除当前区域的TV
- (BOOL)deleteTVInZone:(SHMediaTV *)mediaTV {
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from TVInZone Where zoneID = %tu and SubnetID = %d and DeviceID = %d;", mediaTV.zoneID, mediaTV.subnetID, mediaTV.deviceID];
    
    return [self executeSql:deleteSql];
}

/// 删除区域中的TV
- (BOOL)deleteZoneTVs:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from TVInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
}

/// 存入新的TV设备
- (NSInteger)inserNewMediaTV:(SHMediaTV *)mediaTV {
    
    NSString *insertSQL =
        [NSString stringWithFormat:
            @"insert into TVInZone (remark, ZoneID, SubnetID,       \
            DeviceID, UniversalSwitchIDforOn,                       \
            UniversalSwitchStatusforOn, UniversalSwitchIDforOff,    \
            UniversalSwitchStatusforOff, UniversalSwitchIDforCHAdd, \
            UniversalSwitchIDforCHMinus, UniversalSwitchIDforVOLUp, \
            UniversalSwitchIDforVOLDown, UniversalSwitchIDforMute,  \
            UniversalSwitchIDforMenu, UniversalSwitchIDforSource,   \
            UniversalSwitchIDforOK, UniversalSwitchIDfor0,          \
            UniversalSwitchIDfor1, UniversalSwitchIDfor2,           \
            UniversalSwitchIDfor3, UniversalSwitchIDfor4,           \
            UniversalSwitchIDfor5, UniversalSwitchIDfor6,           \
            UniversalSwitchIDfor7, UniversalSwitchIDfor8,           \
            UniversalSwitchIDfor9, IRMacroNumberForTVStart0,        \
            IRMacroNumberForTVStart1, IRMacroNumberForTVStart2,     \
            IRMacroNumberForTVStart3, IRMacroNumberForTVStart4,     \
            IRMacroNumberForTVStart5)                               \
                                                                    \
            values('%@', %tu, %d, %d, %tu, %tu, %tu, %tu, %tu, %tu, \
            %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu,  \
            %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu);",
         
            mediaTV.remark, mediaTV.zoneID, mediaTV.subnetID,
            mediaTV.deviceID, mediaTV.universalSwitchIDforOn,
            mediaTV.universalSwitchStatusforOn,
            mediaTV.universalSwitchIDforOff,
            mediaTV.universalSwitchStatusforOff,
            mediaTV.universalSwitchIDforCHAdd,
            mediaTV.universalSwitchIDforCHMinus,
            mediaTV.universalSwitchIDforVOLUp,
            mediaTV.universalSwitchIDforVOLDown,
            mediaTV.universalSwitchIDforMute,
            mediaTV.universalSwitchIDforMenu,
            mediaTV.universalSwitchIDforSource,
            mediaTV.universalSwitchIDforOK,
            mediaTV.universalSwitchIDfor0,
            mediaTV.universalSwitchIDfor1,
            mediaTV.universalSwitchIDfor2,
            mediaTV.universalSwitchIDfor3,
            mediaTV.universalSwitchIDfor4,
            mediaTV.universalSwitchIDfor5,
            mediaTV.universalSwitchIDfor6,
            mediaTV.universalSwitchIDfor7,
            mediaTV.universalSwitchIDfor8,
            mediaTV.universalSwitchIDfor9,
            mediaTV.iRMacroNumberForTVStart0,
            mediaTV.iRMacroNumberForTVStart1,
            mediaTV.iRMacroNumberForTVStart2,
            mediaTV.iRMacroNumberForTVStart3,
            mediaTV.iRMacroNumberForTVStart4,
            mediaTV.iRMacroNumberForTVStart5];
    
    BOOL res = [self executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        return [[[[self selectProprty:@"select max(ID) from TVInZone;"] lastObject]
                    objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}

/// 保存当前区域的TV参数
- (void)updateMediaTVInZone:(SHMediaTV *)mediaTV {
    
    NSString *saveSql = [NSString stringWithFormat: @"update TVInZone set remark = '%@', SubnetID = %d, DeviceID = %d, \
                         UniversalSwitchIDforOn = %tu,\
                         UniversalSwitchStatusforOn = %tu, \
                         UniversalSwitchIDforOff = %tu,\
                         UniversalSwitchStatusforOff = %tu, \
                         \
                         UniversalSwitchIDforCHAdd = %tu, \
                         UniversalSwitchIDforCHMinus = %tu,\
                         UniversalSwitchIDforVOLUp = %tu,\
                         UniversalSwitchIDforVOLDown = %tu,\
                         \
                         UniversalSwitchIDforMute = %tu, \
                         UniversalSwitchIDforMenu = %tu,\
                         UniversalSwitchIDforSource = %tu,\
                         UniversalSwitchIDforOK = %tu,\
                         \
                         UniversalSwitchIDfor0 = %tu, \
                         UniversalSwitchIDfor1 = %tu,\
                         UniversalSwitchIDfor2 = %tu,\
                         UniversalSwitchIDfor3 = %tu,\
                         UniversalSwitchIDfor4 = %tu,\
                         UniversalSwitchIDfor5 = %tu,\
                         UniversalSwitchIDfor6 = %tu,\
                         UniversalSwitchIDfor7 = %tu,\
                         UniversalSwitchIDfor8 = %tu, \
                         UniversalSwitchIDfor9 = %tu, \
                         \
                         IRMacroNumberForTVStart0 = %tu, \
                         IRMacroNumberForTVStart1 = %tu,\
                         IRMacroNumberForTVStart2 = %tu,\
                         IRMacroNumberForTVStart3 = %tu,\
                         IRMacroNumberForTVStart4 = %tu,\
                         IRMacroNumberForTVStart5 = %tu \
                         Where zoneID = %tu and id = %tu;",
                         
                         mediaTV.remark,
                         mediaTV.subnetID,
                         mediaTV.deviceID,
                         
                         mediaTV.universalSwitchIDforOn,
                         mediaTV.universalSwitchStatusforOn,
                         mediaTV.universalSwitchIDforOff,
                         mediaTV.universalSwitchStatusforOff,
                         
                         mediaTV.universalSwitchIDforCHAdd,
                         mediaTV.universalSwitchIDforCHMinus,
                         mediaTV.universalSwitchIDforVOLUp,
                         mediaTV.universalSwitchIDforVOLDown,
                         
                         mediaTV.universalSwitchIDforMute,
                         mediaTV.universalSwitchIDforMenu,
                         mediaTV.universalSwitchIDforSource,
                         mediaTV.universalSwitchIDforOK,
                         
                         mediaTV.universalSwitchIDfor0,
                         mediaTV.universalSwitchIDfor1,
                         mediaTV.universalSwitchIDfor2,
                         mediaTV.universalSwitchIDfor3,
                         mediaTV.universalSwitchIDfor4,
                         mediaTV.universalSwitchIDfor5,
                         mediaTV.universalSwitchIDfor6,
                         mediaTV.universalSwitchIDfor7,
                         mediaTV.universalSwitchIDfor8,
                         mediaTV.universalSwitchIDfor9,
                         
                         mediaTV.iRMacroNumberForTVStart0,
                         mediaTV.iRMacroNumberForTVStart1,
                         mediaTV.iRMacroNumberForTVStart2,
                         mediaTV.iRMacroNumberForTVStart3,
                         mediaTV.iRMacroNumberForTVStart4,
                         mediaTV.iRMacroNumberForTVStart5,
                         
                         mediaTV.zoneID, mediaTV.id
                         ];
    
    [self executeSql:saveSql];
}

// MARK: -

/// 获得当前区域的投影仪
- (NSMutableArray *)getMediaProjectorFor:(NSUInteger)zoneID {
    
    NSString *tvSql = [NSString stringWithFormat:@"select ID, remark, ZoneID, SubnetID, DeviceID, UniversalSwitchIDforOn, UniversalSwitchStatusforOn, UniversalSwitchIDforOff, UniversalSwitchStatusforOff, UniversalSwitchIDfoMenu, UniversalSwitchIDfoUp, UniversalSwitchIDforDown, UniversalSwitchIDforLeft, UniversalSwitchIDforRight, UniversalSwitchIDforOK, UniversalSwitchIDforSource, IRMacroNumberForProjectorSpare0, IRMacroNumberForProjectorSpare1, IRMacroNumberForProjectorSpare2, IRMacroNumberForProjectorSpare3, IRMacroNumberForProjectorSpare4, IRMacroNumberForProjectorSpare5 from ProjectorInZone where ZoneID = %tu order by id;",  zoneID];
    
    NSArray *array = [self selectProprty:tvSql];
    
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
    
    return [self executeSql:deleteSql];
}

/// 删除区域中的投影仪
- (BOOL)deleteZoneProjectors:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from ProjectorInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
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
    
    [self executeSql:saveSql];
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
    
    BOOL res = [self executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        return [[[[self selectProprty:@"select max(ID) from ProjectorInZone;"] lastObject] objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}

// MARK: -

/// 获得当前区域中的AppleTV
- (NSMutableArray *)getMediaAppleTVFor:(NSUInteger)zoneID {
    
    NSString *tvSql = [NSString stringWithFormat:@"select ID, remark, ZoneID, SubnetID, DeviceID, UniversalSwitchIDforOn, UniversalSwitchStatusforOn, UniversalSwitchIDforOff, UniversalSwitchStatusforOff, UniversalSwitchIDforUp, UniversalSwitchIDforDown, UniversalSwitchIDforLeft, UniversalSwitchIDforRight, UniversalSwitchIDforOK, UniversalSwitchIDforMenu, UniversalSwitchIDforPlayPause, IRMacroNumberForAppleTVStart0, IRMacroNumberForAppleTVStart1, IRMacroNumberForAppleTVStart2, IRMacroNumberForAppleTVStart3, IRMacroNumberForAppleTVStart4, IRMacroNumberForAppleTVStart5 from AppleTVInZone where ZoneID = %tu order by id;",  zoneID];
    
    NSArray *array = [self selectProprty:tvSql];
    
    if (!array.count) {
        return nil;
    }
    
    NSMutableArray *appleTVs = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        
        [appleTVs addObject:([[SHMediaAppleTV alloc] initWithDict:dict])];
    }
    
    return appleTVs;
}


/// 删除苹果电视
- (BOOL)deleteAppleTVInZone:(SHMediaAppleTV *)mediaTV {
    
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from AppleTVInZone Where zoneID = %tu   \
                           and SubnetID = %d and DeviceID = %d;",
                           
                           mediaTV.zoneID, mediaTV.subnetID, mediaTV.deviceID];
    
    return [self executeSql:deleteSql];
    
}

/// 删除区域中所所有AppleTV
- (BOOL)deleteZoneAppleTVs:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from AppleTVInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
}

/// 增加苹果电视
- (NSInteger)insertNewMediaAppleTV:(SHMediaAppleTV *)mediaAppleTV {
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into AppleTVInZone (remark, ZoneID, SubnetID, DeviceID, UniversalSwitchIDforOn, UniversalSwitchStatusforOn, UniversalSwitchIDforOff, UniversalSwitchStatusforOff, UniversalSwitchIDforUp, UniversalSwitchIDforDown, UniversalSwitchIDforLeft, UniversalSwitchIDforRight, UniversalSwitchIDforOK, UniversalSwitchIDforMenu, UniversalSwitchIDforPlayPause, IRMacroNumberForAppleTVStart0, IRMacroNumberForAppleTVStart1, IRMacroNumberForAppleTVStart2, IRMacroNumberForAppleTVStart3, IRMacroNumberForAppleTVStart4, IRMacroNumberForAppleTVStart5) values('%@', %tu, %d, %d, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu)",
                           
                           mediaAppleTV.remark,
                           mediaAppleTV.zoneID,
                           mediaAppleTV.subnetID,
                           mediaAppleTV.deviceID,
                           mediaAppleTV.universalSwitchIDforOn,
                           mediaAppleTV.universalSwitchStatusforOn,
                           mediaAppleTV.universalSwitchIDforOff, mediaAppleTV.universalSwitchStatusforOff,
                           mediaAppleTV.universalSwitchIDforUp,
                           mediaAppleTV.universalSwitchIDforDown,
                           mediaAppleTV.universalSwitchIDforLeft,
                           mediaAppleTV.universalSwitchIDforRight,
                           mediaAppleTV.universalSwitchIDforOK,
                           mediaAppleTV.universalSwitchIDforMenu,
                           mediaAppleTV.universalSwitchIDforPlayPause,
                           mediaAppleTV.iRMacroNumberForAppleTVStart0,
                           mediaAppleTV.iRMacroNumberForAppleTVStart1,
                           mediaAppleTV.iRMacroNumberForAppleTVStart2,
                           mediaAppleTV.iRMacroNumberForAppleTVStart3,
                           mediaAppleTV.iRMacroNumberForAppleTVStart4,
                           mediaAppleTV.iRMacroNumberForAppleTVStart5];
    
    BOOL res = [self executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        return [[[[self selectProprty:@"select max(ID) from AppleTVInZone;"] lastObject] objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}

/// 保存苹果电视数据
- (void)updateMediaAppleTVInZone:(SHMediaAppleTV *)mediaAppleTV {
    
    NSString *saveSql = [NSString stringWithFormat:@"update AppleTVInZone   \
                         set remark = '%@',  SubnetID = %d, DeviceID = %d, \
                         UniversalSwitchIDforOn = %tu,                      \
                         UniversalSwitchStatusforOn = %tu,                  \
                         UniversalSwitchIDforOff = %tu,                     \
                         UniversalSwitchStatusforOff = %tu,                 \
                                                                            \
                         UniversalSwitchIDforUp = %tu,                      \
                         UniversalSwitchIDforDown = %tu,                    \
                         UniversalSwitchIDforLeft = %tu,                    \
                         UniversalSwitchIDforRight = %tu,                   \
                         UniversalSwitchIDforOK = %tu,                      \
                         UniversalSwitchIDforMenu = %tu,                    \
                         UniversalSwitchIDforPlayPause = %tu,               \
                                                                            \
                         IRMacroNumberForAppleTVStart0 = %tu,               \
                         IRMacroNumberForAppleTVStart1 = %tu,               \
                         IRMacroNumberForAppleTVStart2 = %tu,               \
                         IRMacroNumberForAppleTVStart3 = %tu,               \
                         IRMacroNumberForAppleTVStart4 = %tu,               \
                         IRMacroNumberForAppleTVStart5 = %tu                \
                         Where zoneID = %tu and id = %tu;",
                         
                         mediaAppleTV.remark,
                         mediaAppleTV.subnetID,
                         mediaAppleTV.deviceID,
                         
                         mediaAppleTV.universalSwitchIDforOn,
                         mediaAppleTV.universalSwitchStatusforOn,
                         mediaAppleTV.universalSwitchIDforOff,
                         mediaAppleTV.universalSwitchStatusforOff,
                         
                         mediaAppleTV.universalSwitchIDforUp,
                         mediaAppleTV.universalSwitchIDforDown,
                         mediaAppleTV.universalSwitchIDforLeft,
                         mediaAppleTV.universalSwitchIDforRight,
                         mediaAppleTV.universalSwitchIDforOK,
                         mediaAppleTV.universalSwitchIDforMenu,
                         mediaAppleTV.universalSwitchIDforPlayPause,
                         
                         mediaAppleTV.iRMacroNumberForAppleTVStart0,
                         mediaAppleTV.iRMacroNumberForAppleTVStart1,
                         mediaAppleTV.iRMacroNumberForAppleTVStart2,
                         mediaAppleTV.iRMacroNumberForAppleTVStart3,
                         mediaAppleTV.iRMacroNumberForAppleTVStart4,
                         mediaAppleTV.iRMacroNumberForAppleTVStart5,
                         
                         mediaAppleTV.zoneID, mediaAppleTV.id
                         ];
    
    [self executeSql:saveSql];
}

// MARK: - SAT

/// 添加控制单元
- (void)addSATControlIetms {
 
    if (![self isColumnName:@"SwitchNameforControl1" consistinTable:@"SATInZone"]) {
        
        [self executeSql:
            @"ALTER TABLE SATInZone ADD SwitchNameforControl1 TEXT DEFAULT 'C1';"];
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchIDforControl1 INTEGER DEFAULT 0;"];
    }
    
   
    
    if (![self isColumnName:@"SwitchNameforControl2" consistinTable:@"SATInZone"]) {
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchNameforControl2 TEXT DEFAULT 'C2';"];
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchIDforControl2 INTEGER DEFAULT 0;"];
    }
    
    if (![self isColumnName:@"SwitchNameforControl3" consistinTable:@"SATInZone"]) {
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchNameforControl3 TEXT DEFAULT 'C3';"];
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchIDforControl3 INTEGER DEFAULT 0;"];
    }
    
    
    if (![self isColumnName:@"SwitchNameforControl4" consistinTable:@"SATInZone"]) {
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchNameforControl4 TEXT DEFAULT 'C4';"];
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchIDforControl4 INTEGER DEFAULT 0;"];
    }
    
    if (![self isColumnName:@"SwitchNameforControl5" consistinTable:@"SATInZone"]) {
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchNameforControl5 TEXT DEFAULT 'C5';"];
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchIDforControl5 INTEGER DEFAULT 0;"];
    }
    
    if (![self isColumnName:@"SwitchNameforControl6" consistinTable:@"SATInZone"]) {
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchNameforControl6 TEXT DEFAULT 'C6';"];
        
        [self executeSql:
         @"ALTER TABLE SATInZone ADD SwitchIDforControl6 INTEGER DEFAULT 0;"];
    }
    
}

/// 获得当前区域的卫星电视
- (NSMutableArray *)getMediaSATFor:(NSUInteger)zoneID {
    
    NSString *tvSql =
        [NSString stringWithFormat:
            @"select ID, remark, ZoneID, SubnetID, DeviceID,    \
            UniversalSwitchIDforOn,             \
            UniversalSwitchStatusforOn,         \
            UniversalSwitchIDforOff,            \
            UniversalSwitchStatusforOff,        \
            UniversalSwitchIDforUp,             \
            UniversalSwitchIDforDown,           \
            UniversalSwitchIDforLeft,           \
            UniversalSwitchIDforRight,          \
            UniversalSwitchIDforOK ,            \
            UniversalSwitchIDfoMenu,            \
            UniversalSwitchIDforFAV,            \
            UniversalSwitchIDfor0,              \
            UniversalSwitchIDfor1,              \
            UniversalSwitchIDfor2,              \
            UniversalSwitchIDfor3,              \
            UniversalSwitchIDfor4,              \
            UniversalSwitchIDfor5,              \
            UniversalSwitchIDfor6,              \
            UniversalSwitchIDfor7,              \
            UniversalSwitchIDfor8,              \
            UniversalSwitchIDfor9,              \
            UniversalSwitchIDforPlayRecord,     \
            UniversalSwitchIDforPlayStopRecord, \
            IRMacroNumberForSATSpare0,          \
            IRMacroNumberForSATSpare1,          \
            IRMacroNumberForSATSpare2,          \
            IRMacroNumberForSATSpare3,          \
            IRMacroNumberForSATSpare4,          \
            IRMacroNumberForSATSpare5,          \
            UniversalSwitchIDforPREVChapter,    \
            UniversalSwitchIDforNextChapter,    \
            SwitchNameforControl1,              \
            SwitchIDforControl1,                \
            SwitchNameforControl2,              \
            SwitchIDforControl2,                \
            SwitchNameforControl3,              \
            SwitchIDforControl3,                \
            SwitchNameforControl4,              \
            SwitchIDforControl4,                \
            SwitchNameforControl5,              \
            SwitchIDforControl5,                \
            SwitchNameforControl6,              \
            SwitchIDforControl6                 \
            from SATInZone where ZoneID = %tu order by id;",
          zoneID
        ];
    
    NSArray *array = [self selectProprty:tvSql];
    
    if (!array.count) {
        return nil;
    }
    
    NSMutableArray *sats = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [sats addObject:
            [[SHMediaSAT alloc] initWithDict:dict]
        ];
    }
    
    return sats;
}


/// 增加SAT设备
- (NSInteger)insertNewMediaSAT:(SHMediaSAT *)mediaSAT {
    
    NSString *insertSQL =
        [NSString stringWithFormat:
            @"insert into SATInZone (remark, ZoneID, SubnetID, DeviceID,    \
            UniversalSwitchIDforOn,                                         \
            UniversalSwitchStatusforOn,                                     \
            UniversalSwitchIDforOff,                                        \
            UniversalSwitchStatusforOff,                                    \
            UniversalSwitchIDforUp,                                         \
            UniversalSwitchIDforDown,                                       \
            UniversalSwitchIDforLeft,                                       \
            UniversalSwitchIDforRight,                                      \
            UniversalSwitchIDforOK,                                         \
            UniversalSwitchIDfoMenu,                                        \
            UniversalSwitchIDforFAV,                                        \
            UniversalSwitchIDfor0,                                          \
            UniversalSwitchIDfor1,                                          \
            UniversalSwitchIDfor2,                                          \
            UniversalSwitchIDfor3,                                          \
            UniversalSwitchIDfor4,                                          \
            UniversalSwitchIDfor5,                                          \
            UniversalSwitchIDfor6,                                          \
            UniversalSwitchIDfor7,                                          \
            UniversalSwitchIDfor8,                                          \
            UniversalSwitchIDfor9,                                          \
            UniversalSwitchIDforPlayRecord,                                 \
            UniversalSwitchIDforPlayStopRecord,                             \
            IRMacroNumberForSATSpare0,                                      \
            IRMacroNumberForSATSpare1,                                      \
            IRMacroNumberForSATSpare2,                                      \
            IRMacroNumberForSATSpare3,                                      \
            IRMacroNumberForSATSpare4,                                      \
            IRMacroNumberForSATSpare5,                                      \
            UniversalSwitchIDforPREVChapter,                                \
            UniversalSwitchIDforNextChapter,                                \
            SwitchNameforControl1,                                          \
            SwitchIDforControl1,                                            \
            SwitchNameforControl2,                                          \
            SwitchIDforControl2,                                            \
            SwitchNameforControl3,                                          \
            SwitchIDforControl3,                                            \
            SwitchNameforControl4,                                          \
            SwitchIDforControl4,                                            \
            SwitchNameforControl5,                                          \
            SwitchIDforControl5,                                            \
            SwitchNameforControl6,                                          \
            SwitchIDforControl6                                             \
         )  values('%@', %tu, %d, %d, %tu, %tu, %tu, %tu, %tu, %tu,         \
                    %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu,       \
                    %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu,       \
                    %tu, %tu, %tu, %tu, %tu, '%@', %tu, '%@', %tu, '%@',    \
                    %tu, '%@', %tu, '%@', %tu, '%@', %tu);",
         
         mediaSAT.remark,
         mediaSAT.zoneID,
         mediaSAT.subnetID,
         mediaSAT.deviceID,
         mediaSAT.universalSwitchIDforOn,
         mediaSAT.universalSwitchStatusforOn,
         mediaSAT.universalSwitchIDforOff,
         mediaSAT.universalSwitchStatusforOff,
         mediaSAT.universalSwitchIDforUp,
         mediaSAT.universalSwitchIDforDown,
         mediaSAT.universalSwitchIDforLeft,
         mediaSAT.universalSwitchIDforRight,
         mediaSAT.universalSwitchIDforOK,
         mediaSAT.universalSwitchIDfoMenu,
         mediaSAT.universalSwitchIDforFAV,
         mediaSAT.universalSwitchIDfor0,
         mediaSAT.universalSwitchIDfor1,
         mediaSAT.universalSwitchIDfor2,
         mediaSAT.universalSwitchIDfor3,
         mediaSAT.universalSwitchIDfor4,
         mediaSAT.universalSwitchIDfor5,
         mediaSAT.universalSwitchIDfor6,
         mediaSAT.universalSwitchIDfor7,
         mediaSAT.universalSwitchIDfor8,
         mediaSAT.universalSwitchIDfor9,
         mediaSAT.universalSwitchIDforPlayRecord,
         mediaSAT.universalSwitchIDforPlayStopRecord,
         mediaSAT.iRMacroNumberForSATSpare0,
         mediaSAT.iRMacroNumberForSATSpare1,
         mediaSAT.iRMacroNumberForSATSpare2,
         mediaSAT.iRMacroNumberForSATSpare3,
         mediaSAT.iRMacroNumberForSATSpare4,
         mediaSAT.iRMacroNumberForSATSpare5,
         mediaSAT.universalSwitchIDforPREVChapter,
         mediaSAT.universalSwitchIDforNextChapter,
         mediaSAT.switchNameforControl1,
         mediaSAT.switchIDforControl1,
         mediaSAT.switchNameforControl2,
         mediaSAT.switchIDforControl2,
         mediaSAT.switchNameforControl3,
         mediaSAT.switchIDforControl3,
         mediaSAT.switchNameforControl4,
         mediaSAT.switchIDforControl4,
         mediaSAT.switchNameforControl5,
         mediaSAT.switchIDforControl5,
         mediaSAT.switchNameforControl6,
         mediaSAT.switchIDforControl6
    ];
    
    
    BOOL res = [self executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        return [[[[self selectProprty:@"select max(ID) from SATInZone;"] lastObject] objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}

/// 删除当前的SAT
- (BOOL)deleteSATInZone:(SHMediaSAT *)mediaSAT {
    
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from SATInZone Where zoneID = %tu       \
                           and SubnetID = %d and DeviceID = %d;",
                           
                           mediaSAT.zoneID, mediaSAT.subnetID, mediaSAT.deviceID
                           ];
    
    return [self executeSql:deleteSql];
}

/// 删除区域中的SAT
- (BOOL)deleteZoneSATs:(NSUInteger)zoneID {
    
    // 删除SAT
    NSString *deleteSQL =
        [NSString stringWithFormat:
            @"delete from SATInZone Where zoneID = %tu;",
            zoneID
        ];
    
    BOOL deleteSAT = [self executeSql:deleteSQL];
    
    // 删除分类
    NSString *deleteCategorySQL =
        [NSString stringWithFormat:
            @"delete from SATCategory Where zoneID = %tu;",
            zoneID
        ];
    
    BOOL deleteCategory = [self executeSql:deleteCategorySQL];
    
    // 删除频道
    NSString *deleteChannelSQL =
        [NSString stringWithFormat:
            @"delete from SATChannels Where zoneID = %tu;",
            zoneID
         ];
    
    BOOL deleteChannel = [self executeSql:deleteChannelSQL];
    
    return  (deleteSAT && deleteCategory && deleteChannel);
}

// 保存当前SAT
- (void)updateMediaSATInZone:(SHMediaSAT *)mediaSAT {
    
    NSString *saveSql = [NSString stringWithFormat:@"update SATInZone       \
                         set remark = '%@', SubnetID = %d, DeviceID = %d,                                    \
                         UniversalSwitchIDforOn = %tu,              \
                         UniversalSwitchStatusforOn = %tu,          \
                         UniversalSwitchIDforOff = %tu,             \
                         UniversalSwitchStatusforOff = %tu,         \
                                                                    \
                         UniversalSwitchIDforUp = %tu,              \
                         UniversalSwitchIDforDown = %tu,            \
                         UniversalSwitchIDforLeft = %tu,            \
                         UniversalSwitchIDforRight = %tu,           \
                         UniversalSwitchIDforOK = %tu,              \
                         UniversalSwitchIDfoMenu = %tu,             \
                         UniversalSwitchIDforFAV = %tu,             \
                                                                    \
                         UniversalSwitchIDfor0 = %tu,               \
                         UniversalSwitchIDfor1 = %tu,               \
                         UniversalSwitchIDfor2 = %tu,               \
                         UniversalSwitchIDfor3 = %tu,               \
                         UniversalSwitchIDfor4 = %tu,               \
                         UniversalSwitchIDfor5 = %tu,               \
                         UniversalSwitchIDfor6 = %tu,               \
                         UniversalSwitchIDfor7 = %tu,               \
                         UniversalSwitchIDfor8 = %tu,               \
                         UniversalSwitchIDfor9 = %tu,               \
                                                                    \
                         UniversalSwitchIDforPREVChapter = %tu,     \
                         UniversalSwitchIDforNextChapter = %tu,     \
                         UniversalSwitchIDforPlayRecord = %tu,      \
                         UniversalSwitchIDforPlayStopRecord = %tu,  \
                                                                    \
                         IRMacroNumberForSATSpare0 = %tu,           \
                         IRMacroNumberForSATSpare1 = %tu,           \
                         IRMacroNumberForSATSpare2 = %tu,           \
                         IRMacroNumberForSATSpare3 = %tu,           \
                         IRMacroNumberForSATSpare4 = %tu,           \
                         IRMacroNumberForSATSpare5 = %tu,           \
                         SwitchNameforControl1 = '%@',              \
                         SwitchIDforControl1 = %tu,                 \
                         SwitchNameforControl2 = '%@',              \
                         SwitchIDforControl2 = %tu,                 \
                         SwitchNameforControl3 = '%@',              \
                         SwitchIDforControl3 = %tu,                 \
                         SwitchNameforControl4 = '%@',              \
                         SwitchIDforControl4 = %tu,                 \
                         SwitchNameforControl5 = '%@',              \
                         SwitchIDforControl5 = %tu,                 \
                         SwitchNameforControl6 = '%@',              \
                         SwitchIDforControl6 = %tu                  \
                         Where zoneID = %tu and id = %tu;",
                         
                         mediaSAT.remark,
                         mediaSAT.subnetID,
                         mediaSAT.deviceID,
                         
                         mediaSAT.universalSwitchIDforOn,
                         mediaSAT.universalSwitchStatusforOn,
                         mediaSAT.universalSwitchIDforOff,
                         mediaSAT.universalSwitchStatusforOff,
                         
                         mediaSAT.universalSwitchIDforUp,
                         mediaSAT.universalSwitchIDforDown,
                         mediaSAT.universalSwitchIDforLeft,
                         mediaSAT.universalSwitchIDforRight,
                         mediaSAT.universalSwitchIDforOK,
                         mediaSAT.universalSwitchIDfoMenu,
                         mediaSAT.universalSwitchIDforFAV,
                         
                         mediaSAT.universalSwitchIDfor0,
                         mediaSAT.universalSwitchIDfor1,
                         mediaSAT.universalSwitchIDfor2,
                         mediaSAT.universalSwitchIDfor3,
                         mediaSAT.universalSwitchIDfor4,
                         mediaSAT.universalSwitchIDfor5,
                         mediaSAT.universalSwitchIDfor6,
                         mediaSAT.universalSwitchIDfor7,
                         mediaSAT.universalSwitchIDfor8,
                         mediaSAT.universalSwitchIDfor9,
                         
                         
                         mediaSAT.universalSwitchIDforPREVChapter,
                         mediaSAT.universalSwitchIDforNextChapter,
                         mediaSAT.universalSwitchIDforPlayRecord,
                         mediaSAT.universalSwitchIDforPlayStopRecord,
                         
                         mediaSAT.iRMacroNumberForSATSpare0,
                         mediaSAT.iRMacroNumberForSATSpare1,
                         mediaSAT.iRMacroNumberForSATSpare2,
                         mediaSAT.iRMacroNumberForSATSpare3,
                         mediaSAT.iRMacroNumberForSATSpare4,
                         mediaSAT.iRMacroNumberForSATSpare5,
                         
                         mediaSAT.switchNameforControl1,
                         mediaSAT.switchIDforControl1,
                         mediaSAT.switchNameforControl2,
                         mediaSAT.switchIDforControl2,
                         mediaSAT.switchNameforControl3,
                         mediaSAT.switchIDforControl3,
                         mediaSAT.switchNameforControl4,
                         mediaSAT.switchIDforControl4,
                         mediaSAT.switchNameforControl5,
                         mediaSAT.switchIDforControl5,
                         mediaSAT.switchNameforControl6,
                         mediaSAT.switchIDforControl6,
                         
                         mediaSAT.zoneID, mediaSAT.id
                         ];
    
    [self executeSql:saveSql];
}


/// 获得卫星电视指定分类中的所有频道
- (NSMutableArray *)getMediaSATChannelFor:(SHMediaSATCategory *)category {
    
    NSString *sql =
        [NSString stringWithFormat:
            @"select CategoryID, ChannelID, ChannelNo,  \
            ChannelName, iconName, SequenceNo, ZoneID   \
            from SATChannels where CategoryID = %tu;",
            category.categoryID
        ];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *channels = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [channels addObject:
            [[SHMediaSATChannel alloc] initWithDict:dict]
        ];
    }
    
    return channels;
}

/// 增加新的卫星电视分类
- (BOOL)insertNewMediaSATCategory:(SHMediaSATCategory *)category {
    
    NSString *insertSql =
        [NSString stringWithFormat:
            @"insert into SATCategory(CategoryID, CategoryName, \
                SequenceNo, ZoneID) values(%tu, '%@', %tu, %tu);",
                           category.categoryID,
                           category.categoryName,
                           category.sequenceNo,
                           category.zoneID
         ];
    
    return [self executeSql:insertSql];
}


/// 删除卫星电视的分类
- (BOOL)deleteMediaSATCategory:(SHMediaSATCategory *)category {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from SATCategory                    \
                Where CategoryID = %tu and ZoneID = %tu;",
            category.categoryID,
            category.zoneID
        ];
    
    return [self executeSql:deleteSql];
}

/// 更新卫星电视分类名称
- (BOOL)updateMediaSATCategory:(SHMediaSATCategory *)category {
    
    NSString *updateSql =
        [NSString stringWithFormat:
            @"update SATCategory set CategoryName = '%@'    \
            Where CategoryID = %tu;",
            category.categoryName, category.categoryID
        ];
    
    return [self executeSql:updateSql];
}

/// 获得卫星电视的分类
- (NSMutableArray *)getMediaSATCategory {
    
    NSString *sql =
        @"select CategoryID, CategoryName, SequenceNo, ZoneID   \
        from SATCategory;";
    
    NSMutableArray *array = [self selectProprty:sql];
    
    NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
    
        [categoryArray addObject:
            [[SHMediaSATCategory alloc] initWithDict:dict]
        ];
    }
    
    return categoryArray;
}

// MARK: -

/// 获得当前区域中的DVD
- (NSMutableArray *)getMediaDVDFor:(NSUInteger)zoneID {
    
    NSString *tvSql =
        [NSString stringWithFormat:
            @"select ID, remark, ZoneID, SubnetID, DeviceID,    \
            UniversalSwitchIDforOn,                             \
            UniversalSwitchStatusforOn,                         \
            UniversalSwitchIDforOff,                            \
            UniversalSwitchStatusforOff,                        \
            UniversalSwitchIDfoMenu,                            \
            UniversalSwitchIDfoUp,                              \
            UniversalSwitchIDforDown,                           \
            UniversalSwitchIDforFastForward,                    \
            UniversalSwitchIDforBackForward,                    \
            UniversalSwitchIDforOK,                             \
            UniversalSwitchIDforPREVChapter,                    \
            UniversalSwitchIDforNextChapter,                    \
            UniversalSwitchIDforPlayPause,                      \
            UniversalSwitchIDforPlayRecord,                     \
            UniversalSwitchIDforPlayStopRecord,                 \
            IRMacroNumberForDVDStart0,                          \
            IRMacroNumberForDVDStart1,                          \
            IRMacroNumberForDVDStart2,                          \
            IRMacroNumberForDVDStart3,                          \
            IRMacroNumberForDVDStart4,                          \
            IRMacroNumberForDVDStart5                           \
            from DVDInZone where ZoneID = %tu order by id;", zoneID];
    
    NSArray *array = [self selectProprty:tvSql];
    
    if (!array.count) {
        return nil;
    }
    
    NSMutableArray *dvds = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [dvds addObject:[[SHMediaDVD alloc] initWithDict:dict]];
    }
    
    return dvds;
}

/// 删除当前的DVD
- (BOOL)deleteDVDInZone:(SHMediaDVD *)mediaDVD {
    
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from DVDInZone Where zoneID = %tu       \
                           and SubnetID = %d and DeviceID = %d;",
                           
                           mediaDVD.zoneID, mediaDVD.subnetID,
                           mediaDVD.deviceID
                           ];
    
    return [self executeSql:deleteSql];
}

/// 删除区域中的DVD
- (BOOL)deleteZoneDVDs:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from DVDInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
}

/// 增加DVD设备
- (NSInteger)inserNewMediaDVD:(SHMediaDVD *)mediaDVD {
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into DVDInZone(remark, ZoneID, SubnetID, DeviceID, UniversalSwitchIDforOn, UniversalSwitchStatusforOn, UniversalSwitchIDforOff, UniversalSwitchStatusforOff, UniversalSwitchIDfoMenu, UniversalSwitchIDfoUp, UniversalSwitchIDforDown, UniversalSwitchIDforFastForward, UniversalSwitchIDforBackForward, UniversalSwitchIDforOK, UniversalSwitchIDforPREVChapter, UniversalSwitchIDforNextChapter, UniversalSwitchIDforPlayPause, UniversalSwitchIDforPlayRecord, UniversalSwitchIDforPlayStopRecord, IRMacroNumberForDVDStart0, IRMacroNumberForDVDStart1, IRMacroNumberForDVDStart2, IRMacroNumberForDVDStart3, IRMacroNumberForDVDStart4, IRMacroNumberForDVDStart5) values('%@', %tu, %d, %d, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu, %tu);",
                           
                           mediaDVD.remark, mediaDVD.zoneID,
                           mediaDVD.subnetID, mediaDVD.deviceID,
                           mediaDVD.universalSwitchIDforOn,
                           mediaDVD.universalSwitchStatusforOn,
                           mediaDVD.universalSwitchIDforOff,
                           mediaDVD.universalSwitchStatusforOff,
                           mediaDVD.universalSwitchIDfoMenu,
                           mediaDVD.universalSwitchIDfoUp,
                           mediaDVD.universalSwitchIDforDown,
                           mediaDVD.universalSwitchIDforFastForward,
                           mediaDVD.universalSwitchIDforBackForward,
                           mediaDVD.universalSwitchIDforOK,
                           mediaDVD.universalSwitchIDforPREVChapter,
                           mediaDVD.universalSwitchIDforNextChapter,
                           mediaDVD.universalSwitchIDforPlayPause,
                           
                           mediaDVD.universalSwitchIDforPlayRecord,
                           mediaDVD.universalSwitchIDforPlayStopRecord,
                           mediaDVD.iRMacroNumberForDVDStart0,
                           mediaDVD.iRMacroNumberForDVDStart1,
                           mediaDVD.iRMacroNumberForDVDStart2,
                           mediaDVD.iRMacroNumberForDVDStart3,
                           mediaDVD.iRMacroNumberForDVDStart4,
                           mediaDVD.iRMacroNumberForDVDStart5
                           ];
    
    BOOL res = [self executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        return [[[[self selectProprty:@"select max(ID) from DVDInZone;"] lastObject] objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}

/// 保存当前的DVD数据
- (void)updateMediaDVDInZone:(SHMediaDVD *)mediaDVD {
    
    NSString *saveSql = [NSString stringWithFormat:@"update DVDInZone       \
                         set remark = '%@', SubnetID = %d, DeviceID = %d,   \
                         UniversalSwitchIDforOn = %tu,\
                         UniversalSwitchStatusforOn = %tu, \
                         UniversalSwitchIDforOff = %tu,\
                         UniversalSwitchStatusforOff = %tu, \
                         \
                         UniversalSwitchIDfoMenu = %tu, \
                         UniversalSwitchIDfoUp = %tu,\
                         UniversalSwitchIDforDown = %tu,\
                         UniversalSwitchIDforFastForward = %tu,\
                         UniversalSwitchIDforBackForward = %tu, \
                         UniversalSwitchIDforOK = %tu,\
                         UniversalSwitchIDforPREVChapter = %tu,\
                         UniversalSwitchIDforNextChapter = %tu,\
                         UniversalSwitchIDforPlayPause = %tu, \
                         UniversalSwitchIDforPlayRecord = %tu,\
                         UniversalSwitchIDforPlayStopRecord = %tu,\
                         \
                         IRMacroNumberForDVDStart0 = %tu, \
                         IRMacroNumberForDVDStart1 = %tu,\
                         IRMacroNumberForDVDStart2 = %tu,\
                         IRMacroNumberForDVDStart3 = %tu,\
                         IRMacroNumberForDVDStart4 = %tu,\
                         IRMacroNumberForDVDStart5 = %tu \
                         Where zoneID = %tu and id = %tu;",
                         
                         mediaDVD.remark,
                         mediaDVD.subnetID, mediaDVD.deviceID,
                         
                         mediaDVD.universalSwitchIDforOn,
                         mediaDVD.universalSwitchStatusforOn,
                         mediaDVD.universalSwitchIDforOff,
                         mediaDVD.universalSwitchStatusforOff,
                         
                         mediaDVD.universalSwitchIDfoMenu,
                         mediaDVD.universalSwitchIDfoUp,
                         mediaDVD.universalSwitchIDforDown,
                         mediaDVD.universalSwitchIDforFastForward,
                         mediaDVD.universalSwitchIDforBackForward,
                         mediaDVD.universalSwitchIDforOK,
                         mediaDVD.universalSwitchIDforPREVChapter,
                         mediaDVD.universalSwitchIDforNextChapter,
                         
                         mediaDVD.universalSwitchIDforPlayPause,
                         mediaDVD.universalSwitchIDforPlayRecord,
                         mediaDVD.universalSwitchIDforPlayStopRecord,
                         
                         mediaDVD.iRMacroNumberForDVDStart0,
                         mediaDVD.iRMacroNumberForDVDStart1,
                         mediaDVD.iRMacroNumberForDVDStart2,
                         mediaDVD.iRMacroNumberForDVDStart3,
                         mediaDVD.iRMacroNumberForDVDStart4,
                         mediaDVD.iRMacroNumberForDVDStart5,
                         
                         mediaDVD.zoneID, mediaDVD.id
                         ];
    
    [self executeSql:saveSql];
}



// MARK: - 窗帘数据

/// 增加窗帘的字段
- (void)addShadeOPeratorTypeAndRemark {
    
    // 增加停止通道(三个继电器控制窗帘的)
    if (![self isColumnName:@"stopChannel" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD stopChannel INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 停止比例(保留参数)
    if (![self isColumnName:@"stoppingRatio" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD stoppingRatio INTEGER NOT NULL DEFAULT 0;"];
    }
    
    //  增加三个文字标注
    if (![self isColumnName:@"remarkForOpen" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD remarkForOpen TEXT NOT NULL DEFAULT '';"];
    }
    
    if (![self isColumnName:@"remarkForClose" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD remarkForClose TEXT NOT NULL DEFAULT '';"];
    }
    
    if (![self isColumnName:@"remarkForStop" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD remarkForStop TEXT NOT NULL DEFAULT '';"];
    }
    
    // 增加其它方的操作字段
    
    // 控制窗帘的操作方式
    if (![self isColumnName:@"controlType" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD controlType INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 增加窗帘的开
    if (![self isColumnName:@"switchIDforOpen" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD switchIDforOpen INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 开状态
    if (![self isColumnName:@"switchIDStatusforOpen" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD switchIDStatusforOpen INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 关
    if (![self isColumnName:@"switchIDforClose" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD switchIDforClose INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 关状态
    if (![self isColumnName:@"switchIDStatusforClose" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD switchIDStatusforClose INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 停
    if (![self isColumnName:@"switchIDforStop" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD switchIDforStop INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 停状态
    if (![self isColumnName:@"switchIDStatusforStop" consistinTable:@"ShadeInZone"]) {
        
        [self executeSql:@"ALTER TABLE ShadeInZone ADD switchIDStatusforStop INTEGER NOT NULL DEFAULT 0;"];
    }
}

/// 插入新的窗帘
- (BOOL)insertNewShade:(SHShade *)shade {
    
    NSString *sql = [NSString stringWithFormat:
                     @"insert into ShadeInZone (ZoneID, ShadeID, ShadeName, \
                     HasStop, SubnetID, DeviceID, openChannel, openingRatio, \
                     closeChannel, closingRatio, Reserved1, Reserved2,       \
                     remarkForOpen, remarkForClose, remarkForStop,          \
                     controlType, switchIDforOpen, switchIDStatusforOpen,   \
                     switchIDforClose, switchIDStatusforClose,              \
                     switchIDforStop, switchIDStatusforStop, stopChannel,   \
                     stoppingRatio) values(%tu, %tu, '%@', %d, %d, %d, %d,  \
                     %d, %d, %d, %tu, %tu, '%@', '%@', '%@', %tu, %tu,      \
                     %tu, %tu, %tu, %tu, %tu, %d, %d);",
                     
                     shade.zoneID, shade.shadeID,
                     shade.shadeName, shade.hasStop,
                     shade.subnetID, shade.deviceID,
                     shade.openChannel, shade.openingRatio,
                     shade.closeChannel, shade.closingRatio,
                     shade.reserved1, shade.reserved2,
                     shade.remarkForOpen,
                     shade.remarkForClose,
                     shade.remarkForStop,
                     shade.controlType,
                     shade.switchIDforOpen,
                     shade.switchIDStatusforOpen,
                     shade.switchIDforClose,
                     shade.switchIDStatusforClose,
                     shade.switchIDforStop,
                     shade.switchIDStatusforStop,
                     shade.stopChannel,
                     shade.stoppingRatio
                     ];
    
    return [self executeSql:sql];
}

/// 保存当前窗帘数据
- (void)updateShadeInZone:(SHShade *)shade {
    
    NSString *saveSql = [NSString stringWithFormat:@"update ShadeInZone \
                         set SubnetID = %d, DeviceID = %d,           \
                         ShadeName = '%@', HasStop = %d,             \
                         openChannel = %d, openingRatio = %d,        \
                         closeChannel = %d, closingRatio = %d,       \
                         Reserved1 = %tu, Reserved2 = %tu ,          \
                         remarkForOpen = '%@', remarkForClose = '%@',\
                         remarkForStop = '%@', controlType = %tu,    \
                         switchIDforOpen = %tu,                      \
                         switchIDStatusforOpen = %tu,                \
                         switchIDforClose = %tu,                     \
                         switchIDStatusforClose = %tu,               \
                         switchIDforStop = %tu,                      \
                         switchIDStatusforStop = %tu,                \
                         stopChannel = %d, stoppingRatio = %d        \
                         Where zoneID = %tu and ShadeID = %tu;",
                         
                         shade.subnetID, shade.deviceID,
                         shade.shadeName,
                         shade.hasStop, shade.openChannel,
                         shade.openingRatio,
                         shade.closeChannel, shade.closingRatio,
                         shade.reserved1, shade.reserved2,
                         shade.remarkForOpen, shade.remarkForClose,
                         shade.remarkForStop, shade.controlType,
                         shade.switchIDforOpen,
                         shade.switchIDStatusforOpen,
                         shade.switchIDforClose,
                         shade.switchIDStatusforClose,
                         shade.switchIDforStop,
                         shade.switchIDStatusforStop,
                         shade.stopChannel, shade.stoppingRatio,
                         shade.zoneID, shade.shadeID
                         ];
    
    [self executeSql:saveSql];
}

/// 删除当前的窗帘
- (BOOL)deleteShadeInZone:(SHShade *)shade {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from ShadeInZone Where zoneID = %tu and    \
            ShadeID = %tu and SubnetID = %d and DeviceID = %d;",
                           
            shade.zoneID, shade.shadeID,
            shade.subnetID, shade.deviceID
        ];
    
    return [self executeSql:deleteSql];
}

/// 删除区域中的所有窗帘
- (BOOL)deleteZoneShades:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from ShadeInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
}

/// 获得当前区域的最大shadeID
- (NSUInteger)getMaxShadeIDForZone:(NSUInteger)zoneID {
    
    NSString *sql = [NSString stringWithFormat:@"select max(ShadeID) from ShadeInZone where ZoneID = %tu;", zoneID];
    
    id resID = [[[self selectProprty:sql] lastObject] objectForKey:@"max(ShadeID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 获得指定窗帘
- (SHShade *)getShadeFor:(NSUInteger)zoneID shadeID:(NSUInteger)shadeID {
    
    NSString *shadeSql = [NSString stringWithFormat:@"select id, ZoneID, ShadeID, ShadeName, HasStop, SubnetID, DeviceID, openChannel, openingRatio, closeChannel, closingRatio, Reserved1, Reserved2, remarkForOpen, remarkForClose, remarkForStop, controlType, switchIDforOpen, switchIDStatusforOpen, switchIDforClose, switchIDStatusforClose, switchIDforStop, switchIDStatusforStop, stopChannel, stoppingRatio from ShadeInZone where ZoneID = %tu and ShadeID = %tu;", zoneID, shadeID];
    
    NSDictionary *dict = [[self selectProprty:shadeSql] lastObject];
    
    return [[SHShade alloc] initWithDict:dict];
}

/// 查询当前区域的所所有窗帘
- (NSMutableArray *)getShadeForZone:(NSUInteger)zoneID {
    
    NSString *shadeSql = [NSString stringWithFormat:@"select id, ZoneID, ShadeID, ShadeName, HasStop, SubnetID, DeviceID, openChannel, openingRatio, closeChannel, closingRatio, Reserved1, Reserved2, remarkForOpen, remarkForClose, remarkForStop, controlType, switchIDforOpen, switchIDStatusforOpen, switchIDforClose, switchIDStatusforClose, switchIDforStop, switchIDStatusforStop, stopChannel, stoppingRatio from ShadeInZone where ZoneID = %tu order by ShadeID;", zoneID];
    
    NSMutableArray *array = [self selectProprty:shadeSql];
    
    NSMutableArray *shades = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
    
        [shades addObject:[[SHShade alloc] initWithDict:dict]];
    }
    
    return shades;
}

// MARK: - 音乐

/// 增加可以配置音乐选项卡的使用
- (BOOL)addAudioInZoneSetSourceType {
    
    // 增加一个音乐设备名称的字段
    if (![self isColumnName:@"audioName" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD audioName TEXT NOT NULL DEFAULT 'audio';"];
    }
    
    // 增加SDCard
    if (![self isColumnName:@"haveSdCard" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD haveSdCard INTEGER NOT NULL DEFAULT 1;"];
    }
    
    // 增加FTP
    if (![self isColumnName:@"haveFtp" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD haveFtp INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 增加Radio
    if (![self isColumnName:@"haveRadio" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD haveRadio INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 增加AudioIN
    if (![self isColumnName:@"haveAudioIn" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD haveAudioIn INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 增加Phone
    if (![self isColumnName:@"havePhone" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD havePhone INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 增加U盘
    if (![self isColumnName:@"haveUdisk" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD haveUdisk INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 增加蓝牙
    if (![self isColumnName:@"haveBluetooth" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD haveBluetooth INTEGER NOT NULL DEFAULT 0;"];
    }
    
    // 增加判断当前是否为 mini Audio
    if (![self isColumnName:@"isMiniZAudio" consistinTable:@"ZaudioInZone"]) {
        
        [self executeSql:@"ALTER TABLE ZaudioInZone ADD isMiniZAudio INTEGER NOT NULL DEFAULT 0;"];
    }
    
    return YES;
}

/// 存入新的音乐设备
- (NSInteger)insertNewAudio:(SHAudio *)audio {
    
    NSString *insertSQL = [NSString stringWithFormat:
        @"insert into ZaudioInZone (ZoneID, SubnetID,     \
        DeviceID, haveSdCard, haveFtp, haveRadio,         \
        haveAudioIn, havePhone, haveUdisk, haveBluetooth, \
        isMiniZAudio, audioName) values                   \
        (%tu, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, '%@');",
                           
                           audio.zoneID,
                           audio.subnetID,
                           audio.deviceID,
                           audio.haveSdCard,
                           audio.haveFtp,
                           audio.haveRadio,
                           audio.haveAudioIn,
                           audio.havePhone,
                           audio.haveUdisk,
                           audio.haveBluetooth,
                           audio.isMiniZAudio,
                           audio.audioName
                           ];
    
    BOOL res = [self executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        // 获得ID号
        NSString *string = [NSString stringWithFormat:@"select max(ID) from ZaudioInZone;"];
        
        maxID =  [[[[self selectProprty:string] lastObject] objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}

/// 保存当前的音乐数据
- (void)updateAudioInZone:(SHAudio *)audio {
    
    NSString *saveSql = [NSString stringWithFormat:
        @"update ZaudioInZone set ZoneID = %tu,             \
        SubnetID = %d, DeviceID = %d, haveSdCard = %d,      \
        haveFtp = %d, haveRadio = %d, haveAudioIn = %d,     \
        havePhone = %d, haveUdisk = %D, haveBluetooth = %d, \
        isMiniZAudio = %d, audioName = '%@'                 \
        Where zoneID = %tu and id = %tu;",
                         
                         audio.zoneID,
                         audio.subnetID,
                         audio.deviceID,
                         audio.haveSdCard,
                         audio.haveFtp,
                         audio.haveRadio,
                         audio.haveAudioIn,
                         audio.havePhone,
                         audio.haveUdisk,
                         audio.haveBluetooth,
                         audio.isMiniZAudio,
                         audio.audioName,
                         audio.zoneID, audio.id
                         ];
    
    [self executeSql:saveSql];
}

/// 删除当前的音乐设备
- (BOOL)deleteAudioInZone:(SHAudio *)audio {
    
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from ZaudioInZone Where zoneID = %tu    \
                           and SubnetID = %d and DeviceID = %d;",
                           audio.zoneID, audio.subnetID, audio.deviceID
                           ];
    
    return [self executeSql:deleteSql];
}

/// 删除整个区域的音乐设备
- (BOOL)deleteZoneAudios:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from ZaudioInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
}

/// 查询当前区域中的所有Audio
- (NSMutableArray *)getAudioForZone:(NSUInteger)zoneID {
    
    NSMutableArray *array = [self getAllZonesAudioDevices];
    
    NSMutableArray *audioDevices = [NSMutableArray array];
    
    for (SHAudio *audio in array) {
        
        if (audio.zoneID == zoneID) {
            
            [audioDevices addObject:audio];
        }
    }
    
    return audioDevices;
}

/// 获得所有的音乐设备数据
- (NSMutableArray *)getAllZonesAudioDevices {
    
    NSString *allZonesAudioSql = [NSString stringWithFormat:
        @"select ID, ZoneID, SubnetID, DeviceID, haveSdCard,    \
        haveFtp, haveRadio, haveAudioIn, havePhone, haveUdisk,  \
        haveBluetooth, isMiniZAudio, audioName from ZaudioInZone order by ID;"
    ];
    
    NSArray *array = [self selectProprty:allZonesAudioSql];
    
    NSMutableArray *allZonesAudioDevices = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [allZonesAudioDevices addObject:
            [[SHAudio alloc] initWithDictionary:dict]
        ];
    }
    
    return allZonesAudioDevices;
}

// MARK: - HVAC

/// 增加通用温度传感器显示空调
- (void)addRoomTemperatureShow {
    
    // 增加用于显示温度的传感器的三个参数
    if (![self isColumnName:@"temperatureSensorSubNetID" consistinTable:@"HVACInZone"]) {
        
        [self executeSql:@"ALTER TABLE HVACInZone ADD temperatureSensorSubNetID INTEGER NOT NULL DEFAULT 1;"];
    }
    
    if (![self isColumnName:@"temperatureSensorDeviceID" consistinTable:@"HVACInZone"]) {
        
        [self executeSql:@"ALTER TABLE HVACInZone ADD temperatureSensorDeviceID INTEGER NOT NULL DEFAULT 0;"];
    }
    
    if (![self isColumnName:@"temperatureSensorChannelNo" consistinTable:@"HVACInZone"]) {
        
        [self executeSql:@"ALTER TABLE HVACInZone ADD temperatureSensorChannelNo INTEGER NOT NULL DEFAULT 0;"];
    }
}

/// 保存当前的空调数据
- (void)updateHVACInZone:(SHHVAC *)hvac {
    
    NSString *saveSql = [NSString stringWithFormat:
                         @"update HVACInZone set ZoneID = %tu, SubnetID = %d, \
                         DeviceID = %d, ACNumber = %tu, ACTypeID = %d,        \
                         ACRemark = '%@', temperatureSensorSubNetID = %d,     \
                         temperatureSensorDeviceID = %d,                      \
                         temperatureSensorChannelNo = %d, channelNo = %d      \
                         Where zoneID = %tu and id = %tu;",
                         
                         hvac.zoneID, hvac.subnetID,
                         hvac.deviceID, hvac.acNumber,
                         hvac.acTypeID, hvac.acRemark,
                         hvac.temperatureSensorSubNetID,
                         hvac.temperatureSensorDeviceID,
                         hvac.temperatureSensorChannelNo,
                         hvac.channelNo,
                         hvac.zoneID, hvac.id
                         ];
    
    [self executeSql:saveSql];
}

/// 删除当前的空调
- (BOOL)deleteHVACInZone:(SHHVAC *)hvac {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from HVACInZone Where zoneID = %tu and  \
            SubnetID = %d and DeviceID = %d and ACNumber = %tu;",
                           
            hvac.zoneID, hvac.subnetID,
            hvac.deviceID, hvac.acNumber
        ];
    
    return [self executeSql:deleteSql];
}

/// 删除整个区域的空调
- (BOOL) deleteZoneHVACs:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from HVACInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
}

/// 增加新的空调 返回ID
- (NSInteger)insertNewHVAC:(SHHVAC *)hvac {
    
    NSString *insertSQL =
        [NSString stringWithFormat:
            @"insert into HVACInZone (ZoneID, SubnetID,             \
            DeviceID, ACNumber, ACTypeID, ACRemark,                 \
            temperatureSensorSubNetID, temperatureSensorDeviceID,   \
            temperatureSensorChannelNo, channelNo)                  \
            values(%tu, %d, %d, %tu, %d, '%@',                      \
            %d, %d, %d, %d);",
                           
            hvac.zoneID, hvac.subnetID,
            hvac.deviceID, hvac.acNumber,
            hvac.acTypeID, hvac.acRemark,
            hvac.temperatureSensorSubNetID,
            hvac.temperatureSensorDeviceID,
            hvac.temperatureSensorChannelNo,
            hvac.channelNo
        ];
    
    
    BOOL res = [self executeSql:insertSQL];
    
    NSInteger maxID = -1;
    
    if (res) {
        
        // 获得ID号
        NSString *string = [NSString stringWithFormat:@"select max(ID) from HVACInZone;"];
        
        maxID =  [[[[self selectProprty:string] lastObject] objectForKey:@"max(ID)"] integerValue];
    }
    
    return maxID;
}


/// 查询当前区域中的所有HAVC
- (NSMutableArray *)getHVACForZone:(NSUInteger)zoneID {
    
    NSString *hvacSql = [NSString stringWithFormat:@"select id, ZoneID, SubnetID, DeviceID, ACNumber, ACTypeID, acRemark, temperatureSensorSubNetID, temperatureSensorDeviceID, temperatureSensorChannelNo, channelNo from HVACInZone where ZoneID = %tu;", zoneID];
    
    
    NSMutableArray *array = [self selectProprty:hvacSql];
    
    NSMutableArray *hvacs = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
       
        SHHVAC *ac = [[SHHVAC alloc] initWithDictionary:dict];
         [hvacs addObject:ac];
    }
    
    return hvacs;
}

/// 设置配置空调的单位是否摄氏度
- (BOOL)updateHVACSetUpInfoTempertureFlag:(BOOL)isCelsius {
    
    NSString * updateSql = [NSString stringWithFormat:@"update HVACSetUp set isCelsius = %d;", isCelsius];
    
    return [self executeSql:updateSql];
}

/// 获得空调的配置信息
- (SHHVACSetUpInfo *)getHVACSetUpInfo {
    
    NSString *sql = @"select isCelsius, TempertureOfCold, TempertureOfCool, TempertureOfWarm, TempertureOfHot from HVACSetUp;";
    
    NSDictionary *dict = [[self selectProprty:sql] lastObject];
    
    return [[SHHVACSetUpInfo alloc] initWithDict:dict];
}
 
/// 删除整个区域的灯泡
- (BOOL)deleteZoneLights:(NSUInteger)zoneID {
    
    NSString *deleteSQL =
        [NSString stringWithFormat:
            @"delete from LightInZone Where zoneID = %tu;",
            zoneID
        ];
    
    return [self executeSql:deleteSQL];
}


// MARK: - 风扇

/// 删除区域中的所有风扇
- (BOOL)deleteZoneFans:(NSUInteger)zoneID {
    
    NSString *deleteSql =
        [NSString stringWithFormat:
            @"delete from FanInZone Where zoneID = %tu ;",
            zoneID
        ];
    
    return [self executeSql:deleteSql];
}



// MARK: - 区域操作相关

/// 保存当前区域的所有设备
- (void)saveAllSystemID:(NSMutableArray *)systems inZone:(SHZone *)zone {
    
    // 删除这个区域的所有设备
    NSString *systemDeleteSql = [NSString stringWithFormat:@"delete from SystemInZone where ZoneID = %tu;", zone.zoneID];
    
    [self executeSql:systemDeleteSql];
    
    // 全部插入重新新数据
    for (NSNumber *number in systems) {
        NSString *systemInsertSql = [NSString stringWithFormat:@"insert into SystemInZone values(%tu, %tu);", zone.zoneID, [number integerValue]];
        [self executeSql:systemInsertSql];
    }
}


/// 查询当前区域中包含的所有设备
- (NSMutableArray *)getSystemID:(NSUInteger)zoneID {
    
    NSString *systemSql =
        [NSString stringWithFormat:
            @"select ZoneID, SystemID from SystemInZone \
         where ZoneID = %tu order by SystemID;",
            zoneID
        ];
    
    NSMutableArray *array = [self selectProprty:systemSql];
    
    NSMutableArray *systems =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        SHSystem *deviceSystem =
            [[SHSystem alloc] initWithDict:dict];
        
        [systems addObject:@(deviceSystem.systemID)];
    }
    
    return systems;
}

/// 获得所有的系统名称
- (NSMutableArray *)getAllSystemName {
    
    NSString *sql = @"select SystemName from systemDefnition order by SystemID;";
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *systemNames = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        //        SHLog(@"%@", dict);
        [systemNames addObject:[dict objectForKey:@"SystemName"]];
    }
    
    return systemNames;
}

// MARK: - 区域图片操作

/// 根据名称获得图片
- (SHIcon *)getIcon:(NSString *)iconName {
    
    NSString *selectSQL = [NSString stringWithFormat:@"select iconID, iconName, iconData from iconList where iconName = '%@';", iconName];
    
    return [[SHIcon alloc] initWithDict:[[self selectProprty:selectSQL] lastObject]];
}

/// 获得最大的系统图标ID
- (NSUInteger)getMaxIconIDForSystemIcon {
    
    return maxIconIDForDataBase;
}

/// 获得最大的图标ID
- (NSUInteger)getMaxIconID {
    
    // 获得结果ID
    id resID = [[[self selectProprty:@"select max(iconID) from iconList"] lastObject] objectForKey:@"max(iconID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 删除一个图片记录
- (BOOL)deleteIcon:(SHIcon *)icon {
    
    NSString *iconSql = [NSString stringWithFormat:@"delete from iconList where iconID = %tu;", icon.iconID];
    
    return [self executeSql:iconSql];
}

/// 插入一个新图片
- (BOOL)inserNewIcon:(SHIcon *)icon {
    
    __block BOOL res = YES;
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        // 这种语法相当怪异
        res = [db executeUpdate:@"INSERT INTO iconList (iconID, iconName, iconData) VALUES (?, ?, ?);", @(icon.iconID), icon.iconName, icon.iconData];
    }];
    
    return res;
}

/// 查询所有的图标
- (NSMutableArray *)getAllIcons {
    
    NSString *iconsSql = @"select iconID, iconName, iconData from iconList order by iconID";
    
    NSMutableArray *array = [self selectProprty:iconsSql];
    
    NSMutableArray *icons = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [icons addObject:[[SHIcon alloc] initWithDict:dict]];
    }
    
    return icons;
}

/// 增加图片的二进制字段
- (BOOL)addZoneIconData {
    
    if (![self isColumnName:@"iconData" consistinTable:@"iconList"]) {
        
        // 增加remark
        [self executeSql:@"ALTER TABLE iconList ADD iconData DATA;"];
        
        // 原来沙盒中的图全部获取出来，导入到数据库当中
        NSString *imagesSQL = [NSString stringWithFormat:@"select iconID, iconName from iconList where iconID > %tu;", [self getMaxIconIDForSystemIcon]];
        
        NSMutableArray *array = [self selectProprty:imagesSQL];
        
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


// MARK: - 区域操作

/// 获得指定的zone的详细信息
- (SHZone *)getZone:(NSUInteger)zoneID {
    
    NSString *sql = [NSString stringWithFormat:@"select regionID, ZoneID, ZoneName, zoneIconName from Zones where ZoneID = %tu", zoneID];
    
    NSDictionary *dict = [[self selectProprty:sql] lastObject];
    
    return [[SHZone alloc] initWithDictionary:dict];
}

/// 查询指定表格中的区域ID
- (NSMutableArray *)getZoneIDFromTable:(NSString *)tableName {
    
    NSString *selectSql =
    [NSString stringWithFormat:
     @"select DISTINCT ZoneID from %@;", tableName]
    ;
    
    NSMutableArray *array = [self selectProprty:selectSql];
    
    NSMutableArray *zoneIDs =
    [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [zoneIDs addObject:[dict objectForKey:@"ZoneID"]];
    }
    
    return zoneIDs;
}

/// 删除区域
- (BOOL)deleteZone:(NSUInteger)zoneID {
    
    BOOL executeResult = NO;
    
    // 1.查询这个区域所包含的设备
    NSArray *systems = [self getSystemID:zoneID];
    
    for (NSNumber *system in systems) {
        
        switch (system.integerValue) {
            
            case SHSystemDeviceTypeLight: {
                
                [self deleteZoneLights:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeHvac: {
                
                [self deleteZoneHVACs:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeAudio: {
                
                [self deleteZoneAudios:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeShade: {
                
                [self deleteZoneShades:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeTv: {
                
                [self deleteZoneTVs:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeDvd: {
                
                [self deleteZoneDVDs:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeSat: {
                
                [self deleteZoneSATs:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeAppletv: {
                
                [self deleteZoneAppleTVs:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeProjector: {
                
                [self deleteZoneProjectors:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeMood: {
                
                [self deleteZoneMoods:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeFan: {
                
                [self deleteZoneFans:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeFloorHeating: {
                
                [self deleteZoneFloorHeatings:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeNineInOne: {
                
                [self deleteZoneNineInOnes:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeDryContact: {
                
//                [self deleteZoneDryContacts:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeTemperatureSensor: {
                
//                [self deleteZoneTemperatureSensors:zoneID];
            }
                break;
                
            case SHSystemDeviceTypeDmx: {
                
                [self deleteZoneDMXs:zoneID];
            }
                break;
                
            default:
                break;
        }
    }
    
    // 2.删除区域中的设备
    NSString *systemSQL =
        [NSString stringWithFormat:
            @"delete from SystemInZone where zoneID = %tu;",
            zoneID
        ];
    
    executeResult = [self executeSql:systemSQL];
    
    // 3.删除区域
    NSString *zoneSQL =
        [NSString stringWithFormat:
            @"delete from Zones where zoneID = %tu;",
            zoneID
        ];
    
    executeResult = [self executeSql:zoneSQL];
    
    return executeResult;
}

/// 更新区域信息
- (BOOL)updateZone:(SHZone *)zone {
    
    NSString *zonesSql =
        [NSString stringWithFormat:
            @"update Zones set ZoneName = '%@', zoneIconName = '%@' \
            Where zoneID = %tu;",
         zone.zoneName, zone.zoneIconName, zone.zoneID
        ];
    
    return [self executeSql:zonesSql];
}

/// 插入一个新增加的区域
- (BOOL)insertNewZone:(SHZone *)zone {
    
    NSString *zoneSql =
        [NSString stringWithFormat:
            @"insert into Zones(regionID, ZoneID, ZoneName, zoneIconName) values(%tu, %tu, '%@', '%@'); ",
            zone.regionID,
            zone.zoneID,
            zone.zoneName,
            zone.zoneIconName];
    
    return [self executeSql:zoneSql];
}

/// 获得最大的区域ID
- (NSUInteger)getMaxZoneID {
    
    // 获得结果ID
    id resID = [[[self selectProprty:@"select max(zoneID) from Zones"] lastObject] objectForKey:@"max(zoneID)"];
    
    return (resID == [NSNull null]) ? 0 : [resID integerValue];
}

/// 查询所有的区域
- (NSMutableArray *)getAllZones {
    
    NSString *zonesSql = @"select zoneID, ZoneName, zoneIconName from Zones order by zoneID;";
    
    NSMutableArray *array = [self selectProprty:zonesSql];
    
    NSMutableArray *zones = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [zones addObject:[[SHZone alloc] initWithDictionary:dict]];
    }
    
    return zones;
}

/// 查询指定region的所有区域
- (NSMutableArray *)getZonesForRegion:(NSUInteger)regionID {
    
    NSString *zonesSql = [NSString stringWithFormat:@"select zoneID, ZoneName, zoneIconName from Zones where regionID = %tu order by zoneID;", regionID];
    
    NSMutableArray *array = [self selectProprty:zonesSql];
    
    NSMutableArray *zones = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [zones addObject:[[SHZone alloc] initWithDictionary:dict]];
    }
    
    return zones;
}

/// 获得指示类型的区域
- (NSMutableArray *)getZonesFor:(NSUInteger)deviceType {
    
    // 1. 先找出包含这个类型的区域ID
    
    NSString *systemSql = [NSString stringWithFormat:@"select distinct ZoneID from SystemInZone where SystemID = %tu order by zoneID;", deviceType];
    
    NSMutableArray *array = [self selectProprty:systemSql];
    
    NSMutableArray *zones = [NSMutableArray array];
    
    // 从结果中再找区域
    for (NSDictionary *dict in array) {
        
        NSUInteger zoneID = [[dict objectForKey:@"ZoneID"] integerValue];
        
        NSString *zonesSql = [NSString stringWithFormat:@"select zoneID, ZoneName, zoneIconName from Zones where zoneID = %tu order by zoneID;", zoneID];
        
        NSDictionary *zoneDict = [[self selectProprty:zonesSql] lastObject];
        
        if (!zoneDict) {
            continue;
        }
        
        SHZone *zone = [[SHZone alloc] initWithDictionary:zoneDict];
        [zones addObject: zone];
    }
    
    return zones;
}

// MARK: - 多分组操作

/// 删除地区
- (BOOL)deleteRegion:(NSUInteger)regionID {
    
    // 查询所有对应的区域
    NSMutableArray *zones = [self getZonesForRegion:regionID];
    
    for (SHZone *zone in zones) {
        
        [self deleteZone:zone.zoneID];
    }
    
    // 删除地区
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from Regions where regionID = %tu;", regionID];
    
    return [self executeSql:deleteSQL];
}

 
 

// MARK: - 创建表格

///  创建表格
- (void)createSqlTables {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SQL.sql" ofType:nil];
    
    NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // 创建单张表格
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        if ([db executeStatements:sql]) {
            printLog(@"%@", [FileTools documentPath]);
        }
    }];
}

/// 增加新表或者是字段
- (void)alertTablesOrColumnName {
    
    /**** 1. 版本匹配记录 *****/
    
    // 获得记录版本
    NSString *sandboxVersion =
        [[NSUserDefaults standardUserDefaults]
            objectForKey:sandboxVersionKey];
    
    // 当前应用版本
    NSString *currentVersion =
        [[[NSBundle mainBundle] infoDictionary]
            objectForKey:@"CFBundleShortVersionString"];
    
    if ([sandboxVersion isEqualToString:currentVersion]) {
        return;  // 最新版本不需要更新
    }
    
    // 设置最新版本
    [[NSUserDefaults standardUserDefaults]
        setObject:currentVersion forKey:sandboxVersionKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /**** 2. 删除区域中的旧数据 *****/
    
    // 2.1 有效区域
    NSMutableArray *zones = [self getZoneIDFromTable:@"Zones"];
    
    // 2.2 查询相关配置中的所有区域
    NSMutableArray *systemZoneIDs = [self getZoneIDFromTable:@"SystemInZone"];
    
    // 2.3 找到历史残留的区域
    for (NSNumber *zoneID in zones) {
        
        if ([systemZoneIDs containsObject:zoneID]) {
            [systemZoneIDs removeObject:zoneID]; // 移除合理存在的区域
        }
    }
    
    // 2.4 删除残留区域中的数据
    for (NSNumber *zoneID in systemZoneIDs) {
        
        [self deleteZone:zoneID.integerValue];
    }
    
    /**** 3. 设置字段和新设备 *****/
    
    // 增加地热
    [self addFloorHeating];
    
    // 增加9in1
    [self addNineInOne];
    
    
    // 增加音乐选项卡的配置
    [self addAudioInZoneSetSourceType];
    
    // 增加多媒体设备的标注
    [self addMediaDeviceRemark];
    
    // 增加场景模式的延时功能
    [self addMoodCommandDelaytime];
    
    // 增加窗帘的字段
    [self addShadeOPeratorTypeAndRemark];
    
    // 增加图片的二进制数据
    [self addZoneIconData];
    
    // 增加区域的温度通用显示
    [self addRoomTemperatureShow];
    
    // 增加DMX
    [self addZoneDMX];
    
    // 增加SAT的字段
    [self addSATControlIetms];
    
    // 增加空调中的通道号
    if (![self isColumnName:@"channelNo" consistinTable:@"HVACInZone"]) {
        
        [self executeSql:@"ALTER TABLE HVACInZone ADD channelNo INTEGER NOT NULL DEFAULT 0;"];
    }
}


// MARK: - 公共封装部分


/**
 删除表格
 
 @param name 表格名称
 @return YES - 删除成功 NO - 删除失败
 */
- (BOOL)deleteTable:(NSString *)name {
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@;", name];
    
    return [self executeSql:deleteSQL];
}

/**
 修改数据表的名称
 
 @param srcName 旧名称
 @param destName 新名筄
 @return YES - 修改成功, NO - 修改失败
 */
- (BOOL)renameTable:(NSString *)srcName toName:(NSString *)destName {
    
    NSString *renameSQL = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@;", srcName, destName];
    
    return [self executeSql:renameSQL];
}

/**
 判断表中是否存在字段
 
 @param columnName 字段名称
 @param tableName 表格名称
 @return YES - 存在 NO - 不存在
 */
- (BOOL)isColumnName:(NSString *)columnName consistinTable:(NSString *)tableName {
    
    NSString * sqlstr = [NSString stringWithFormat:@"select * from %@", tableName];
    
    __block FMResultSet * result;
    
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        result = [db executeQuery:sqlstr];
    }];
    
    
    for (int col = 0; col < result.columnCount; col++) {
        
        // 获得字段名称
        NSString * tableColumnName = [result columnNameForIndex:col];
        
        // 判断是否存在 (由于SQL不区分大小，所以需要统一区分成大小。)
        if ([tableColumnName.uppercaseString isEqualToString:columnName.uppercaseString]) {
            
            return YES;
        }
    }
    
    return NO;
}

/// 插入语句 成功返回YES， 失败返回NO。
- (BOOL)executeSql:(NSString *)sql {
    
    __block BOOL res = YES;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        if (![db executeUpdate:sql]) {
            res = NO;
        }
    }];
    
    return res;
}

/// 查询封装语句 -- 注意，它返回的【字典】数组
- (NSMutableArray *)selectProprty:(NSString *)sql {
    
    // 准备一个数组来存储所有内容
    __block NSMutableArray *array = [NSMutableArray array];
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        // 获得全部的记录
        FMResultSet *resultSet = [db executeQuery:sql];
        
        // 遍历结果
        while (resultSet.next) {
            
            // 准备一个字典
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            // 获得列数
            int count = [resultSet columnCount];
            
            // 遍历所有的记录
            for (int i = 0; i < count; i++) {
                
                // 获得字段名称
                NSString *name = [resultSet columnNameForIndex:i];
                
                // 获得字段值
                NSString *value = [resultSet objectForColumn:name];
                
                // 存储在字典中
                dict[name] =  value;
            }
            
            // 添加到数组
            [array addObject:dict];
        }
    }];
    
    return array;
}


/// 创建数据库
- (instancetype)init {
    
    if (self = [super init]) {
        
        // 1.数据库的目标路径
        NSString *filePath = [[FileTools documentPath] stringByAppendingPathComponent:dataBaseName];
        
        // 2.获得资源路径
        NSString *sourceDataBasePath =
            [[[NSBundle mainBundle] resourcePath]
                stringByAppendingPathComponent:dataBaseName];
        
        // 判断路径是否存在
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            if ([[NSFileManager defaultManager] copyItemAtPath:sourceDataBasePath toPath:filePath error:nil]) {
                
            }
        }
        
        // 如果数据库不存在，会建立数据库，然后，再创建队列，并且打开数据库
        self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
        
        // 创建表格
        [self createSqlTables];

        // 增加表名或者是字段
        [self alertTablesOrColumnName];
    }
    
    return self;
}

- (NSString *)dataBaseName {
    
    return dataBaseName;
}

SingletonImplementation(SQLManager)

@end
