//
//  SHAuioPlayTypeButton.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/17.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHAuioPlayTypeButton.h"

@implementation SHAuioPlayTypeButton

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    
    return self;
}

- (void)awakeFromNib {
 
    [super awakeFromNib];
    
    [self setUI];
}

- (void)setUI {

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.imageView.frame_width = MIN(self.frame_width, self.frame_height);
    self.imageView.frame_height = self.frame_width;
    
    self.imageView.frame_x =
        (self.frame_width - self.imageView.frame_width) * 0.5;
    
    self.imageView.frame_y =
        (self.frame_height - self.imageView.frame_height) * 0.5;
}

@end
