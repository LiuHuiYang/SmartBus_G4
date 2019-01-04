//
//  UIBarButtonItem+init.m


#import "UIBarButtonItem+init.h"
#import "UIButton+init.h"

const CGFloat marign = 2;

@implementation UIBarButtonItem (init)

/**
实例BarButtonItem(如果不需要点击事件 参数使用 nil)

@param imageName 常态图片名称
@param hightlightedImageName 点击下的图片名称
@param target 点击响应者
@param action 响应事件
@param isLeft 左边还是右边
@return UIBarButtonItem
*/
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName
                     hightlightedImageName:(NSString *)hightlightedImageName
                                 addTarget:(id)target
                                    action:(SEL)action
                                    isLeft:(BOOL)isLeft {
    
    UIButton *button =
        [UIButton buttonWithImageName:imageName
                 highlightedImageName:hightlightedImageName
                  backgroundImageName:nil
       highlightedBackgroundImageName:nil
                            addTarget:target
                               action:action
        ];
    
    if (isLeft) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -marign, 0, 0);
    } else {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -marign);
    }
    
    [button sizeToFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

/**
 创建UIBarButtonItem
 
 @param title 标题
 @param font 字体
 @param normalTextColor 颜色
 @param highlightedTextColor 高亮颜色
 @param target 响应
 @param action 事件
 @param isNavigationBackItem 是否为导航栏的返回按钮
 @return item
 */
+ (instancetype)barButtonItemTitle:(NSString *)title
                              font:(UIFont *)font
                   normalTextColor:(UIColor *)normalTextColor
              highlightedTextColor:(UIColor *)highlightedTextColor
                         addTarget:(id)target action:(SEL)action
              isNavigationBackItem:(BOOL)isNavigationBackItem {
    
    // 创建按钮
    UIButton *button = [[UIButton alloc] init];
    
    // 设置文字
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normalTextColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
    
    button.titleLabel.font = font;
    
    if (isNavigationBackItem) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -marign, 0, 0);
        
    }
    
    [button sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/**
 创建UIBarButtonItem
 
 @param title 标题
 @param font 字体
 @param normalTextColor 颜色
 @param highlightedTextColor 高亮颜色
 @param imageName 图片
 @param hightlightedImageName 高亮图片
 @param target 响应
 @param action 事件
 @param isNavigationBackItem 是否为导航栏的返回按钮
 @return item
 */
+ (instancetype)barButtonItemTitle:(NSString *)title font:(UIFont *)font normalTextColor:(UIColor *)normalTextColor highlightedTextColor:(UIColor *)highlightedTextColor  imageName:(NSString *)imageName hightlightedImageName:(NSString *)hightlightedImageName addTarget:(id)target action:(SEL)action isNavigationBackItem:(BOOL)isNavigationBackItem {
    
    // 创建按钮
    UIButton *button = [UIButton buttonWithImageName:imageName highlightedImageName:hightlightedImageName backgroundImageName:nil highlightedBackgroundImageName:nil addTarget:target action:action];
    
    // 设置文字
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normalTextColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
    
    button.titleLabel.font = font;
    
    if (isNavigationBackItem) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -marign, 0, 0);
    }
    
    [button sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
