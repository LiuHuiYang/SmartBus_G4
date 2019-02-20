

#import <UIKit/UIKit.h>

@interface UIDevice (DeviceType)

// MARK: - 语言环境

/// 是否为中文环境
+ (BOOL)isChinese;

/**
 获得当前计算机中的设置语言

 @return 当前的语言环境
 */
+ (NSString*)getPreferredLanguage;

// MARK: - 屏幕大小

/// 3.5屏幕大小
+ (BOOL)is3_5inch;

/// 4.0屏幕大小
+ (BOOL)is4_0inch;

/// 4.7 屏幕大小
+ (BOOL)is4_7inch;

/// 5.5 屏幕大小
+ (BOOL)is5_5inch;


// MARK: - 设备类型

/**
 当前设备是iPhone
 
 @return YES - iPone
 */
+ (BOOL)is_iPhone;

/**
 当前设备是iPad

 @return YES - iPad
 */
+ (BOOL)is_iPad;

 

/// iPhone X 和 iPhone Xs / XR / Xs Max
+ (BOOL)is_iPhoneX_More;

@end
