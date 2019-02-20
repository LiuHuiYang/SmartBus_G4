 

#import <UIKit/UIKit.h>

@interface UIImageView (ReSizeImage)

/**
 缩放图片到一定的比例
 
 @param image 指定图片
 @param scaleSize 缩放比例
 @return 缩放后的图片
 */
- (UIImage *)scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize;

/**
 拉伸图片到指定的大小区域
 
 @param image 要拉伸的图片
 @param reSize 拉伸的大小
 @return 拉伸后的图片
 */
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;


/**
 基于原图产生【圆形图片】
 
 @param sourceImage 需要剪切的原图片
 @param borderWidth 剪切后的边框宽度
 @param borderColor 边框颜色
 @return UIImage * 圆形图片
 */
- (UIImage *)circleImageWithImage:(UIImage *)sourceImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
