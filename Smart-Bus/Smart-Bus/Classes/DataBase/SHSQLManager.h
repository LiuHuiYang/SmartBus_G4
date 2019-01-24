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
