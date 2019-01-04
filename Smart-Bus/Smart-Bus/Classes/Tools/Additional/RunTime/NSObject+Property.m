//
//  NSObject+Property.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h> // 导入运行时文件

@implementation NSObject (Property)

/**
 获得指定的类的所有的属性

 @return 属性名称
 */
+ (NSArray *)getProperties {

    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        [mArray addObject:name];
    }
    
    return mArray.copy;
    
}

@end
