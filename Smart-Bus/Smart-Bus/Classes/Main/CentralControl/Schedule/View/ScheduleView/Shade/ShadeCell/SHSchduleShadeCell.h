//
//  SHSchduleShadeCell.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/5.
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

@interface SHSchduleShadeCell : UITableViewCell

/// 窗帘
@property (strong, nonatomic) SHShade *shade;

/// 代理
@property (nonatomic, weak) id<SHEditRecordShadeStatusDelegate> delegate;


/// cell的行高
+ (CGFloat)rowHeight;

@end
