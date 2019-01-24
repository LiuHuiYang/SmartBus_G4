//
//  SHSQLManager.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/9.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//


@class SHZone;
@class SHSystem;
@class SHIcon;

@class SHLight;

@class SHHVACSetUpInfo;
@class SHHVAC;

@class SHAudio;

@class SHFan;
@class SHShade;

@class SHMood;
@class SHMoodCommand;

@class SHDmxGroup;
@class SHDmxChannel;

@class SHTemperatureSensor;

@class SHMediaAppleTV;
@class SHMediaDVD;
@class SHMediaSATCategory;
@class SHMediaSATChannel;
@class SHMediaSAT;
@class SHMediaTV;
@class SHMediaProjector;

@class SHFloorHeating;
@class SHNineInOne;
@class SHDryContact;
@class SHScene;
@class SHSequence;


@class SHMacro;
@class SHMacroCommand;

@class SHSecurityZone;

@class SHSchedualCommand;

@class SHCentralLight;
@class SHCentralLightCommand;
@class SHCentralHVAC;

@class SHCurrentTransformer;

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

#import "SHSchedual.h"

// 在数据库中可以iconList直接查询到
extern const NSUInteger maxIconIDForDataBase;

@interface SHSQLManager : NSObject

// MARK: - 9in1

/// 查询当前区域中的所有9in1
- (NSMutableArray *)getNineInOneForZone:(NSUInteger)zoneID;

- (BOOL)updateNineInOneInZone:(SHNineInOne *)nineInOne;

/// 增加一个新的NineInOne
- (BOOL)insertNewNineInOne:(SHNineInOne *)nineInOne;

/// 删除当前的9in1设备
- (BOOL)deleteNineInOneInZone:(SHNineInOne *)nineInOne;

/// 删除区域中的9in1
- (BOOL)deleteZoneNineInOnes:(NSUInteger)zoneID;

/// 获得当前区域中的最大的NineInOneID
- (NSUInteger)getMaxNineInOneIDForZone:(NSUInteger)zoneID;

 
// MARK: - schedaul 相关的操作

/// 获得所有的计划 
- (NSMutableArray *)getAllSchdule;

/// 获得指定的计划
- (SHSchedual *)getSchedualFor:(NSUInteger)findSchedualID;

/// 获得计划的命令集
- (NSMutableArray *)getSchedualCommands:(NSUInteger)findSchedualID;

/// 获得最大的计划ID 
- (NSUInteger)getMaxScheduleID;

/// 删除schedual 及命令
- (BOOL)deleteScheduale:(SHSchedual *)schedual;

/// 只删除schedual中的执行 指令
- (BOOL)deleteSchedualeCommand:(SHSchedual *)schedual;

/// 插入新的计划
- (void)insertNewScheduale:(SHSchedual *)schedual;

/// 插入计划要执行的命令
- (void)insertNewSchedualeCommand:(SHSchedualCommand *)schedualCommand;

/// 更新计划
- (BOOL)updateSchedule:(SHSchedual *)schedual;

 
// MARK: - Projector

/// 保存投影仪数据
- (void)saveMediaProjectorInZone:(SHMediaProjector *)mediaProjector;

/// 增加新的投影仪
- (NSInteger)insertNewMediaProjector:(SHMediaProjector *)mediaProjector;

/// 删除投影仪
- (BOOL)deleteProjectorInZone:(SHMediaProjector *)mediaProjector;

/// 删除区域中的投影仪
- (BOOL)deleteZoneProjectors:(NSUInteger)zoneID;

/// 获得当前区域的投影仪
- (NSMutableArray *)getMediaProjectorFor:(NSUInteger)zoneID;
 
 
// MARK: - icon

/// 根据名称获得图片
- (SHIcon *)getIcon:(NSString *)iconName;

/// 删除一个图片记录
- (BOOL)deleteIcon:(SHIcon *)icon;

/// 插入一个新图片
- (BOOL)inserNewIcon:(SHIcon *)icon;

/// 获得最大的图标ID
- (NSUInteger)getMaxIconID;

/// 查询所有的图标
- (NSMutableArray *)getAllIcons;
 
SingletonInterface(SQLManager)

@end
