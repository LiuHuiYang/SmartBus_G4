 

#import <UIKit/UIKit.h>

@interface UIImage (Antialias)



/**
 返回一张抗锯齿图片 在图片生成一个透明为1的像素边框

 @return UIImage *
 */
- (UIImage *)imageAntialias;

@end
