//
//  SHSchduleShadeCell.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/5.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchduleShadeCell.h"
#import "SHMoodShadeStatusButton.h"

@interface SHSchduleShadeCell ()


/// 窗帘名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 设置按钮
@property (weak, nonatomic) IBOutlet SHMoodShadeStatusButton *homeButton;

@end

@implementation SHSchduleShadeCell

/// 设置模型
- (void)setShade:(SHShade *)shade {

    _shade = shade;
    
    self.nameLabel.text = shade.shadeName;
    
    switch (shade.currentStatus) {
         
            // 忽略
        case SHShadeStatusUnKnow: {
         
            [self.homeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_BYPASS"] forState:UIControlStateNormal];
        }
            break;
            
            // 打开
        case SHShadeStatusOpen: {
            
            [self.homeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_OPEN"] forState:UIControlStateNormal];
        }
            break;
            
            // 关闭
        case SHShadeStatusClose: {
      
            [self.homeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_CLOSE"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

/// 设置按钮点击
- (IBAction)homeButtonClick {
    
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:nil message:nil isCustom:YES];
    
    // 打开
    [alertView addAction: [TYAlertAction actionWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_OPEN"] style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [self.homeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_OPEN"] forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(editShade:currentStatus:)]) {
            
            [self.delegate editShade:self.shade currentStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_OPEN"]];
        }
    }]];
    
    // 关闭
    [alertView addAction: [TYAlertAction actionWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_CLOSE"] style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [self.homeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_CLOSE"] forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(editShade:currentStatus:)]) {
            
            [self.delegate editShade:self.shade currentStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_CLOSE"]];
        }
        
    }]];
    
    // 忽略
    [alertView addAction: [TYAlertAction actionWithTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_BYPASS"] style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
        [self.homeButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_BYPASS"] forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(editShade:currentStatus:)]) {
            
            [self.delegate editShade:self.shade currentStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_BYPASS"]];
        }
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
    
    alertController.backgoundTapDismissEnable = YES;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    if ([UIDevice is_iPad]) {
        
        self.nameLabel.font = [UIView suitFontForPad];
        self.homeButton.titleLabel.font = [UIView suitFontForPad];
    }
}

/// cell的行高
+ (CGFloat)rowHeightForShadeCell {
    
    if ([UIDevice is_iPad]) {
        
        return navigationBarHeight + statusBarHeight;
        
    } else if ([UIDevice is4_0inch] || [UIDevice is3_5inch]) {
        
        return tabBarHeight;
        
    }
    
    return navigationBarHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
