//
//  SHAudioSelectButton.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/17.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHAudioSelectButton.h"

@implementation SHAudioSelectButton

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
    self.adjustsImageWhenHighlighted = NO;

//    self.titleLabel.backgroundColor = [UIColor redColor];
//    self.imageView.backgroundColor = [UIColor greenColor];
//    self.backgroundColor = [UIColor orangeColor];
}

- (void)layoutSubviews {

    [super layoutSubviews];
     
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size;
    
    self.titleLabel.frame_width = titleSize.width;
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame_width;
    
    self.titleLabel.frame_x = (self.frame_width - self.titleLabel. frame_width) * 0.5;
    
    self.titleLabel.frame_y = 0;
    self.titleLabel.frame_height = self.frame_height;
    
    self.imageView.frame_x = self.titleLabel.frame_x + self.titleLabel.frame_width;
    
    self.imageView.frame_width = MIN(self.frame_width - self.imageView.frame_x, titleSize.height);
    
    self.imageView.frame_height = self.imageView.frame_width;
    
    self.imageView.frame_y = (self.frame_height - self.imageView.frame_height) * 0.5;
}

@end
