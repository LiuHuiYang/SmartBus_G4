//
//  SHDmxPictureViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHDmxPictureViewController.h"

@interface SHDmxPictureViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/// 选择照片按钮
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

/// 选择相机按钮
@property (weak, nonatomic) IBOutlet UIButton *camereButton;

/// 获取到的图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/// 选择的颜色显示
@property (weak, nonatomic) IBOutlet UIView *showColorView;

/// 发送按钮
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

/// 按钮高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

// 四个属性
@property (assign, nonatomic) Byte red;
@property (assign, nonatomic) Byte green;
@property (assign, nonatomic) Byte blue;
@property (assign, nonatomic) Byte alpha;

/// 通道
@property (strong, nonatomic) NSMutableArray *groupChannels;

/// 底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMarignConstraint;

@end

@implementation SHDmxPictureViewController

/// 发送按钮点击
- (IBAction)sureButtonClick {
    
    for (SHDmxChannel *dmxChannel in self.groupChannels) {
        
        switch (dmxChannel.channelType) {
                
            case SHDmxChannelTypeRed: {
                
                [self sendDmxChannleData:dmxChannel value:self.red];
            }
                break;
                
            case SHDmxChannelTypeGreen: {
                
                [self sendDmxChannleData:dmxChannel value:self.green];
            }
                break;
                
            case SHDmxChannelTypeBlue: {
                
                [self sendDmxChannleData:dmxChannel value:self.blue];
            }
                break;
                
            case SHDmxChannelTypeWhite: {
                
                [self sendDmxChannleData:dmxChannel value:self.alpha];
            }
                break;
                
            default:
                break;
        }
    }
}


/// 发送控制颜色通道的的值
- (void)sendDmxChannleData:(SHDmxChannel *)dmxChannel value:(Byte)value {
     
    NSArray *controlData = @[@(dmxChannel.channelNo), @(value), @(0), @(0)];
    
    [SHSocketTools sendDataWithOperatorCode:0x0031
                                   subNetID:dmxChannel.subnetID
                                   deviceID:dmxChannel.deviceID
                             additionalData:controlData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:true
     ];
    
}


// MARK: - 图片颜色

/// 显示选择的颜色
- (void)showSelectColor:(UIButton *)button  {
    
    UIColor *color = button.backgroundColor;
    
    self.sureButton.backgroundColor = color;
    
    CGFloat redColor, greenColor, blueColor, alpha;
    [color getRed:&redColor green:&greenColor blue:&blueColor alpha:&alpha];
    
    self.red = redColor * lightMaxBrightness;
    self.green = greenColor * lightMaxBrightness;
    self.blue = blueColor * lightMaxBrightness;
    self.alpha = alpha * lightMaxBrightness;
}

/// 获得图片的颜色
- (void)getImageColor {
    
    [self.showColorView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *colors = [UIImageView mainColoursInImage:self.iconView.image];
    
    for (NSUInteger i = 0; i < colors.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(showSelectColor:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = colors[i];
        button.tag = i;
        [self.showColorView addSubview:button];
    }
 
    // 每次设置图片都要进行布局
    [self layoutColorButton];
}

// MARK: - 图片的取得

/// 取消操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/// 获得照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *sourceImage = [UIImage fixOrientation:
                                info[UIImagePickerControllerOriginalImage]];
    
    sourceImage = [UIImage darwNewImage:sourceImage width:self.view.frame_width];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(sourceImage, self, nil, nil);
    }
    
    self.iconView.image = sourceImage;
    
    // 生成颜色
    [self getImageColor];
    
}

/// 照片
- (IBAction)photoButtonClick {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


/// 相机
- (IBAction)cameraButtonClick {
 
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

/// 布局颜色按钮
- (void)layoutColorButton {
    
    NSUInteger count = self.showColorView.subviews.count;
    
    if (count) {
        
        CGFloat buttonWidth = self.showColorView.frame_width / count;
        CGFloat buttonHeight = self.showColorView.frame_height;
        
        for (UIButton *button in self.showColorView.subviews) {
            
            button.frame = CGRectMake(buttonWidth * button.tag, 0, buttonWidth, buttonHeight);
        }
    }
}

/// 布局
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self layoutColorButton];
    
    self.bottomMarignConstraint.constant = [UIDevice is_iPhoneX_More] ? (tabBarHeight_iPhoneX_more + statusBarHeight): navigationBarHeight;
    
    if ([UIDevice is_iPad]) {
        
        self.buttonHeightConstraint.constant =
            navigationBarHeight + statusBarHeight;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.groupChannels = [[SHSQLManager shareSQLManager] getDmxGroupChannels:
                          self.dmxGroup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.camereButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.sureButton setTitle:SHLanguageText.ok forState:UIControlStateNormal];
    
    [self.sureButton setRoundedRectangleBorder];
    
    if ([UIDevice is_iPad]) {
        
        self.sureButton.titleLabel.font = [UIView suitFontForPad];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
