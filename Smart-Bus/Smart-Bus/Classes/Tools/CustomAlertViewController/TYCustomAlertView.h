//
//  SHAlertView.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/1.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <TYAlertController/TYAlertController.h>

@interface TYCustomAlertView : TYAlertView


/**
 实例化定制

 @param title 标题
 @param message 详细信息
 @param isCustom 是否需要定制化
 @return 显示view
 */
+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message isCustom:(BOOL) isCustom;

@end
