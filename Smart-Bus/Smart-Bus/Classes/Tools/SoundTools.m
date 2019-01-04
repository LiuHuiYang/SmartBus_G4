//
//  SoundTools.m
//  单例播放音效
//
//  Created by Mark Liu on 2016/11/4.
//  Copyright © 2016年 Mark Liu. All rights reserved.
//

#import "SoundTools.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundTools ()


/**
 所有音效字典播放
 */
@property (strong, nonatomic) NSMutableDictionary *soundDict;

@end

@implementation SoundTools

SingletonImplementation(SoundTools)



- (NSMutableDictionary *)soundDict {
    if (!_soundDict) {
        // arc下：类方法实例化字典，autorelease
//        _soundDict = [NSMutableDictionary dictionary];
//        
//        [_soundDict retain];
        
        // 或者也可以这样改
        _soundDict = [[NSMutableDictionary alloc] init];
    }
    return _soundDict;
}


/**
 单例一次加载所有音效
 */
- (instancetype)init {
    if (self = [super init]) {
        [self loadAllSounds];
    }
    return self;
}


/**
 加载所有音效
 */
- (void)loadAllSounds {
    
    // 1.找到资源
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Sounds.bundle"];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    // 2.遍历数组加载载
    for (NSString *fileName in files) {
        
        SystemSoundID soundId = [self loadSoundWithName:fileName];
        
        // 存入到字典
        [self.soundDict setObject:@(soundId) forKey:fileName];
    }
//    SHLog(@"%@", self.soundDict);
}


/**
 停止播放音乐

 @param name 音乐的名称
 */
- (void)stopSoundWithName:(NSString *)name {

    SystemSoundID soundId = [self.soundDict[name] unsignedIntValue];
    
    AudioServicesDisposeSystemSoundID(soundId);
     
    soundId = [self loadSoundWithName:name];
    
    [self.soundDict setObject:@(soundId) forKey:name];
}

/**
 播放音效

 @param name 音效名称
 */
- (void)playSoundWithName:(NSString *)name {
   
    SystemSoundID soundId = [self.soundDict[name] unsignedIntValue];
   
    AudioServicesPlaySystemSound(soundId);
    
    // 如果静音，会有振动
//    AudioServicesPlayAlertSound(soundId)
}

/**
 根据文件名加载并反回 soundID

 @return 创建的soundID
 */
- (SystemSoundID)loadSoundWithName:(NSString *)name {

    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:nil subdirectory:@"Sounds.bundle"];
    
    SystemSoundID soundId = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundId);
    
    return soundId;
}

@end
