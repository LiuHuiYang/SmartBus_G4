//
//  SHSchdualContolItemCell.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchdualContolItemCell.h"

@interface SHSchdualContolItemCell ()

/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/// 控制项
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SHSchdualContolItemCell

- (void)setControlItemName:(NSString *)controlItemName {

    _controlItemName = controlItemName.copy;
    
    self.nameLabel.text = controlItemName;
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 5;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconView.image = [UIImage resizeImage:@"buttonbackground"];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([UIDevice is_iPad]) {
        
        self.nameLabel.font = [UIView suitFontForPad];
    }
}

/// 行高
+ (CGFloat)rowHeightForSchdualContolItemCell {
  
    if ([UIDevice is_iPad]) {
        
        return tabBarHeight + tabBarHeight;
        
    } else if ([UIDevice is3_5inch] || [UIDevice is4_0inch]) {
        
        return tabBarHeight;
    }
    
    return navigationBarHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
