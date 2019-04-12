
//  UIButton+init.m

#import "UIButton+init.h"

@implementation UIButton (init)


/**
 实例化按钮
 
 @param imageName 常态图片名称
 @param hightlightedImageName 点击下的图片名称
 @param backgroundImageName 常态背景图片图称
 @param highlightedBackgroundImageName 高亮背景图片名称
 @param target 响应者
 @param action 响应事件
 @return 按钮
 */
+ (instancetype)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)hightlightedImageName backgroundImageName:(NSString *)backgroundImageName highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName addTarget:(id)target action:(SEL)action {

    UIButton *button  = [[self alloc] init];
    
    
    
    if (imageName) {
        
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (hightlightedImageName) {
        
        [button setImage:[UIImage imageNamed:hightlightedImageName] forState:UIControlStateHighlighted];
    }
    
    if (backgroundImageName) {
        
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    }
    
    if (highlightedBackgroundImageName) {
        
        [button setBackgroundImage:[UIImage imageNamed:highlightedBackgroundImageName] forState:UIControlStateHighlighted];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button sizeToFit];
    
    return button;
}



/**
 实例化按钮(如果不需要点击事件 参数使用 nil)

 @param title 标题
 @param font 字体
 @param normalTextColor 常状态颜色
 @param highlightedTextColor 高亮文字颜色
 @param imageName 图片
 @param backgroundImageName 背景图片
 @param target 响应者
 @param action 响应事件
 @return 按钮
 */
+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font normalTextColor:(UIColor *)normalTextColor highlightedTextColor:(UIColor *)highlightedTextColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName addTarget:(id)target action:(SEL)action {
    
     // 设置图片
    UIButton *button  = [[self alloc] init];
    
    if (imageName) {
        
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
   
    if (backgroundImageName) {
        
          [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    }
    
    // 设置标题
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    // 设置标题颜色
    [button setTitleColor:normalTextColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
    [button setTitleColor:highlightedTextColor forState:UIControlStateSelected];
    
    // 事件处理
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button sizeToFit];  
    
    return button;
}


/**
 实例化按钮(如果不需要点击事件 参数使用 nil)

 @param title 标题
 @param imageName 常态图片名称
 @param selectedImageName 选中状态下的下的图片名称
 @param target 点击响应者
 @param action 响应事件
 @return 按钮
 */
+ (instancetype)buttonWithTitle:(NSString *)title backgroundImageName:(NSString *)imageName selectedBackgroundImageName:(NSString *)selectedImageName addTarget:(id)target action:(SEL)action {

    
    UIButton *button  = [[self alloc] init];

    if (imageName) {
         [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
   
    if (selectedImageName) {
        [button setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }

    // 设置标题
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.textColor = [UIView textWhiteColor];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button sizeToFit];
    
    return button;
}

@end
