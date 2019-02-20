 
#import "UIImageView+ReSizeImage.h"

@implementation UIImageView (ReSizeImage)

/**
 缩放图片到一定的比例
 
 @param image 指定图片
 @param scaleSize 缩放比例
 @return 缩放后的图片
 */
- (UIImage *)scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


/**
 拉伸图片到指定的大小区域
 
 @param image 要拉伸的图片
 @param reSize 拉伸的大小
 @return 拉伸后的图片
 */
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}


/**
 基于原图产生【圆形图片】
 
 @param sourceImage 需要剪切的原图片
 @param borderWidth 剪切后的边框宽度
 @param borderColor 边框颜色
 @return UIImage * 圆形图片
 */
- (UIImage *)circleImageWithImage:(UIImage *)sourceImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    CGFloat imageWidth = sourceImage.size.width + 2 * borderWidth;
    
    CGFloat imageHeight = sourceImage.size.height + 2 * borderWidth;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, 0.0);
    
    UIGraphicsGetCurrentContext();
    
    CGFloat radius = (sourceImage.size.width < sourceImage.size.height?sourceImage.size.width:sourceImage.size.height)*0.5;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth * 0.5, imageHeight * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    bezierPath.lineWidth = borderWidth;
    
    [borderColor setStroke];
    
    [bezierPath stroke];
    
    [bezierPath addClip];
    
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
