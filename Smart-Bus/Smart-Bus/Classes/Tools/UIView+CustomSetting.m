//
//  UIView+CustomSetting.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/20.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "UIView+CustomSetting.h"

@implementation UIView (CustomSetting)


/// 设置边框
- (void)setRoundedRectangleBorder {
    
    self.layer.borderColor= [UIColor colorWithHex:0xECECEC alpha:0.8].CGColor;
    self.layer.borderWidth = [UIDevice is_iPad] ? 3.0 : 1.0;
    self.layer.cornerRadius = ([UIDevice is_iPad]) ? statusBarHeight : statusBarHeight * 0.5;
}

/// 白色字体
+ (UIColor *)textWhiteColor {
    
    return [UIColor colorWithHex:0xfdfdfd alpha:1.0];
}

/// 文字的高亮颜色
+ (UIColor *)highlightedTextColor {
    
    return [UIColor colorWithHex:0xEF963B alpha:1.0];
}

/// iPad的适配字体(加大)
+ (UIFont *)suitLargerFontForPad {
    
    return [UIFont boldSystemFontOfSize:38];
}

/// iPad的适配字体(普通)
+ (UIFont *)suitFontForPad {
    
    return [UIFont boldSystemFontOfSize:26];
}

@end
