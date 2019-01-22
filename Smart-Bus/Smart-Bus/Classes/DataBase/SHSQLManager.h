//
//  SHSQLManager.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/9.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

/// 数据库的名称
extern NSString *dataBaseName;

@class SHRegion;
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

/// 数据库的名称
@property (nonatomic, copy, readonly) NSString *dataBaseName;

/// 全局操作队列
@property (nonatomic, strong) FMDatabaseQueue *queue;

  
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

// MARK: - 地热

/// 查询当前区域中的所有地热
- (NSMutableArray *)getFloorHeatingForZone:(NSUInteger)zoneID;

/// 更新当前地热设备的数据
- (void)updateFloorHeatingInZone:(SHFloorHeating *)floorHeating;

/// 增加地热
- (BOOL)insertNewFloorHeating:(SHFloorHeating *)floorHeating;

/// 删除当前的地热
- (BOOL)deleteFloorHeatingInZone:(SHFloorHeating *)floorHeating;

/// 删除区域中的地热
- (BOOL)deleteZoneFloorHeatings:(NSUInteger)zoneID;

/// 获得当前区域中的最大的FloorHeatingInZone
- (NSUInteger)getMaxFloorHeatingIDForZone:(NSUInteger)zoneID;


// MARK: - Mood

/// 模式命令的最大ID
- (NSUInteger)getMoodCommandMaxID;

- (BOOL)updateMoodCommand:(SHMoodCommand *)command;

/// 删除场景模式中指定的命令
- (BOOL)deleteMoodCommand:(SHMoodCommand *)command;

/// 获得当前模式下的所有指令
- (NSMutableArray *)getAllMoodCommandsFor:(SHMood *)mood;

/// 删除当前的模式包含它所拥有的命令集合
- (BOOL)deleteCurrentMood:(SHMood *)mood;

/// 删除区域中的模式
- (BOOL)deleteZoneMoods:(NSUInteger)zoneID;

/// 插入当前模式的命令
- (BOOL)insertNewMoodCommandFor:(SHMoodCommand *)command;

/// 更新模式
- (BOOL)updateMood:(SHMood *)mood;

/// 插入当前区域的新模式
- (BOOL)insertNewMood:(SHMood *)mood;

/// 模式的最大ID
- (NSUInteger)getMaxIDForMood;

/// 获得当前区域的最大模式ID
- (NSUInteger)getMaxMoodIDFor:(NSUInteger)zoneID;

/// 查询所有的模式按钮
- (NSMutableArray *)getAllMoodFor:(NSUInteger)zoneID;


/// 获得所有的音乐设备数据
- (NSMutableArray *)getAllZonesAudioDevices;

/// 获得空调的配置信息
- (SHHVACSetUpInfo *)getHVACSetUpInfo;

   
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



// MARK: - AppleTV

/// 保存苹果电视
- (void)updateMediaAppleTVInZone:(SHMediaAppleTV *)mediaTV;

/// 删除苹果电视
- (BOOL)deleteAppleTVInZone:(SHMediaAppleTV *)mediaTV;

/// 删除区域中所所有AppleTV
- (BOOL)deleteZoneAppleTVs:(NSUInteger)zoneID;

/// 增加苹果电视
- (NSInteger)insertNewMediaAppleTV:(SHMediaAppleTV *)mediaAppleTV;

/// 获得当前区域中的Apple TV
- (NSMutableArray *)getMediaAppleTVFor:(NSUInteger)zoneID;

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


// MARK: - TV

/// 存入新的TV设备
- (NSInteger)inserNewMediaTV:(SHMediaTV *)mediaTV;

/// 保存当前区域的TV参数
- (void)updateMediaTVInZone:(SHMediaTV *)mediaTV;

/// 删除当前区域的TV
- (BOOL)deleteTVInZone:(SHMediaTV *)mediaTV;

/// 删除区域中的TV
- (BOOL)deleteZoneTVs:(NSUInteger)zoneID;

/// 获得当前区域中的电视
- (NSMutableArray *)getMediaTVFor:(NSUInteger)zoneID;


// MARK: - SAT

// 保存当前SAT
- (void)updateMediaSATInZone:(SHMediaSAT *)mediaSAT;

/// 删除当前的SAT
- (BOOL)deleteSATInZone:(SHMediaSAT *)mediaSAT;

/// 删除区域中的SAT
- (BOOL)deleteZoneSATs:(NSUInteger)zoneID;

/// 增加SAT设备
- (NSInteger)insertNewMediaSAT:(SHMediaSAT *)mediaSAT;

/// 获得当前区域的卫星电视
- (NSMutableArray *)getMediaSATFor:(NSUInteger)zoneID;

/// 获得卫星电视的分类
- (NSMutableArray *)getMediaSATCategory;


/// 增加新的卫星电视分类
- (BOOL)insertNewMediaSATCategory:(SHMediaSATCategory *)category;

/// 删除卫星电视的分类
- (BOOL)deleteMediaSATCategory:(SHMediaSATCategory *)category;

/// 更新卫星电视分类名称
- (BOOL)updateMediaSATCategory:(SHMediaSATCategory *)category;

/// 获得卫星电视指定分类中的所有频道
- (NSMutableArray *)getMediaSATChannelFor:(SHMediaSATCategory *)category;

// MARK: - DVD

/// 保存当前DVD
- (void)updateMediaDVDInZone:(SHMediaDVD *)mediaDVD;

/// 删除当前的DVD
- (BOOL)deleteDVDInZone:(SHMediaDVD *)mediaDVD;

/// 删除区域中的DVD
- (BOOL)deleteZoneDVDs:(NSUInteger)zoneID;

/// 增加DVD设备
- (NSInteger)inserNewMediaDVD:(SHMediaDVD *)mediaDVD;

/// 获得当前区域中的DVD
- (NSMutableArray *)getMediaDVDFor:(NSUInteger)zoneID;

// MARK: - Audio

/// 存入新的音乐设备
- (NSInteger)insertNewAudio:(SHAudio *)audio;

/// 保存当前的音乐数据
- (void)updateAudioInZone:(SHAudio *)audio;

/// 删除当前的音乐设备
- (BOOL)deleteAudioInZone:(SHAudio *)audio;

/// 删除整个区域的音乐设备
- (BOOL)deleteZoneAudios:(NSUInteger)zoneID;

/// 查询当前区域中的所有Audio
- (NSMutableArray *)getAudioForZone:(NSUInteger)zoneID;


// MARK: - HVAC

/// 保存当前的空调数据
- (void)updateHVACInZone:(SHHVAC *)hvac;

/// 删除当前的空调
- (BOOL)deleteHVACInZone:(SHHVAC *)hvac;

/// 删除整个区域的空调
- (BOOL) deleteZoneHVACs:(NSUInteger)zoneID;

/// 增加新的空调
- (NSInteger)insertNewHVAC:(SHHVAC *)hvac;

/// 查询当前区域中的所有HAVC
- (NSMutableArray *)getHVACForZone:(NSUInteger)zoneID;

/// 设置配置空调的单位是否摄氏度
- (BOOL)updateHVACSetUpInfoTempertureFlag:(BOOL)isCelsius;


// MARK: - 系统区域

/// 保存当前区域的所有设备
- (void)saveAllSystemID:(NSMutableArray *)systems inZone:(SHZone *)zone;

/// 查询当前区域中包含的所有设备
- (NSMutableArray *)getSystemID:(NSUInteger)zoneID;

// MARK: - icon

/// 根据名称获得图片
- (SHIcon *)getIcon:(NSString *)iconName;

/// 删除一个图片记录
- (BOOL)deleteIcon:(SHIcon *)icon;

/// 插入一个新图片
- (BOOL)inserNewIcon:(SHIcon *)icon;

/// 获得最大的系统图标ID
- (NSUInteger)getMaxIconIDForSystemIcon;

/// 获得所有的系统名称
- (NSMutableArray *)getAllSystemName;

/// 获得最大的图标ID
- (NSUInteger)getMaxIconID;

/// 查询所有的图标
- (NSMutableArray *)getAllIcons;


// MARK: - ZONES

/// 获得指定的zone
- (SHZone *)getZone:(NSUInteger)zoneID;

/// 删除区域
- (BOOL)deleteZone:(NSUInteger)zoneID;

/// 更新区域信息
- (BOOL)updateZone:(SHZone *)zone;

/// 插入一个新增加的区域
- (BOOL)insertNewZone:(SHZone *)zone;

/// 获得最大的区域ID
- (NSUInteger)getMaxZoneID;

/// 查询所有的区域
- (NSMutableArray *)getAllZones;

/// 查询指定region的所有区域
- (NSMutableArray *)getZonesForRegion:(NSUInteger)regionID;

/// 获得指示类型的区域
- (NSMutableArray *)getZonesFor:(NSUInteger)deviceType;


// MARK: - 分组多区域操作
  
/// 删除分组区域
- (BOOL)deleteRegion:(NSUInteger)regionID;

SingletonInterface(SQLManager)

@end
