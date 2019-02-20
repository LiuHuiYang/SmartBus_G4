//
//  UIColor+Hex.h
 

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 生成指定透明度的【随机颜色】
 
 @param alpha 透明度 【0 ～ 1】
 @return UIColor *
 */
+ (UIColor *)randomColor:(CGFloat)alpha;


/**
 通过 【32位 的hex值】设置 UIColor*
 
 @param colorHex 颜色的hex表示 (需要去掉 # 直接填入, 传入的整数非字符串)
 @param alpha 透明度 【0 ～ 1】
 @return UIColor *
 */
+ (UIColor *)colorWithHex:(u_int32_t)colorHex alpha:(CGFloat)alpha;


/**
 通过 【32位 的颜色 字符串】 设置 UIColor *
 
 @param color 十六进制颜色字符串(支持 @“#123456”、 @“0X123456”、 @“123456”三种格式， 传入的是字符串)
 @param alpha 透明度 【0 ～ 1】
 @return UIColor *
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 通过颜色字符串 设置 UIColor 【没有透明度，默认是1.0】
 
 @param hexString 颜色字符串 以【#】开头 支持【#RGB / #ARGB / #RRGGBB / #AARRGGBB】
 @return 颜色字符串
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;


/**
 颜色的字符串表示
 
 @return 颜色的十六进制字符串表示
 */
- (NSString *)colorHexString;

@end
