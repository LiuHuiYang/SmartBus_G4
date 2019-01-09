//
//  SHAudioTools.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHAudioTools.h"

@implementation SHAudioTools


// MARK: - 解析数据中的歌曲信息

/**
 解析名称列表
 
 @param subNetID 子网ID
 @param deviceID 设备ID
 @param sourceType 音乐来源类型
 @param nameList 接收到的名称
 @param isAlbum YES 为专辑 NO为歌曲名称
 @param currentAlbumNumber 当前专辑号【当 isAlbum为YES时, 该参数无效】
 */
+ (void)parseNameList:(Byte)subNetID
             deviceID:(Byte)deviceID
           sourceType:(SHAudioSourceType)sourceType
             nameList:(NSString *)nameList
              isAlbum:(BOOL)isAlbum
   currentAlbumNumber:(NSUInteger) currentAlbumNumber {
    
    // 1.获得文件夹
    NSString *folderName =
 
    [SHAudioOperatorTools getAudioPathWithSubNetID:subNetID deviceID:deviceID sourceType:sourceType fileType:SHAudioSourceFileTypeDirectory serialNumber:0];
    
    // 创建文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderName]) {
        
        [[NSFileManager defaultManager]
         createDirectoryAtPath:folderName
         withIntermediateDirectories:YES
         attributes:nil
         error:nil
         ];
    }
    
    // 初始化数组
    NSMutableArray *writeFileArray = [[NSMutableArray alloc] init];
    
    if (isAlbum) { // 专辑
        
        NSArray *everyGroup = [nameList componentsSeparatedByString:@"++"];
        
        // 专辑后缀
        NSString *const albumSuffix = (sourceType == SHAudioSoureNumberSdCard) ? @".PL" : @".pl";
        
        for (NSUInteger i = 1; i < [everyGroup count]; i++) {
            
            NSString *everyGroupName = [everyGroup objectAtIndex:i];
            
            NSArray *nameArray = [everyGroupName componentsSeparatedByString:albumSuffix];
            
            NSString *realName = [nameArray objectAtIndex:0];
            
            [writeFileArray addObject:realName];
        }
        
        NSString *writeFileString =
        [NSString stringWithFormat:@"%d_%d_%d",
         subNetID, deviceID, sourceType
         ];
        
        NSDictionary *writeFileDict = [NSDictionary dictionaryWithObjectsAndKeys: writeFileArray,writeFileString, nil];
       
        // 文件路径
        NSString *filePath =
        
            [SHAudioOperatorTools getAudioPathWithSubNetID:subNetID deviceID:deviceID sourceType:sourceType fileType:SHAudioSourceFileTypeAlbum serialNumber:0];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            [writeFileDict writeToFile:filePath atomically:YES];
        }
        
    } else {  // 歌曲路径
        
        NSArray *everyGroup = [nameList componentsSeparatedByString:@"++"];
        
        for (NSUInteger i = 1; i < [everyGroup count]; i++) {
            NSString *sSongCuted = [everyGroup objectAtIndex:i];
            [writeFileArray addObject:sSongCuted];
        }
        
        NSString *writeFileString =
        [NSString stringWithFormat:@"%d_%d_%d_%tu",
         subNetID,
         deviceID,
         sourceType,
         currentAlbumNumber
         ];
        
        NSDictionary *writeFileDict = [NSDictionary dictionaryWithObjectsAndKeys:writeFileArray, writeFileString,nil];
        
      
        // 2.获得歌曲文件名
        NSString *filePath = 
            [SHAudioOperatorTools getAudioPathWithSubNetID:subNetID deviceID:deviceID sourceType:sourceType fileType:SHAudioSourceFileTypeSongs serialNumber:currentAlbumNumber];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            [writeFileDict writeToFile:filePath atomically:YES];
        }
    }
}


/**
 接收到的每一段数据进行解析成字符串
 
 @param data 接收到的二进制内容
 @param isAlbum YES - 专辑 / NO - 歌曲
 @param count 获得指定数量(这个参数用于解析字符串时排除不必要的乱码字符)
 @return 解析成的字符串
 */
+ (NSArray *)getNameFrom:(NSData *)data
                 isAlbum:(BOOL)isAlbum
                   count:(NSUInteger)count {
    
    NSMutableArray *nameLists = [NSMutableArray array];
    
    Byte *recivedData = (Byte *)[data bytes];
    
    if (isAlbum) {  // 专辑
        
        // 拼接次数不得超过当前包的总数
        NSUInteger operatorAlbumNameCount = 0;
        
        Byte applendLength = 0;
        
        for (NSUInteger i = 0; i <= [data length]; i += applendLength) {
            
            Byte albumNumber = recivedData[i];   // 列表号
    
            Byte nameLength = recivedData[i + 1]; // 长度
            
            NSData *albumData =
            [NSData dataWithBytes:&recivedData[i + 2]
                           length:nameLength];
            
            NSString *albumName =
                [[NSString alloc]
                    initWithData:albumData encoding:NSUnicodeStringEncoding];
            
            // 专辑号不能是0 专辑名称不能是 SPECIAL
            if (![[[albumName componentsSeparatedByString:@"."] firstObject] isEqualToString:@"SPECIAL"] &&
                (operatorAlbumNameCount < count) &&
                albumNumber) {
                
                NSString *resultString =
                    [NSString stringWithFormat:@"++%d*%@", albumNumber, albumName
                    ];
                
                [nameLists addObject:resultString];
                
                ++operatorAlbumNameCount;
            }
            
            applendLength = nameLength + 2;
        }
        
    } else {  // 音乐
        
        // 拼接次数不得超过当前包的总数
        NSUInteger operatorSongNameCount = 0;
        
        Byte applendLength = 0; // 追加宽度
      
        for (NSUInteger i = 0; i <= [data length]; i += applendLength) {
            
            // 获得专辑的序列号
            Byte songListNumber = (recivedData[i] * 0xFF + recivedData[i + 1]);
            
            Byte songNameLength = recivedData[i + 2];
            
            NSData *songData = [NSData dataWithBytes:&recivedData[i + 3]
                                              length:songNameLength];
            
            NSString *songName =
                [[NSString alloc] initWithData:songData
                                      encoding:NSUnicodeStringEncoding
                ]; 
            
            if (![songName isEqualToString:@"SPECIAL.PLS"] &&
                (operatorSongNameCount < count)            &&
                songName != nil                            &&
                songName.length) {
            
                NSString *resultString =
                    [NSString stringWithFormat:@"++%d*%@",
                        songListNumber, songName
                    ];
                
               [nameLists addObject:resultString];
                
                ++operatorSongNameCount;
            }
            
            applendLength = songNameLength + 3;
        }
    }
    
    return nameLists.copy;
}


// MARK: - 音乐缓存文件的操作

/**
 获得指定文件中的内容
 
 @param filePath 文件路径
 @return 专辑或者歌曲数组
 */
+ (NSMutableArray *)readPlist:(NSString *)filePath {
    
    // 1.初始化数据(返回获得的内容)
    NSMutableArray *plists = [[NSMutableArray alloc] init];
    
    // 2.读取文件存储时需要的字典
    NSDictionary *dictPlist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    NSString *dictKey = [[dictPlist allKeys] firstObject];
    
    // 获得字典中的数组
    NSArray *arrayKeySub = [dictKey componentsSeparatedByString:@"_"];
    
    // 如果是专辑列表
    if ([arrayKeySub count] == 3) {
        
        NSArray *plistCategory = [dictPlist objectForKey:dictKey];
        
        for (NSUInteger i = 0; i < [plistCategory count]; i++) {
            
            // 获得整专辑包含的信息字符串
            NSString *albumFullName = [plistCategory objectAtIndex:i];
            
            NSArray *albumNameArray = [albumFullName componentsSeparatedByString:@"*"];
            
            if ([albumNameArray count] > 1) {
                
                if ([[albumNameArray objectAtIndex:1] isEqualToString:@""]) {
                    
                    printLog(@"类别空项");
                    
                } else {
                    
                    SHAlbum *album = [[SHAlbum alloc] init];
                    album.subNetID = [[arrayKeySub objectAtIndex:0] intValue];
                    album.deviceID = [[arrayKeySub objectAtIndex:1] intValue];
                    album.sourceType = [[arrayKeySub objectAtIndex:2] intValue];
                    
                    album.albumNumber = [[albumNameArray objectAtIndex:0] intValue];
                    album.albumName = [albumNameArray objectAtIndex:1];
                    [plists addObject:album];
                }
            }
        }
        
    } else if([arrayKeySub count] == 4){//为歌曲列表
        
        NSArray *plistSongArray = [dictPlist objectForKey:dictKey];
        
        for (NSUInteger i = 0; i < [plistSongArray count]; i++) {
            
            NSString *songFullName = [plistSongArray objectAtIndex:i];
            
            NSArray *arraySongNameSub = [songFullName componentsSeparatedByString:@"*"];
            
            if ([[arraySongNameSub objectAtIndex:1] isEqualToString:@""]) {
                
                printLog(@"歌曲空项");
                
            } else {
                
                SHSong *song = [[SHSong alloc] init];
                song.subNetID = [[arrayKeySub objectAtIndex:0] intValue];
                song.deviceID = [[arrayKeySub objectAtIndex:1] intValue];
                song.sourceType = [[arrayKeySub objectAtIndex:2] intValue];
                song.albumNumber = [[arrayKeySub objectAtIndex:3] intValue];
                song.songNumber = [[arraySongNameSub objectAtIndex:0] intValue];
                song.songName = [arraySongNameSub objectAtIndex:1];
                [plists addObject:song];
            }
        }
        
    } else {
        
        printLog(@"plist文件内容错误,手动结束程序");
    }
    
    return plists;
}

@end
