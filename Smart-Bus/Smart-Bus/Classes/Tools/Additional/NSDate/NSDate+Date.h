//
//  NSDate+Date.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/30.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Date)

/**
 *  判断当前时间是否处于某个时间段内(只看时间和分钟)
 *
 *  @param startTime        开始时间  // @"yyyy-MM-dd'T'HH:mm"
 *  @param expireTime       结束时间
 */
+ (BOOL)validateStartTime:(NSString *)startTime expireTime:(NSString *)expireTime;

/**
 获得当前的时间属性
 */
+ (NSDateComponents *)getCurrentDateComponents;


/**
 获得指定【NSDate字符串】的时间属性
 
 @param dateFormatString 日期格式字符串
 @param dateString 日期字符串
 @return 日期属性
 */
+ (NSDateComponents *)getDateComponentsForDateFormatString:(NSString *)dateFormatString byDateString:(NSString *)dateString;

 
/**
 获得指定【NSDate】的时间属性

 @param date 指定时间
 @return 时间属性
 */
+ (NSDateComponents *)getCurrentDateComponentsFrom:(NSDate *)date;


/**
 计算两个【NSDate】的差值NSDateComponents对象
 
 @param fromDate 开始时间
 @param toDate 结束时间
 @return 日历对象，按属性取值就可以了
 */
+ (NSDateComponents *)getTimeDiferenceFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 计算两个【NSDateComponents】的差值NSDateComponents对象
 
 @param fromComponent 开始时间
 @param toComponent 结束时间
 @return NSDateComponents对象
 */
+ (NSDateComponents *)getTimeDiferenceFormComponent:(NSDateComponents *)fromComponent toComponent:(NSDateComponents *)toComponent;

@end
