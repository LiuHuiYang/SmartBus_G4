//
//  SHSchdualContolItemCell.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSchdualContolItemCell : UITableViewCell

/// 控制名称
@property (copy, nonatomic) NSString *controlItemName;

/// 行高
+ (CGFloat)rowHeightForSchdualContolItemCell;

@end
