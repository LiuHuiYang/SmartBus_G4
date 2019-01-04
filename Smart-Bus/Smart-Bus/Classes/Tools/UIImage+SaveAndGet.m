//
//  UIImage+SaveAndGet.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/9.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "UIImage+SaveAndGet.h"

// 图片文件夹
NSString * zoneImageFloderName = @"CommunalServiceTempImageForApp";

NSString *zoneControlImageFloderName = @"zoneControlImageFloderName";


@implementation UIImage (SaveAndGet)

// =======================区域控制部分=============================

/// 区域图片的文件夹路径
+ (NSString *)zoneControlImageFloderPath {

    // 获得图片文件夹的内容
    NSString *pathWithFolder = [[FileTools documentPath] stringByAppendingPathComponent:zoneControlImageFloderName];
    
    return pathWithFolder;
}

/**
 将区域控制图片数据写入到沙盒中去
 */
+ (void)writeZoneControlImageToDocment:(NSString *)iconName data:(UIImage *)image {
    
    // 获得图片文件夹的内容
    NSString *pathWithFolder = [[FileTools documentPath] stringByAppendingPathComponent:zoneControlImageFloderName];
    
    // 如果文件夹不存在就创建，否则继承
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathWithFolder]) {
        
        // 创建一个
        [[NSFileManager defaultManager] createDirectoryAtPath:pathWithFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 获得图片名称
    NSString *pathWithFolderAndName = [NSString stringWithFormat:@"%@/%@",pathWithFolder, iconName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathWithFolderAndName])
    {
        // 直接写入
        [UIImagePNGRepresentation(image) writeToFile: pathWithFolderAndName  atomically:YES];
        
    } else {
        //  如果有了，先删除
        [[NSFileManager defaultManager] removeItemAtPath:pathWithFolderAndName error:nil];
        
        [UIImagePNGRepresentation(image) writeToFile: pathWithFolderAndName    atomically:YES];
    }
}

/// 获得zoneControl对应的图片
+ (UIImage *)getZoneControlImageForZones:(NSString *)iconName {
    
    // 获得图片文件夹的内容
    NSString *pathWithFolder = [[FileTools documentPath] stringByAppendingPathComponent:zoneControlImageFloderName];
    
    // 如果文件夹不存在就创建，否则继承
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathWithFolder]) {
        
        // 创建一个
        [[NSFileManager defaultManager] createDirectoryAtPath:pathWithFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 获得图片名称
    NSString *pathWithFolderAndName = [NSString stringWithFormat:@"%@/%@",pathWithFolder, iconName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathWithFolderAndName]) {
    
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:pathWithFolderAndName]];
    }
    
    return nil;
}

/**
 删除zoneControl对应的图片
 */
+ (BOOL)deleteZoneControlImageForZones:(NSString *)iconName {

    // 获得图片文件夹的内容
    NSString *pathWithFolder = [[FileTools documentPath] stringByAppendingPathComponent:zoneControlImageFloderName];
    
    // 如果文件夹不存在就创建，否则继承
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathWithFolder]) {
        
        // 创建一个
        [[NSFileManager defaultManager] createDirectoryAtPath:pathWithFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 获得图片名称
    NSString *pathWithFolderAndName = [NSString stringWithFormat:@"%@/%@",pathWithFolder, iconName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathWithFolderAndName]) {
        
        // 删除图片
        return [[NSFileManager defaultManager] removeItemAtPath:pathWithFolderAndName error:nil];
    }
    
    return NO;
}

@end
