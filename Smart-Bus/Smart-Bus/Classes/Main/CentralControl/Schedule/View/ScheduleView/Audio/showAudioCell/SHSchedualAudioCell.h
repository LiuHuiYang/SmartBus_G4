//
//  SHSchedualAudioCell.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSchedualAudioCell : UITableViewCell

    
/// 音乐
@property (assign, nonatomic) SHAudio *schedualAudio;
    
/// 行高
+ (CGFloat)rowHeightForSchedualAudioCell;
    
@end
