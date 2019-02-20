//
//  NSObject+Property.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)



/**
 获得指定的类的所有的属性

 @return 属性名称
 */
+ (NSArray *)getProperties;

@end
