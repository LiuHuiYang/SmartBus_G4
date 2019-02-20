//
//  SHLoadProgressView.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/27.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHLoadProgressView.h"

@interface SHLoadProgressView ()

/// 进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/// 进度条
@property (weak, nonatomic)  IBOutlet UILabel *progressLabel;

/// 定时器
@property (weak, nonatomic) NSTimer *progressTimer;

@end

@implementation SHLoadProgressView

- (void)layoutSubviews {

    [super layoutSubviews];
    
    if (self.superview) {
        
        self.frame = self.superview.bounds;
    }
}

// 添加到父控件
- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];

    // 加载到父控件上后，开始动画
    [self progressValueChange];
}


/// 显示
- (void)progressValueChange {
    
    self.progressView.hidden = NO;
    self.progressView.progress = 0.0;
    self.progressLabel.text = nil;
   
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.progressTimer = timer;
}

// 更新值
- (void)updateProgress {

    CGFloat value = 0.01;
    self.progressView.progress += value;

    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (Byte)(self.progressView.progress * 100)];

    if (self.progressView.progress >= 1.0) {

        [self.progressTimer invalidate];
        self.progressTimer = nil;
        
        [NSThread sleepForTimeInterval:0.05];
        
        [[NSNotificationCenter defaultCenter]
            postNotificationName:commandExecutionComplete
                          object:nil];
        
        if (self.superview) {
            
            self.progressLabel.text = nil;
            self.progressView.progress = 0.0;
            
            [self removeFromSuperview];
        }
    }
}

//// 指定的控件上显示
+ (void)showLoadProgressViewIn:(UIView *)superView {

    // 先从父类上移除 后 添加
    if ([SHLoadProgressView shareLoadProgressView].superview) {
        
        [[SHLoadProgressView shareLoadProgressView] removeFromSuperview];
    }
    
    [superView addSubview:[SHLoadProgressView shareLoadProgressView]];
    
    [SHLoadProgressView shareLoadProgressView].progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    
    if ([UIDevice is_iPad]) {
        
        [SHLoadProgressView shareLoadProgressView].progressLabel.font = [UIFont boldSystemFontOfSize:22];
        
        [SHLoadProgressView shareLoadProgressView].progressView.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    }
}

- (instancetype)init {
    
    self.progressView.hidden = NO;
    self.progressLabel.text = nil;
    
    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

SingletonImplementation(LoadProgressView)

@end
