/*
 
 调整图片的大小
 */

#import <UIKit/UIKit.h>

@interface UIImage (ReSize)

/**
 根据CIImage生成指定大小的UIImage
 
 @param image CIImage (注意不是UIImage)
 @param imageSize 显示图片的区域大小(CGSize)
 @return 高清图片
 */
+ (UIImage *)generatingHighGefinitionImage:(CIImage *)image imageSize:(CGSize) imageSize;


/**
 *  传入图片名称,返回拉伸好的图片
 */
- (UIImage *)resizeImage;

/**
 *  传入图片名称,返回拉伸好的图片
 */
+ (UIImage *)resizeImage:(NSString *)imageName;


/**
 指定宽度绘制等比例的新图片
 
 @param image 图征
 @param width 图片的宽度
 @return UIImage *
 */
+ (UIImage *)darwNewImage:(UIImage *)image width:(CGFloat)width;



/**
 获得一张透明颜色的图片

 @param imageSize 图片的大小
 @return UIIage *
 */
+ (UIImage *)getClearColorImage:(CGSize)imageSize;

@end
