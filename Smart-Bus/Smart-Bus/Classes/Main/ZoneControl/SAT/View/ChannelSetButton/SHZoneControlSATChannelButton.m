//
//  SHZoneControlSATChannelButton.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/27.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHZoneControlSATChannelButton.h"

@implementation SHZoneControlSATChannelButton

/// 设置界面
- (void)setUi {
    
    self.titleLabel.font = [UIDevice is_iPad] ? [UIView suitFontForPad] : [UIFont systemFontOfSize:12];
    
    self.titleLabel.numberOfLines = 0;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self setBackgroundImage:[UIImage resizeImage:@"mediabackground"] forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUi];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setUi];
}

@end
