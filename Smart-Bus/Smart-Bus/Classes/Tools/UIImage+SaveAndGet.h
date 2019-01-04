//
//  UIImage+SaveAndGet.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/9.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SaveAndGet)

 
/**
 将区域控制图片数据写入到沙盒中去
 */
+ (void)writeZoneControlImageToDocment:(NSString *)iconName data:(UIImage *)image;

/// 区域图片的文件夹路径
+ (NSString *)zoneControlImageFloderPath;

/**
 获得zoneControl对应的图片
 */
+ (UIImage *)getZoneControlImageForZones:(NSString *)iconName;


/**
 删除zoneControl对应的图片
 */
+ (BOOL)deleteZoneControlImageForZones:(NSString *)iconName;


@end
