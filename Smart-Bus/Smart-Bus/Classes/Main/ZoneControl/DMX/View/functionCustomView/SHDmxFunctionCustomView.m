//
//  SHDmxFunctionCustomView.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/10.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHDmxFunctionCustomView.h"

@interface SHDmxFunctionCustomView ()

/// 显示文字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SHDmxFunctionCustomView

- (void)setSceneName:(NSString *)sceneName {
    
    _sceneName = sceneName;
    
    self.nameLabel.text = sceneName;
    
    // 这两句话是为了匹配 iPAD
    self.frame_width = self.superview.frame_width;
    self.frame_height = [SHDmxFunctionCustomView rowHeight];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //    self.iconView.image = [UIImage resizeImage:@"pickerViewbackground"];
    
    if ([UIDevice is_iPad]) {
        
        self.nameLabel.font = [UIView suitLargerFontForPad];
    }
}

/// 高度
+ (CGFloat)rowHeight{
    
    if ([UIDevice is_iPad]) {
        
        return navigationBarHeight + tabBarHeight;
    }
    
    return navigationBarHeight + statusBarHeight;
}

+ (instancetype)dmxFunctionCustomView {
    
     return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

@end
