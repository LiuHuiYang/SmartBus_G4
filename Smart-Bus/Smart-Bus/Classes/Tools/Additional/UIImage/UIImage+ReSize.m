 

#import "UIImage+ReSize.h"

@implementation UIImage (ReSize)

/**
 根据CIImage生成指定大小的UIImage

 @param image CIImage (注意不是UIImage)
 @param size 显示图片的区域大小(CGSize)
 @return 高清图片
 */
+ (UIImage *)generatingHighGefinitionImage:(CIImage *)image imageSize:(CGSize) imageSize
{
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(imageSize.width/CGRectGetWidth(extent), imageSize.height/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}



/**
 *  传入图片名称,返回拉伸好的图片
 */
+ (UIImage *)resizeImage:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGFloat width = image.size.width * 0.5;
    CGFloat height = image.size.height * 0.5;
    return [image stretchableImageWithLeftCapWidth:width topCapHeight:height];
}

/**
 *  传入图片名称,返回拉伸好的图片
 */
- (UIImage *)resizeImage {
    CGFloat width = self.size.width * 0.5;
    CGFloat height = self.size.height * 0.5;
    
    return [self stretchableImageWithLeftCapWidth:width topCapHeight:height];
}

/**
 指定宽度绘制等比例的新图片
 
 @param image 图征
 @param width 图片的宽度
 @return UIImage *
 */
+ (UIImage *)darwNewImage:(UIImage *)image width:(CGFloat)width {
    
    CGFloat height = image.size.height * width / image.size.width;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

 
/**
 获得一张透明颜色的图片
 
 @param imageSize 图片的大小
 @return UIIage *
 */
+ (UIImage *)getClearColorImage:(CGSize)imageSize {

    //开启一个图片上下文.
    UIGraphicsBeginImageContext(imageSize); // 这个数字是为了方便触摸方便。在其它项目中依据需要是否要改成(1，1)
    
    //使用无色进行填充.
    [[UIColor clearColor] setFill];
    
    //从图片上下文中获取图片.
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片上下文,否则会造成内存泄露.
    UIGraphicsEndImageContext();
    
    return image;
}

@end
