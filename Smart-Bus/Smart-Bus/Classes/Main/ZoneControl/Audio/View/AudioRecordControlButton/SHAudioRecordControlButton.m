//
//  SHAudioRecoredControlButton.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/16.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHAudioRecordControlButton.h"

@implementation SHAudioRecordControlButton

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

- (void)setUi {

    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
}

 

@end
