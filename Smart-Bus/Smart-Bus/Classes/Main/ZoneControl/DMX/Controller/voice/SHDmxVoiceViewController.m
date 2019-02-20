//
//  SHDmxVoiceViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/17.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHDmxVoiceViewController.h"
#import <Accelerate/Accelerate.h>
#import "EZMicrophone.h"
#import "EZAudioFFT.h"
#import "EZAudioUtilities.h"
#import "EZAudioPlot.h"

@interface SHDmxVoiceViewController () <EZMicrophoneDelegate,
 EZAudioFFTDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewHeightConstraint;


/// 麦克风
@property (strong, nonatomic) EZMicrophone *microPhone;

/// udioFFTRolling
@property (strong, nonatomic) EZAudioFFTRolling *audioFFTRolling;

/// windowSize
@property (assign, nonatomic) vDSP_Length windowSize;

/// 最后的颜色描述
@property (copy, nonatomic) NSString *lastColor;

/// 通道
@property (strong, nonatomic) NSMutableArray *groupChannels;


/// 开关按钮
@property (weak, nonatomic) IBOutlet UIButton *turnOnAndOffButton;

/// EZAudioPlot
@property (weak, nonatomic) IBOutlet EZAudioPlot *audioPlot;

@property (weak, nonatomic) IBOutlet UILabel *sayLabel;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;


@end

@implementation SHDmxVoiceViewController


/// 按钮点击
- (IBAction)buttonClick {
    
    self.turnOnAndOffButton.selected = !self.turnOnAndOffButton.selected;
    
    if (self.turnOnAndOffButton.selected) {
        
        printLog(@"打开状态: %@", self.turnOnAndOffButton.currentTitle);
        [self loadMusic];
        
    } else {
        printLog(@"关状态");
        // 关闭所所有灯光
        [self sendColor:[UIColor clearColor]];
        [self.microPhone stopFetchingAudio];
    }
}

// MARK: - 发送颜色

/// 发送选择的目标颜色控制
- (void)sendColor:(UIColor *)color {
    
    self.turnOnAndOffButton.backgroundColor = color;
    
    CGFloat redColor = 0;
    CGFloat greenColor = 0;
    CGFloat blueClor = 0;
    CGFloat whiteColor = 0;
    
    [color getRed:&redColor green:&greenColor blue:&blueClor alpha:&whiteColor];
    
    Byte red = redColor * 100;
    Byte green = greenColor * 100;
    Byte blue = blueClor * 100;
    Byte white = whiteColor * 100;
    
    for (SHDmxChannel *dmxChannel in self.groupChannels) {
        
        switch (dmxChannel.channelType) {
                
            case SHDmxChannelTypeRed: {
                
                [self sendDmxChannleData:dmxChannel value:red];
            }
                break;
                
            case SHDmxChannelTypeGreen: {
                
                [self sendDmxChannleData:dmxChannel value:green];
            }
                break;
                
            case SHDmxChannelTypeBlue: {
                
                [self sendDmxChannleData:dmxChannel value:blue];
            }
                break;
                
            case SHDmxChannelTypeWhite: {
                
                [self sendDmxChannleData:dmxChannel value:white];
            }
                break;
                
            default:
                break;
        }
    }
}

/// 发送控制颜色通道的的值
- (void)sendDmxChannleData:(SHDmxChannel *)dmxChannel value:(Byte)value {
    
   
    NSArray *channelData =
        @[
          @(dmxChannel.channelNo),
          @(value),
          @(0),
          @(0)
        ];
    
    [SHSocketTools sendDataWithOperatorCode:0x0031
                                   subNetID:dmxChannel.subnetID
                                   deviceID:dmxChannel.deviceID
                             additionalData:channelData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:YES
                                      isDMX:YES
    ];
    
}

// MARK: - 相关的代理

- (void)fft:(EZAudioFFT *)fft updatedWithFFTData:(float *)fftData
         bufferSize:(vDSP_Length)bufferSize {
    
   NSString *noteName = [EZAudioUtilities noteNameStringForFrequency:[fft maxFrequency] includeOctave:YES];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSString *initials = [noteName substringToIndex:1];
        
        UIColor *color;
        
        if ([initials isEqualToString:@"F"]) {
            
            color = [UIColor redColor];
        
        } else if ([initials isEqualToString:@"G"]) {
            
            color = [UIColor greenColor];
        
        } else if ([initials isEqualToString:@"A"]) {
            
            color = [UIColor magentaColor];
        
        } else if ([initials isEqualToString:@"B"]) {
            
            color = [UIColor blueColor];
            
        } else if ([initials isEqualToString:@"C"]) {
            
            color = [UIColor cyanColor];
            
        } else if ([initials isEqualToString:@"D"]) {
            
            color = [UIColor orangeColor];
            
        } else if ([initials isEqualToString:@"E"]) {
            
            color = [UIColor purpleColor];
            
        } else if ([initials isEqualToString:@"F"]) {
            
            color = [UIColor yellowColor];
        }
        
        
        if (weakSelf.lastColor != initials) {
            
            // 发送颜色
            weakSelf.lastColor = initials;
            [weakSelf sendColor:color];
            
            [SVProgressHUD showInfoWithStatus:initials];
        }
        
        [weakSelf.audioPlot clear];
        [weakSelf.audioPlot updateBuffer:fftData withBufferSize:(UInt32)bufferSize];
    });
    
}

- (void) microphone:(EZMicrophone *)microphone
      hasAudioReceived:(float **)buffer
        withBufferSize:(UInt32)bufferSize
  withNumberOfChannels:(UInt32)numberOfChannels {
    
    if (self.audioFFTRolling) {
        
        [self.audioFFTRolling computeFFTWithBuffer:buffer[0] withBufferSize:bufferSize];
    }
}


// MARK: - 初始化 与 回收 资源

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    switch (status) {
        
        case AVAuthorizationStatusAuthorized:
            [self.microPhone stopFetchingAudio];
            break;
            
        case AVAuthorizationStatusNotDetermined:
            break;
            
        case AVAuthorizationStatusRestricted:
            break;
            
        case AVAuthorizationStatusDenied:
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *channels =
        [SHSQLiteManager.shared getDmxGroupChannels:self.dmxGroup];
    
    self.groupChannels =
        [NSMutableArray arrayWithArray:channels];
    
    [self buttonClick];
}

/// 加载音乐
- (void)loadMusic {
    
    NSError *error = nil;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        return;
    }
    
    error = nil;
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    if (error) {
        return;
    }
    
    printLog(@"初始化成功");
   
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    switch (status) {
            
        case AVAuthorizationStatusAuthorized: {
            
            [self initMicroPhone];
            
        }
            break;
        
        case AVAuthorizationStatusNotDetermined: {
            
            [self askForPermission];
        }
            break;
            
        case AVAuthorizationStatusRestricted: {
            
            [self askForPermission];
        }
            break;
            
        case AVAuthorizationStatusDenied: {
            
            [self askForPermission];
        }
            break;
            
        default:
            break;
    }
}

- (void)askForPermission {
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
       
        if (granted) {
            
            [self initMicroPhone];
        }
    }];
}

/// 初始化麦克风
- (void)initMicroPhone {
    
    self.microPhone = [EZMicrophone microphoneWithDelegate:self startsImmediately:YES];
    
    self.audioFFTRolling = [EZAudioFFTRolling fftWithWindowSize:self.windowSize sampleRate:self.microPhone.audioStreamBasicDescription.mSampleRate delegate:self];
    
    [self.microPhone startFetchingAudio];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.windowSize = 4096;
    
    [self.turnOnAndOffButton setTitle:[[SHLanguageTools shareLanguageTools]
                                  getTextFromPlist:@"PUBLIC" withSubTitle:@"OFF"]
                        forState:UIControlStateNormal];
    
    [self.turnOnAndOffButton setTitle:[[SHLanguageTools shareLanguageTools]
                                  getTextFromPlist:@"PUBLIC" withSubTitle:@"ON"]
                        forState:UIControlStateSelected];
    
    
    
    [self.turnOnAndOffButton setRoundedRectangleBorder];
   
    
    if ([UIDevice is_iPad]) {
        
        self.turnOnAndOffButton.titleLabel.font = [UIView suitFontForPad];
        
        self.sayLabel.font = [UIView suitFontForPad];
        
        self.colorLabel.font = [UIView suitFontForPad];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.baseViewHeightConstraint.constant = navigationBarHeight + statusBarHeight;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
