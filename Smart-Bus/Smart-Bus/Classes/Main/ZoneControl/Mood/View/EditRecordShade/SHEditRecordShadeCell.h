//
//  SHEditRecordShadeCell.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/25.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHEditRecordShadeStatusDelegate <NSObject>

@optional

/**
 设置当前窗帘的目标状态
 */
- (void)editShade:(SHShade *)shade currentStatus:(NSString *)status;

@end

@interface SHEditRecordShadeCell : UITableViewCell

/// 当前的窗帘
@property (strong, nonatomic) SHShade *shade;

/// 代理
@property (nonatomic, weak) id<SHEditRecordShadeStatusDelegate> delegate;

/// 行高
+ (CGFloat)rowHeight;

@end
