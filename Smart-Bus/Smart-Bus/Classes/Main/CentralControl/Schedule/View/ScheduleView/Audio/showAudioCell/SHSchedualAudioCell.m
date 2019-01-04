//
//  SHSchedualAudioCell.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSchedualAudioCell.h"
#import "SHSchedualAudioViewController.h"

@interface SHSchedualAudioCell ()

/// 小图片高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagViewHeightConstraint;

/// 小图片宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagViewWidthConstraint;


/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
    
/// 开启按钮
@property (weak, nonatomic) IBOutlet UIButton *enableButton;

/// 需要配置的音乐
@property (weak, nonatomic) IBOutlet UIButton *schedualAudioButton;

@end

@implementation SHSchedualAudioCell

/// 点击相关的音乐
- (IBAction)schedualAudioButtonClick {
    
    SHSchedualAudioViewController *schedualController = [[SHSchedualAudioViewController alloc] init];
    
    schedualController.schedualAudio = self.schedualAudio;
    
    SHNavigationController *schedualNavigationController = [[SHNavigationController alloc] initWithRootViewController:schedualController];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:schedualNavigationController animated:YES completion:nil];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.flagViewWidthConstraint.constant = tabBarHeight;
        self.flagViewHeightConstraint.constant = tabBarHeight;
    }
}
    
/// 开启计划
- (IBAction)enableButtonClick {
    
    self.enableButton.selected = !self.enableButton.selected;
    self.schedualAudio.schedualEnable = self.enableButton.selected;
}
    
    /// 设置Audio
- (void)setSchedualAudio:(SHAudio *)schedualAudio {
    
    _schedualAudio = schedualAudio;
    
    [self.schedualAudioButton setTitle:[NSString stringWithFormat:@"%@: %d - %d", @"Audio", schedualAudio.subnetID, schedualAudio.deviceID] forState:UIControlStateNormal];
    
    self.enableButton.selected = schedualAudio.schedualEnable;
}

    
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.iconView setRoundedRectangleBorder];
    
    if ([UIDevice is_iPad]) {
        
        self.schedualAudioButton.titleLabel.font = [UIView suitFontForPad];
    }
}


/// 行高
+ (CGFloat)rowHeightForSchedualAudioCell {
    
    if ([UIDevice is_iPad]) {
        
        return navigationBarHeight + statusBarHeight;
        
    } else if ([UIDevice is4_0inch] || [UIDevice is3_5inch]) {
        
        return tabBarHeight;
        
    }
    
    return navigationBarHeight;
}

@end
