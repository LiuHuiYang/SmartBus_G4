 

#import "UIDevice+DeviceType.h"

@implementation UIDevice (DeviceType)

// MARK: - 语言环境

/// 是否为中文环境
+ (BOOL)isChinese {
    
    return [[self getPreferredLanguage] hasPrefix:@"zh"];
}

/**
 获得当前计算机中的设置语言
 
 @return 当前的语言环境
 */
+ (NSString*)getPreferredLanguage {
    
    //  方式一 会拼接上国家或地区的代码
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
//    
//    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
//    NSLog(@"当前语言:%@ - %@", preferredLang, allLanguages);
    
    // 方式二 会拼接上国家或地区的代码
//    NSString *pfLanguageCode = [NSLocale preferredLanguages][0];
    
    // 方式三
    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    
    return localeLanguageCode;
}

// MARK: - 屏幕大小

/// 3.5屏幕大小
+ (BOOL)is3_5inch {

    return ([UIScreen mainScreen].bounds.size.height == 480.0);
}

/// 4.0屏幕大小
+ (BOOL)is4_0inch {

    return ([UIScreen mainScreen].bounds.size.height == 568.0);
}

/// 4.7 屏幕大小
+ (BOOL)is4_7inch {

    return ([UIScreen mainScreen].bounds.size.height == 667.0);
}

/// 5.5 屏幕大小
+ (BOOL)is5_5inch {

    return ([UIScreen mainScreen].bounds.size.height == 736.0);
}

/// 5.8 屏幕大小
+ (BOOL)is5_8inch {
    
    return CGSizeEqualToSize(([[[UIScreen mainScreen] currentMode] size]),
                             CGSizeMake(1125, 2436));
}

/// iPhone X 和 iPhone Xs / XR / Xs Max
+ (BOOL)is_iPhoneX_More {
    
    // iPhoneX/Xs 5.8 inch
    
    // iPhone Xr 6.1 / iPhone Xs Max 6.5
    
    BOOL iPhonsX_Xs = CGSizeEqualToSize(
        [UIScreen mainScreen].bounds.size, CGSizeMake(375, 812));
    
    BOOL iPhonsXr_XsMax = CGSizeEqualToSize(
        [UIScreen mainScreen].bounds.size, CGSizeMake(414, 896));
    
    return iPhonsX_Xs || iPhonsXr_XsMax;
    
    
}

/**
 当前设备是iPhone
 
 @return YES - iPone
 */
+ (BOOL)is_iPhone {
    
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

/**
 当前设备是iPad
 
 @return YES - iPad
 */
+ (BOOL)is_iPad {
    
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}


                              
@end
