//
//  SHEditRecordShadeCell.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/25.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHEditRecordShadeCell.h"
#import "SHMoodShadeStatusButton.h"

@interface SHEditRecordShadeCell ()

/// 高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusButtonHeightConstraint;

/// 窗帘名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 设置按钮
@property (weak, nonatomic) IBOutlet SHMoodShadeStatusButton *homeButton;


/// 状态选择列表
@property (nonatomic, weak) UIImageView *stausView;

@end

@implementation SHEditRecordShadeCell

/// 设置按钮点击
- (IBAction)homeButtonClick {
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:nil message:nil isCustom:YES];
    
    
    // 打开
    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.shadeOpen style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [self.homeButton setTitle:SHLanguageText.shadeOpen forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(editShade:currentStatus:)]) {
            
            [self.delegate editShade:self.shade currentStatus:SHLanguageText.shadeOpen];
        }
    }]];
    
    // 关闭
    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.shadeClose style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [self.homeButton setTitle:SHLanguageText.shadeClose forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(editShade:currentStatus:)]) {
            
            [self.delegate editShade:self.shade currentStatus:SHLanguageText.shadeClose];
        }
    }]];

    // 忽略
    [alertView addAction:[TYAlertAction actionWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_BYPASS"] style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
        [self.homeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_BYPASS"] forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(editShade:currentStatus:)]) {
            
            [self.delegate editShade:self.shade currentStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_BYPASS"]];
        }
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

/// 选择不同的状态
- (void)selectStatus:(UIButton *)button {

    [self.homeButton setTitle:button.currentTitle forState:UIControlStateNormal];
    self.stausView.hidden = YES;
}

- (void)setShade:(SHShade *)shade {

    _shade = shade;
    self.nameLabel.text = shade.shadeName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 设置默认文字
    [self.homeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_BYPASS"] forState:UIControlStateNormal];
    
    if ([UIDevice is_iPad]) {
        
        self.homeButton.titleLabel.font = [UIView suitFontForPad];
        self.nameLabel.font = [UIView suitFontForPad];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.statusButtonHeightConstraint.constant = navigationBarHeight + statusBarHeight;
    }
}

/// 行高
+ (CGFloat)rowHeight{
    
    if ([UIDevice is_iPad]) {
        
        return navigationBarHeight + tabBarHeight;
    }
    
    return navigationBarHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
