//
//  SHLoadProgressView.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/27.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface SHLoadProgressView : UIView




//// 指定的控件上显示
+ (void)showLoadProgressViewIn:(UIView *)superView;

/// 显示值的变化(内容调用)
//- (void)progressValueChange;

SingletonInterface(LoadProgressView)

@end
