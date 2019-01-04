//
//  UIView+CustomSetting.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/20.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomSetting)


/// 白色字体
+ (UIColor *)textWhiteColor;

/// 文字的高亮颜色
+ (UIColor *)highlightedTextColor;

/// iPad的适配字体(加大)
+ (UIFont *)suitLargerFontForPad;

/// iPad的适配字体(普通)
+ (UIFont *)suitFontForPad;

/// 设置边框
- (void)setRoundedRectangleBorder;

@end
