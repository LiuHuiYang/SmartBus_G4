//
//  SHSchdualContolZoneCell.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchdualContolZoneCell.h"


@interface SHSchdualContolZoneCell ()

/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/// 名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SHSchdualContolZoneCell

- (void)setZone:(SHZone *)zone {

    _zone = zone;
    
    self.nameLabel.text = zone.zoneName;
}

- (void)setFrame:(CGRect)frame {

    frame.size.height -= 5;
    
    [super setFrame:frame];
}


- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconView.image = [UIImage resizeImage:@"buttonbackground"];
    
    if ([UIDevice is_iPad]) {
        
        self.nameLabel.font = [UIView suitFontForPad];
    }
    
}

/// 行高
+ (CGFloat)rowHeightForSchdualContolZoneCell {
    
    if ([UIDevice is_iPad]) {
        
        return navigationBarHeight + statusBarHeight;
    }
    
    return tabBarHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
