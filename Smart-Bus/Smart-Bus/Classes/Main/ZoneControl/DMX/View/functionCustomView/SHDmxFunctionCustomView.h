//
//  SHDmxFunctionCustomView.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/10.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHDmxFunctionCustomView : UIView

@property (copy, nonatomic) NSString *sceneName;

/// 实例化
+ (instancetype)dmxFunctionCustomView;

/// 高度
+ (CGFloat)rowHeight;

@end
