//
//  SHSchdualContolZoneCell.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSchdualContolZoneCell : UITableViewCell


/// 区域
@property (strong, nonatomic) SHZone *zone;

/// 行高
+ (CGFloat)rowHeightForSchdualContolZoneCell;

@end
