//
//  SHLanguageTools.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/6.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHLanguageTools.h"

@implementation SHLanguageTools

/// 获得具体的字段名称
- (id)getTextFromPlist:(NSString *)mainTitle withSubTitle:(NSString *)subTitle {
    
    return [[self.currentLanguagePlistDictionary objectForKey:mainTitle] objectForKey:subTitle];
}

/// 设置应用使用的语言
- (void)setLanguage {
    
    // 从沙盒中获取到相应的语言类型
    NSString *languageType = [[NSUserDefaults standardUserDefaults] objectForKey:@"LAGUAGEZ_NAME"];
    
    // 获得语言的文件名称
    NSString *languagePlistName = @"";
    
    if ([languageType isEqualToString:@""] || languageType.length <= 0) {
        // 没有先择，默认使用英语
        [[NSUserDefaults standardUserDefaults] setObject:@"English" forKey:@"LAGUAGEZ_NAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        languagePlistName = @"English.plist";
        
    } else {
        
        languagePlistName = [NSString stringWithFormat:@"%@.plist", languageType];
    }
    
    // 获取在沙盒中的语言文件
    NSString *languagePlistForDocument  = [[FileTools documentPath] stringByAppendingPathComponent:languagePlistName];
    
    self.currentLanguagePlistDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:languagePlistForDocument];
}

/// 获得所有的语言名称(没有.plist)
- (NSArray *)getAllLanguages {
    
    NSMutableArray *allPlistNames = [NSMutableArray array];
    
    // 找到沙盒路径
    NSArray *destLanguagePlists = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[FileTools documentPath] error:nil];
    
    for (NSUInteger i = 0; i < destLanguagePlists.count; i++) {
        
        // 获得文件名称
        NSString *languagePlistName = destLanguagePlists[i];
        
        if ([languagePlistName hasSuffix:@".plist"] &&
            ![languagePlistName isEqualToString:allDeviceMacAddressListPath]) {
            [allPlistNames addObject:[languagePlistName stringByDeletingPathExtension]];
        }
    }
   
    return allPlistNames.copy;
}

/// 拷贝语言文件
- (void)copyLanguagePlist {
    
    // 目标路径 
    NSError *error =  nil;
    
    NSArray *languagesDocumentArray =
        [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[FileTools documentPath]
                                                            error:&error
        ];
    
    if (error) {
        return;
    }
    
    // 获取语言资源路径
    NSString *languageSourcePath =
        [[[NSBundle mainBundle] resourcePath]
            stringByAppendingPathComponent:@"Languages"];
    
    NSArray *languagesInBundle =
        [[NSFileManager defaultManager]
            contentsOfDirectoryAtPath:languageSourcePath
                                error:&error
        ];
    
    // 已经拷贝过了就不需要再操作了
    if (languagesInBundle.count == languagesDocumentArray.count) {
        
        return;
    }
    
    // 拷贝文件
    for (NSUInteger i = 0; i < languagesInBundle.count; i++) {
        
        // 获取每种语言的种类
        NSString *languagePlist = languagesInBundle[i];
        
        // 获得语言文件的源路径
        NSString *languagePlistSourcePath = [languageSourcePath stringByAppendingPathComponent:languagePlist];
        
        // 目标语言文件的目标路径
        NSString *languagePlistDestPath = [[FileTools documentPath]
            stringByAppendingPathComponent:languagePlist];
        
        // 如果存在先删除
        if ([languagesDocumentArray containsObject:languagePlist]) {
           
            [[NSFileManager defaultManager]
                removeItemAtPath:languagePlistDestPath
                           error:&error];
        }
        
        // 拷贝到沙盒中
        [[NSFileManager defaultManager]
            copyItemAtPath:languagePlistSourcePath
                    toPath:languagePlistDestPath
                     error:&error
        ];
    }
}

// 保证外界有值
- (NSMutableDictionary *)currentLanguagePlistDictionary {
    
    if (!_currentLanguagePlistDictionary) {
        _currentLanguagePlistDictionary = [NSMutableDictionary dictionary];
    }
    return _currentLanguagePlistDictionary;
}

/// 用户选择为中文
+ (BOOL)isChinese {
    
    return [([[NSUserDefaults standardUserDefaults]
              objectForKey:@"LAGUAGEZ_NAME"])
            isEqualToString:@"中文"];
}


/**
 语言适配类方法
 
 @param key 语言适配的字段
 @param comment 文字的描述解释信息
 @return 匹配语言的字符串
 */
+ (NSString *)languageAdaptation:(NSString *)key comment:(NSString *)comment {
    
    return NSLocalizedStringFromTable(key, @"languages", comment);
}


SingletonImplementation(LanguageTools);

@end
