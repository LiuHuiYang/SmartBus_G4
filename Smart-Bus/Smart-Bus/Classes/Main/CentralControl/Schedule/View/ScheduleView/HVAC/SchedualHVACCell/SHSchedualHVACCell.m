//
//  SHSchedualHVACCell.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSchedualHVACCell.h"
#import "SHSchedualHVACViewController.h"

@interface SHSchedualHVACCell ()

/// 按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hvacButtonHeightConstraint;

/// 标示的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagViewWidthConstraint;

/// 标示的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagViewHeightConstraint;

/// 开启按钮
@property (weak, nonatomic) IBOutlet UIButton *enableButton;

/// 需要配置的空调
@property (weak, nonatomic) IBOutlet UIButton *schedualHVACButton;

/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation SHSchedualHVACCell
    
/// 点击相关的空调
- (IBAction)schedualHVACButtonClick {

    SHSchedualHVACViewController *schedualController = [[SHSchedualHVACViewController alloc] init];
    
    schedualController.schedualHVAC = self.schedualHVAC;
    
    SHNavigationController *schedualNavigationController = [[SHNavigationController alloc] initWithRootViewController:schedualController];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:schedualNavigationController animated:YES completion:nil];
}
    
/// 开启计划
- (IBAction)enableButtonClick {
    
    self.enableButton.selected = !self.enableButton.selected;
    self.schedualHVAC.schedualEnable = self.enableButton.selected;
}
    
/// 设置空调
- (void)setSchedualHVAC:(SHHVAC *)schedualHVAC {

    _schedualHVAC = schedualHVAC;
    
    [self.schedualHVACButton setTitle:[NSString stringWithFormat:
                                       @"%@: %d - %d",
                                       schedualHVAC.acRemark,
                                       schedualHVAC.subnetID,
                                       schedualHVAC.deviceID]
                              forState:UIControlStateNormal];
    
    self.enableButton.selected = schedualHVAC.schedualEnable;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.iconView setRoundedRectangleBorder];
    
    if ([UIDevice is_iPad]) {
        
        self.schedualHVACButton.titleLabel.font = [UIView suitFontForPad];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.hvacButtonHeightConstraint.constant = navigationBarHeight;
        self.flagViewWidthConstraint.constant = tabBarHeight;
        self.flagViewHeightConstraint.constant = tabBarHeight;
    }
}


/// 行高
+ (CGFloat)rowHeightForSchedualHVACCell {

    if ([UIDevice is_iPad]) {
        
        return navigationBarHeight + statusBarHeight;
    
    } else if ([UIDevice is4_0inch] || [UIDevice is3_5inch]) {
    
        return tabBarHeight;
        
    }
    
    return navigationBarHeight;
}
    
@end
