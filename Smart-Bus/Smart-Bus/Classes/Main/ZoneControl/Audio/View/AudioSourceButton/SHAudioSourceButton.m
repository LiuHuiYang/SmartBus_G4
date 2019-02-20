//
//  SHAudioSourceButton.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/17.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHAudioSourceButton.h"

@implementation SHAudioSourceButton


// MARK: - 界面初始化

/// 重新布局子控件
- (void)layoutSubviews {
    
    [super layoutSubviews];
   
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.imageView.frame_width = MIN(self.frame_height, self.frame_width) * 0.7;
    self.imageView.frame_x = (self.frame_width - self.imageView.frame_width) * 0.5;
    self.imageView.frame_y = 0;
    
    self.imageView.frame_height = self.imageView.frame_width;
    
    self.titleLabel.frame_width = self.frame_width;
    self.titleLabel.frame_x = 0;
    self.titleLabel.frame_y = self.imageView.frame_height +
        self.imageView.frame_y;
    self.titleLabel.frame_height = (self.frame_height - self.imageView.frame_height - self.imageView.frame_y) ;
    
    self.titleLabel.preferredMaxLayoutWidth =
        self.titleLabel.frame_width;
    
}

- (void)setHighlighted:(BOOL)highlighted {}

+ (instancetype)audioButtonWithType:(Byte)audioSourceType
                              title:(NSString *)title
                    normalImageName:(NSString *)normalImageName
                    selectImageName:(NSString *)selectImageName
                          addTarget:(id)target
                             action:(SEL)action {
    
    SHAudioSourceButton *sourceButton = [[self alloc] init];
    
    sourceButton.sourceType = audioSourceType;
    
    // 设置文字
    [sourceButton setTitle:title
                  forState:UIControlStateNormal];
    
    [sourceButton setTitleColor:[UIView highlightedTextColor]
                       forState:UIControlStateSelected];
    
    [sourceButton setTitleColor:[UIView textWhiteColor]
                       forState:UIControlStateNormal];
    
    sourceButton.titleLabel.font = ([UIDevice is_iPad] ? [UIView suitFontForPad] : [UIFont boldSystemFontOfSize:12]);
    
    sourceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    sourceButton.titleLabel.numberOfLines = 0;
    
    // 设置图片
    [sourceButton setImage:[UIImage imageNamed:normalImageName]
                  forState:UIControlStateNormal];
    [sourceButton setImage:[UIImage imageNamed:selectImageName]
                  forState:UIControlStateSelected];
    
    // 增加响应
    [sourceButton addTarget:target
                     action:action
           forControlEvents:UIControlEventTouchUpInside];
    
    [sourceButton sizeToFit];
    
    return sourceButton ;
}


@end
