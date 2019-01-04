//
//  SoundTools.h
//  单例播放音效
//
//  Created by Mark Liu on 2016/11/4.
//  Copyright © 2016年 Mark Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface SoundTools : NSObject

SingletonInterface(SoundTools)

 
/**
 播放音效
 
 @param name 指定音乐
 */
- (void)playSoundWithName:(NSString *)name;

/**
 停止播放音乐
 
 @param name 音乐的名称
 */
- (void)stopSoundWithName:(NSString *)name;

@end
