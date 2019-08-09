//
//  SHViewController.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/5.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHSocketData;

@interface SHViewController : UIViewController

///  当前是否为竖屏
@property (nonatomic, assign) BOOL isPortrait;

/// 当前控制器成为焦点
- (void)becomeFocus;
 

/// 解析数据
- (void)analyzeReceivedSocketData:(SHSocketData *)socketData;

@end
