//
//  SHSchedualHVACCell.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSchedualHVACCell : UITableViewCell

/// 空调
@property (assign, nonatomic) SHHVAC *schedualHVAC;

    /// 行高
+ (CGFloat)rowHeightForSchedualHVACCell;
    
@end
