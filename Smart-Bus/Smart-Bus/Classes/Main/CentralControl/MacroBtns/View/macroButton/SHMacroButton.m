//
//  SHMacroButton.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/12.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHMacroButton.h"

@implementation SHMacroButton


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
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIView highlightedTextColor]forState:UIControlStateSelected];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    
    if ([UIDevice is_iPad]) {
        
        self.titleLabel.font = [UIView suitFontForPad];
    }
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat imageViewBaseSize = MIN(self.frame_width, self.frame_height);
    
    self.imageView.frame_width = (imageViewBaseSize == self.frame_width) ? (self.frame_width * 0.3) : (self.frame_height  * 0.55);
    
    self.imageView.frame_height = self.imageView.frame_width;
    
    self.imageView.frame_x = (self.frame_width - self.imageView.frame_width) * 0.5;
    
    self.imageView.frame_y = self.imageView.frame_height * 0.1;
    
    // 文字部分
    self.titleLabel.frame_x = 0;
    self.titleLabel.frame_y = CGRectGetMaxY(self.imageView.frame);
    
    self.titleLabel.frame_width = self.frame_width;
    self.titleLabel.frame_height = self.frame_height - self.imageView.frame_height - self.imageView.frame_y;
}

- (void)setHighlighted:(BOOL)highlighted {}


@end
