//
//  SHAudioTools.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 声音的最大值
#define SHAUDIO_MAX_VOLUME (79)
//const Byte SHAUDIO_MAX_VOLUME = 79;

// MARK: - ================= 控制方式 =================

/// 普通Audio的音乐来源 (用于请求数据)
typedef NS_ENUM(UInt8, SHAudioSourceType) {
    SHAudioSourceTypeUnKnow     =   0,
    SHAudioSourceTypeSDCARD     =   1,
    SHAudioSourceTypeFTP        =   2,
    SHAudioSourceTypeAUDIOIN    =   3,
    SHAudioSourceTypeRADIO      =   4,
    SHAudioSourceTypePHONE      // 这个功能是没有的
};

/// 普通Audio的来源切换
typedef NS_ENUM(UInt8, SHAudioSoureNumber) {
    
    SHAudioSoureNumberSdCard    =   1,
    SHAudioSoureNumberAudioIn   =   2,
    SHAudioSoureNumberFtpServer =   3,
    SHAudioSoureNumberFMRadio   =   4
} ;


/// miniZAudio的音乐来源切换 (用于请求数据, 但现在不支持, 下面的是假值)
typedef NS_ENUM(UInt8, SHMiniZAudioSourceType) {
    SHMiniZAudioSourceTypeUnKnow     = 0,
    SHMiniZAudioSourceTypeSDCARD     = 1,
    SHMiniZAudioSourceTypeUDISK         ,
    SHMiniZAudioSourceTypeBLUETOOTH     ,
    SHMiniZAudioSourceTypeRADIO
};

/// miniZAudio的来源切换 (下面的值 需要调试验证)
typedef NS_ENUM(UInt8, SHMiniAudioSoureNumber) {
    SHMiniAudioSoureNumberSdCard      =   1,
    SHMiniAudioSoureNumberBluetooth   =   2,
    SHMiniAudioSoureNumberUdisk       =   3,
    SHMiniAudioSoureNumberFMRadio     =   4
} ;

@interface SHAudioTools : NSObject  

 
// MARK: - 解析歌曲

/**
 解析名称列表
 
 @param subNetID 子网ID
 @param deviceID 设备ID
 @param sourceType 音乐来源类型
 @param nameList 接收到的名称
 @param isAlbum YES 为专辑 为歌曲名称
 @param currentAlbumNumber 当前专辑号【当 isAlbum为YES时, 该参数无效】
 */
+ (void)parseNameList:(Byte)subNetID
             deviceID:(Byte)deviceID
           sourceType:(SHAudioSourceType)sourceType
             nameList:(NSString *)nameList
              isAlbum:(BOOL)isAlbum
   currentAlbumNumber:(NSUInteger) currentAlbumNumber;



/**
 由接收到的每一段数据进行解析成字符串
 
 @param data 接收到的二进制内容
 @param isAlbum YES - 专辑 / NO - 歌曲
 @param count 获得指定数量(这个参数用于解析字符串时排除不必要的乱码字符)
 @return 解析成的字符串
 */
+ (NSArray *)getNameFrom:(NSData *)data
                 isAlbum:(BOOL)isAlbum
                   count:(NSUInteger)count;

// MARK: - 音乐缓存文件的操作

/**
 获得指定文件中的内容
 
 @param filePath 文件路径
 @return 专辑或者歌曲数组
 */
+ (NSMutableArray *)readPlist:(NSString *)filePath;
 
@end
