//
//  UIColor+Hex.m
 

#import "UIColor+Hex.h"


/**
 获得单个字符串的颜色

 @param string 颜色字符串
 @param start 开始序号
 @param length 字符串长度
 @return iOS上的颜色值(0 ~ 1)
 */
CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
}

@implementation UIColor (Hex)


/**
 颜色的字符串表示

 @return 颜色的十六进制字符串表示
 */
- (NSString *)colorHexString {
    
    UIColor* color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%02X%02X%02X", (Byte)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (Byte)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (Byte)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

/**
 通过颜色字符串 设置 UIColor
 
 @param hexString 颜色字符串 以【#】开头
 @return 颜色字符串
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    CGFloat alpha = 0, red = 0, blue = 0, green = 0;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    
    switch ([colorString length]) {
            
        case 3: { // #RGB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 1);
            green = colorComponentFrom(colorString, 1, 1);
            blue  = colorComponentFrom(colorString, 2, 1);
        }
            break;
            
        case 4: { // #ARGB
            alpha = colorComponentFrom(colorString, 0, 1);
            red   = colorComponentFrom(colorString, 1, 1);
            green = colorComponentFrom(colorString, 2, 1);
            blue  = colorComponentFrom(colorString, 3, 1);
        }
            break;
            
        case 6: { // #RRGGBB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 2);
            green = colorComponentFrom(colorString, 2, 2);
            blue  = colorComponentFrom(colorString, 4, 2);
        }
            break;
            
        case 8: { // #AARRGGBB
            alpha = colorComponentFrom(colorString, 0, 2);
            red   = colorComponentFrom(colorString, 2, 2);
            green = colorComponentFrom(colorString, 4, 2);
            blue  = colorComponentFrom(colorString, 6, 2);
        }
            break;
            
        default:
            return nil;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/**
 通过 【32位的颜色字符串】 设置 UIColor *

 @param color 十六进制颜色字符串
 @param alpha 透明度
 @return UIColor *
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    
    //删除字符串中的空格
    NSString *colorString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([colorString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    
    if ([colorString hasPrefix:@"0X"] || [colorString hasPrefix:@"0x"]) {
        colorString = [colorString substringFromIndex:2];
    }
    
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    if ([colorString length] != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [colorString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [colorString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [colorString substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:rString] scanHexInt:&red];
    [[NSScanner scannerWithString:gString] scanHexInt:&green];
    [[NSScanner scannerWithString:bString] scanHexInt:&blue];
    
    // 返回颜色
    return [UIColor colorWithRed:((CGFloat)red / 255.0f) green:((CGFloat)green / 255.0f) blue:((CGFloat)blue / 255.0f) alpha:alpha];
}

/**
 通过【32位的hex值】设置 UIColor*
 
 @param colorHex 颜色的hex表示 (去掉#直接填入)
 @param alpha 透明度
 @return UIColor *
 */
+ (UIColor *)colorWithHex:(u_int32_t)colorHex alpha:(CGFloat)alpha {
    
    //  255 255 255 ==  #0x ff ff ff
    // 获得各种颜色
    NSUInteger red = (colorHex & 0xFF0000) >> 16;
    NSUInteger green = (colorHex & 0x00FF00) >> 8;
    NSUInteger blue = colorHex & 0x0000FF;
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}



/**
 生成指定透明度的【随机颜色】

 @param alpha 透明度
 @return UIColor *
 */
+ (UIColor *)randomColor:(CGFloat)alpha {
    
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:alpha];
}



@end
