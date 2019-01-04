 

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

/// 处理图片的自动旋转（从相片或相机中获取的图片会自动旋转90度处理类方法）
+ (UIImage *)fixOrientation:(UIImage *)sourceImage;

@end
