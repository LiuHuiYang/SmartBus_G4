 

#import <UIKit/UIKit.h>

@interface UIImageView (ColorAtPoint)

/**
 获得图片中某个点的颜色
 
 @param point 点击的点
 @return UIColor
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

/**
 获得图片中某个点的颜色
 
 @param point 点击的点
 @return [red, green, blue, alpha]
 */
- (NSData *)dataWithColor:(CGPoint)point;

/// 获得图片中的主要颜色
+ (NSMutableArray *)mainColoursInImage:(UIImage *)image;


@end
