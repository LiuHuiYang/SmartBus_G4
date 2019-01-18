//
//  SHLanguageTools.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/6.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHLanguageTools : NSObject

/// 当前使用的语言文件字典
@property (nonatomic, strong) NSMutableDictionary* currentLanguagePlistDictionary;

/// 获得具体的字段名称(可能是字段)
- (id)getTextFromPlist:(NSString *)mainTitle withSubTitle:(NSString *)subTitle;

/// 设置应用使用的语言
- (void)setLanguage;

/// 获得所有的语言名称
- (NSArray *)getAllLanguages;

/// 拷贝语言文件
- (void)copyLanguagePlist;


/**
 语言适配类方法

 @param key 语言适配的字段
 @param comment 文字的描述解释信息
 @return 匹配语言的字符串
 */
+ (NSString *)languageAdaptation:(NSString *)key comment:(NSString *)comment;

/// 用户选择为中文
+ (BOOL)isChinese;

SingletonInterface(LanguageTools);

@end
