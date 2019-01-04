//
//  SHDmxFunctionViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/10.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHDmxFunctionViewController.h"
#import "SHDmxFunctionCustomView.h"


@interface SHDmxFunctionViewController () <UIPickerViewDelegate,
    UIPickerViewDataSource>

/// 按钮高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

/// 显示当前的颜色
@property (weak, nonatomic) IBOutlet UIView *showColorView;


/// 关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *turnOffButton;

/// 所有的场景
@property (nonatomic, strong) NSMutableArray *allScenes;

/// 不同的场景颜色
@property (nonatomic, strong) NSMutableArray *sceneColors;

/// 通道
@property (strong, nonatomic) NSMutableArray *groupChannels;

/// 定时器
@property (weak, nonatomic) NSTimer *timer;

/// 执行的颜色下标
@property (assign, nonatomic) NSUInteger executeIndex;


/// 设定时间按钮
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

/// 输入值框
@property (strong, nonatomic) UITextField *valueTextField;

@end

@implementation SHDmxFunctionViewController

/// 时间选择
- (IBAction)timeButtonClick {
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:
            @"Setting execution time" message:nil isCustom:YES];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        [textField becomeFirstResponder];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        self.valueTextField = textField;
    }];
    
    
    [alertView addAction:[TYAlertAction actionWithTitle:
        SHLanguageText.cancel style:TYAlertActionStyleCancel handler: nil]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.save style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        if (![self.valueTextField.text isEqualToString:@""] &&
            self.valueTextField.text.length) {
            
            [self.timeButton setTitle:[NSString stringWithFormat:@"%@ Second",
                                       self.valueTextField.text]
                             forState:UIControlStateNormal];
//            CGFloat time = self.valueTextField.text.doubleValue;
//            
//            printLog(@"%@", @(time));
            
            [self startSendColors];
        }
        
    }]];
    
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    if ([UIDevice is4_0inch] || [UIDevice is3_5inch]) {
        
        alertController.alertViewOriginY = navigationBarHeight + statusBarHeight;
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}


/// 关闭按钮点击
- (IBAction)turnOfButtonClick {
    
    self.turnOffButton.selected = !self.turnOffButton.selected;
    [self startSendColors];
}


/// 发送颜色
- (void)startSendColors {
    
    if (self.timer) {
        
        [self.timer invalidate];
        self.timer = nil;
        self.executeIndex = 0; // 每次选择后，执行的颜色下标都是从0开始，不能累加
    }
    
    // 停止, 不再启动定时器
    if (!self.turnOffButton.selected) {
        return;
    }
   
    CGFloat time = [[[self.timeButton.currentTitle
                      componentsSeparatedByString:@" "] firstObject] doubleValue];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
    
    [timer fire];
    
    self.turnOffButton.selected = YES;  // 此时已经开了
}

- (void)changeColor {
    
    UIColor *selectColor = self.sceneColors[self.executeIndex++];
    self.executeIndex %= self.sceneColors.count;
    
    self.showColorView.backgroundColor = selectColor;
    [self sendColor:selectColor];
}

/// 发送选择的目标颜色控制
- (void)sendColor:(UIColor *)color {
    
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

// MARK: - pickerView的代理和数据源

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (row) {
        
        case 0: {
            
            self.sceneColors = [NSMutableArray arrayWithObjects:
                                [UIColor redColor],
                                [UIColor colorWithRed:1.0 green:165/255.0
                                                 blue:0 alpha:1.0],
                                [UIColor yellowColor],
                                [UIColor greenColor],
                                [UIColor colorWithRed:0 green:127/255.0
                                                 blue:0 alpha:1.0],
                                [UIColor blueColor],
                                [UIColor colorWithRed:139/255.0 green:0
                                                 blue:1.0 alpha:1.0],
                                
                                nil];
        }
            break;
            
        case 1: {
            
            self.sceneColors = [NSMutableArray arrayWithObjects:
                                [UIColor redColor],
                                [UIColor whiteColor],
                                nil];
        }
            break;
            
        case 2: {
            
            self.sceneColors = [NSMutableArray arrayWithObjects:
                                [UIColor greenColor],
                                [UIColor whiteColor],
                                nil];
        }
            break;
            
        case 3: {
            
            self.sceneColors = [NSMutableArray arrayWithObjects:
                                [UIColor blueColor],
                                [UIColor whiteColor],
                                nil];
        }
            break;
            
        case 4: {
         
            self.sceneColors = [NSMutableArray arrayWithObjects:
                                [UIColor whiteColor],
                                [UIColor colorWithRed:0 green:0 blue:0 alpha:0],
                                nil];
        }
            break;
            
        case 5: {
            
            self.sceneColors = [NSMutableArray arrayWithObjects:
                                [UIColor redColor],
                                [UIColor blueColor],
                                nil];
        }
            break;
            
        case 6: {
            
            self.sceneColors = [NSMutableArray arrayWithObjects:
                                [UIColor greenColor],
                                [UIColor redColor],
                                nil];
        }
            break;
            
        case 7: {
         
            self.sceneColors = [NSMutableArray arrayWithObjects:
                                [UIColor greenColor],
                                [UIColor blueColor],
                                nil];
        }
            break;
            
        default:
            break;
    }
    
    [self startSendColors];
}


/// 返回显示视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {

    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {

        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor colorWithHex:0xFCFCFC alpha:0.6];
        }
    }

    SHDmxFunctionCustomView  *customView = [SHDmxFunctionCustomView dmxFunctionCustomView];

    customView.sceneName = self.allScenes[row];

    return customView;
}

/// 返回行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return [SHDmxFunctionCustomView rowHeight];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.allScenes.count;
}

/// 出现了默认选择第一个
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.groupChannels = [[SHSQLManager shareSQLManager] getDmxGroupChannels:
                          self.dmxGroup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.turnOffButton setTitle:SHLanguageText.off
                        forState:UIControlStateNormal];
    
     [self.turnOffButton setTitle:SHLanguageText.on
                         forState:UIControlStateSelected];
    
    
    
    [self.turnOffButton setRoundedRectangleBorder];
    [self.timeButton setRoundedRectangleBorder];
    
    if ([UIDevice is_iPad]) {
        
        self.timeButton.titleLabel.font = [UIView suitFontForPad];
        self.turnOffButton.titleLabel.font = [UIView suitFontForPad];
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

// MARK: - getter && setter

- (NSMutableArray *)allScenes {
    
    if (!_allScenes) {
        
        _allScenes = [NSMutableArray arrayWithObjects:
                      @"Seven Color Cross Fade",
                      @"Red Gradual Change",
                      @"Green Gradual Change",
                      @"Blue Gradual Change",
                      @"White Fade Change",
                      @"Red And Blue",
                      @"Green And Red",
                      @"Green And Blue",
                      nil];
    }
    
    return _allScenes;
}

@end
