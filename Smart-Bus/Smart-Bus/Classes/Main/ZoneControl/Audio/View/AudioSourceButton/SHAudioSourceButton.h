//
//  SHAudioSourceButton.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/17.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHAudioSourceButton : UIButton

/// 设备类型
@property (assign, nonatomic) SHAudioSourceType sourceType;

/// 实例化按钮
+ (instancetype)audioButtonWithType:(Byte)audioSourceType
                              title:(NSString *)title
                    normalImageName:(NSString *)normalImageName
                    selectImageName:(NSString *)selectImageName
                          addTarget:(id)target
                             action:(SEL)action;

@end
