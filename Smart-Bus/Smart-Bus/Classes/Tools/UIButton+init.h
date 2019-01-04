
//  UIButton+init.h


#import <UIKit/UIKit.h>

@interface UIButton (init)

/**
 实例化按钮 (如果不需要点击事件 参数使用 nil)

 @param imageName 常态图片名称
 @param hightlightedImageName 点击下的图片名称
 @param backgroundImageName 常态背景图片图称
 @param highlightedBackgroundImageName 高亮背景图片名称
 @param target 响应者
 @param action 响应事件
 @return 按钮
 */
+ (instancetype)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)hightlightedImageName backgroundImageName:(NSString *)backgroundImageName highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName addTarget:(id)target action:(SEL)action;


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
+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font normalTextColor:(UIColor *)normalTextColor highlightedTextColor:(UIColor *)highlightedTextColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName addTarget:(id)target action:(SEL)action;



/**
 实例化按钮(如果不需要点击事件 参数使用 nil)
 
 @param title 标题
 @param imageName 常态图片名称
 @param selectedImageName 选中状态下的下的图片名称
 @param target 点击响应者
 @param action 响应事件
 @return 按钮
 */
+ (instancetype)buttonWithTitle:(NSString *)title backgroundImageName:(NSString *)imageName selectedBackgroundImageName:(NSString *)selectedImageName addTarget:(id)target action:(SEL)action;

@end
