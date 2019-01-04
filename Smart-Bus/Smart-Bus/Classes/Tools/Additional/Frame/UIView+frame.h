//
//  UIView+frame.h
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

/**
 x坐标
 */
@property (nonatomic, assign) CGFloat frame_x;


/**
 y坐标
 */
@property (nonatomic, assign) CGFloat frame_y;


/**
 宽度
 */
@property (nonatomic, assign) CGFloat frame_width;

/**
 高度
 */
@property (nonatomic, assign) CGFloat frame_height;

/**
 中心点的X
 */
@property (nonatomic, assign) CGFloat frame_centerX;


/**
  中心点的Y
 */
@property (nonatomic, assign) CGFloat frame_centerY;


/**
 屏幕的高度
 */
+ (CGFloat)frame_screenHeight;

/**
 屏幕的宽度
 */
+ (CGFloat)frame_screenWidth;

@end
