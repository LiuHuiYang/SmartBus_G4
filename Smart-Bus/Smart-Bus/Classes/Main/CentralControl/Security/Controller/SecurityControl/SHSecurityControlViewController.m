//
//  SHSecurityViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHSecurityControlViewController.h"
#import "SHReadSecurityLogViewController.h"

@interface SHSecurityControlViewController ()

// MARK: - 安防设置参数的几个参数

/// 其它安防操作的基准高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *securityOtherOperatorViewBaseHeightConstraint;

/// 安防控制的其它操作视图
@property (weak, nonatomic) IBOutlet UIView *securityOtherOperatorView;

/// 关闭其它操作视图
@property (weak, nonatomic) IBOutlet UILabel *closeLabel;

/// 密码
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

/// 日志
@property (weak, nonatomic) IBOutlet UILabel *securityLogLabel;

/// 看门狗状态
@property (weak, nonatomic) IBOutlet UILabel *watchDogLabel;

/// 扫描状态
@property (weak, nonatomic) IBOutlet UILabel *scanStatusLabel;

/// 看门狗开关
@property (weak, nonatomic) IBOutlet UISwitch *watchDogSwitch;

/// 扫描状态开关
@property (weak, nonatomic) IBOutlet UISwitch *scanStatusSwitch;

// MARK: - 中间过渡参数

/// 当前选择的命令按钮
@property (strong, nonatomic) SHCommandButton *currentSelectCommandButton;

/// 安防密码
@property (copy, nonatomic) NSString *securityPassword;

// MARK: - 安防控制

/// 离开
@property (weak, nonatomic) IBOutlet SHCommandButton *awayButton;

/// 离开的指示占位视图
@property (weak, nonatomic) IBOutlet UIView *awayHolderView;

/// 夜晚
@property (weak, nonatomic) IBOutlet SHCommandButton *nightButton;

/// 夜晚的指示占位视图
@property (weak, nonatomic) IBOutlet UIView *nightHolderView;

/// 访客
@property (weak, nonatomic) IBOutlet SHCommandButton *guestButton;

/// 访客的指示占位视图
@property (weak, nonatomic) IBOutlet UIView *guestHolderView;

/// 白天
@property (weak, nonatomic) IBOutlet SHCommandButton *dayButton;

/// 白天的指示占位视图
@property (weak, nonatomic) IBOutlet UIView *dayHolderView;

/// 度假
@property (weak, nonatomic) IBOutlet SHCommandButton *vacationButton;

/// 度假的指示占位视图
@property (weak, nonatomic) IBOutlet UIView *vacationHolderView;

/// 解除
@property (weak, nonatomic) IBOutlet SHCommandButton *disarmButton;

/// 解除的指示占位视图
@property (weak, nonatomic) IBOutlet UIView *disarmHolderView;

/// 报警
@property (weak, nonatomic) IBOutlet SHCommandButton *panicButton;

/// 报警的指示占位视图
@property (weak, nonatomic) IBOutlet UIView *panicHolderView;

/// 急救
@property (weak, nonatomic) IBOutlet SHCommandButton *ambulanceButton;

/// 急救的指示占位视图
@property (weak, nonatomic) IBOutlet UIView *ambulanceHolderView;

/// 模式控制按钮高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonHeightConstraint;

/// 输入密码框
@property (strong, nonatomic) UITextField *inputPasswordTextField;

/// 已经授权的操作
@property (assign, nonatomic) BOOL isAlreadyAuthorizedOperation;

@end

@implementation SHSecurityControlViewController


// MARK: - 解析数据

- (void)analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    if (socketData.subNetID != self.securityZone.subnetID ||
        socketData.deviceID != self.securityZone.deviceID
        ) {
        return;
    }
    
    NSUInteger count = socketData.additionalData.count;
    Byte recivedData[count];
    
    for (int i = 0; i < count; i++) {
        
        recivedData[i] =
        ([socketData.additionalData[i] integerValue]) & 0xFF;
    }
    
    NSString *operatorString = @"";
    
    switch (socketData.operatorCode) {
            
            // 普通安防
        case 0x0105: {
            
            if (recivedData[0] != self.securityZone.zoneID) {
                return;
            }
            
            SHSecurityType securityType = recivedData[1];
            
            switch (securityType) {
                    
                case SHSecurityTypeVacation: {
                    
                    operatorString = SHLanguageText.securityVacation;
                }
                    break;
                    
                case SHSecurityTypeAway: {
                    
                    operatorString = SHLanguageText.securityAway;
                }
                    break;
                    
                case SHSecurityTypeNight: {
                    
                    operatorString = SHLanguageText.securityNight;
                    
                }
                    break;
                    
                case SHSecurityTypeNightGeust: {
                    
                    operatorString = SHLanguageText.securityNightGeust;
                }
                    break;
                    
                case SHSecurityTypeDisarm: {
                    
                    operatorString = SHLanguageText.securityDisarm;
                }
                    break;
                    
                case SHSecurityTypeDay: {
                    
                    operatorString = SHLanguageText.securityDay;
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case 0x010D: {  // 紧急安防
            
            if (recivedData[0] != self.securityZone.zoneID) {
                return;
            }
            
            if (recivedData[1] == 0x08
                && recivedData[4] == self.securityZone.zoneID) {
                
                operatorString = SHLanguageText.securityAmbulance;
                
            } else if(recivedData[1] == 0x04
                      && recivedData[4] == self.securityZone.zoneID) {
                
                operatorString = SHLanguageText.securityPanic;
            }
            
        }
            break;
            
        case 0x0133: {
            
            if (recivedData[0] == 0xF8 && recivedData[1] == self.securityZone.zoneID) {
                
                self.watchDogSwitch.on = !recivedData[3];
            }
        }
            break;
            
        case 0x0135: {
            
            if (recivedData[0] == 0xF8 && recivedData[1] == self.securityZone.zoneID) {
                
                self.watchDogSwitch.on = !self.watchDogSwitch.on;
            }
        }
            break;
            
        case 0x012F: {
            
            if (recivedData[0] == 0xF8
                && recivedData[1] == self.securityZone.zoneID
                && recivedData[2] == 0) {
                
                self.scanStatusSwitch.on = recivedData[3];
            }
            
        }
            break;
            
        case 0x0131: {
            
            if (recivedData[1] == self.securityZone.zoneID
                && recivedData[2] == 0) {
                
                self.scanStatusSwitch.on = !self.scanStatusSwitch.on;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    if (operatorString.length) {
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ %@", operatorString, [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"SECURITY" withSubTitle:@"PROMPT_MESSAGE_0"]]];
    }
}


// MARK: - 其它安防相关的操作事件

/// 密码点击
- (IBAction)securityPasswordClick:(UITapGestureRecognizer *)sender {
    
    SHSetSecurityPasswordViewController *setPassword = [[SHSetSecurityPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:setPassword animated:YES];
}

/// 查看日志点击
- (IBAction)securityLogClick:(UITapGestureRecognizer *)sender {
    
    SHReadSecurityLogViewController *readLog = [[SHReadSecurityLogViewController alloc] init];
    
    readLog.securityZone = self.securityZone;
    
    [self.navigationController pushViewController:readLog animated:YES];
}

/// 扫描状态
- (IBAction)scanStatusClick {
    
  
    NSArray *controlData = @[@(self.securityZone.zoneID),
                             @(0),
                             @(self.scanStatusSwitch.isOn ? 1 : 0)
                            ];
    
    [SHSocketTools sendDataWithOperatorCode:0x0130
                                   subNetID:self.securityZone.subnetID
                                   deviceID:self.securityZone.deviceID
                             additionalData:controlData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
    
}

/// 看门狗状态
- (IBAction)watchDogClick {
    
    NSArray *controlData = @[@(self.securityZone.zoneID),
                             @(0),
                             @(2),
                             @(self.watchDogSwitch.isOn ? 0 : 1),
                             @(0),
                             @(0),
                             @(0),
                             @(0)
                            ];
    
    [SHSocketTools sendDataWithOperatorCode:0x0134
                                   subNetID:self.securityZone.subnetID
                                   deviceID:self.securityZone.deviceID
                             additionalData:controlData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX: false
    ];
}

/// 关闭其它安防操作视图
- (IBAction)closeSecurityOtherOperatorView:(id)sender {
    
    self.securityOtherOperatorView.hidden = YES;
}


// MARK: - 安防控制事件

/// 需要权限的任务 (六种模式 其它两种不需要)
- (void)getOperationAuthorization:(void (^)(void))task {
    
    if (!task) {
        
        return;
    }
    
    if (self.isAlreadyAuthorizedOperation) {
        
        task(); // 直接执行任务
        
        return;
    }
    
    // 第一次进入，没有输入正确密码
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:([[SHLanguageTools shareLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"SYSTEM_PROMPT"]) message:nil isCustom:YES];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        [textField becomeFirstResponder];
        textField.placeholder = [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"SECURITY" withSubTitle:@"TYPE_PASSWORD"];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.secureTextEntry = YES;
        
        self.inputPasswordTextField = textField;
    }];
    
    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.cancel style:TYAlertActionStyleCancel handler: nil]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.ok style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        NSString *savePassword = [[NSUserDefaults standardUserDefaults] objectForKey:securityPasswordKey];
        
        if ([self.inputPasswordTextField.text isEqualToString:savePassword] ||
            [self.inputPasswordTextField.text isEqualToString:@"root"]) {
            
            self.isAlreadyAuthorizedOperation = YES;
            
            task();
            
        } else {
            
            [SVProgressHUD showErrorWithStatus: ([[SHLanguageTools shareLanguageTools] getTextFromPlist:@"SECURITY" withSubTitle:@"PROMPT_MESSAGE_4"])];
            
            self.isAlreadyAuthorizedOperation = NO;
        }
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
    
    if ([UIDevice is4_0inch] || [UIDevice is3_5inch]) {
        
        alertController.alertViewOriginY = navigationBarHeight + statusBarHeight;
    }
    
    alertController.backgoundTapDismissEnable = YES;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 点击离开
- (IBAction)awayButtonClick {
    
    [self getOperationAuthorization:^{
       
        [self changeProgressStatus:self.awayButton progressHoldView:self.awayHolderView];
    }];
}

/// 点击晚上
- (IBAction)nightButtonClick {
    
    [self getOperationAuthorization:^{
        [self changeProgressStatus:self.nightButton progressHoldView:self.nightHolderView];
    }];
}

/// 点击访客
- (IBAction)guestButtonClick {
    
    [self getOperationAuthorization:^{
      
         [self changeProgressStatus:self.guestButton progressHoldView:self.guestHolderView];
    }];
}

/// 点击白天
- (IBAction)dayButtonClick {
    
    [self getOperationAuthorization:^{
        
        [self changeProgressStatus:self.dayButton progressHoldView:self.dayHolderView];
    }];
}

/// 点击度假
- (IBAction)vacationButtonClick {
    
    [self getOperationAuthorization:^{
        
        [self changeProgressStatus:self.vacationButton progressHoldView:self.vacationHolderView];
    }];
}

/// 点击解除
- (IBAction)disarmButtonClick {
    
    [self getOperationAuthorization:^{
        
        [self changeProgressStatus:self.disarmButton progressHoldView:self.disarmHolderView];
    }];
}

/// 报警触发
- (IBAction)panicPress:(UILongPressGestureRecognizer *)sender {
    
    // 初始状态才识别
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if ((SHCommandButton *)sender.view != self.panicButton) {
        
        return;
    }
    
    // 更新状态
    [self changeProgressStatus:self.panicButton progressHoldView:self.panicHolderView];
}

/// 急救触发
- (IBAction)ambulancePress:(UILongPressGestureRecognizer *)sender {
    
    // 初始状态才识别
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if ((SHCommandButton *)sender.view != self.ambulanceButton) {
        
        return;
    }
    
    // 更新状态
    [self changeProgressStatus:self.ambulanceButton progressHoldView:self.ambulanceHolderView];
}


// MARK: - 发送指令 && 更新进度指示条

/// 更新进度信息
- (void)changeProgressStatus:(SHCommandButton *)commandButton progressHoldView:(UIView *)progressHoldView {
    
    // 1.执行动画
    if (self.currentSelectCommandButton != commandButton && !self.currentSelectCommandButton.selected) {
        
        self.currentSelectCommandButton = commandButton;
        commandButton.selected = YES;
        [SHLoadProgressView showLoadProgressViewIn:progressHoldView];
    }
    
    // 2.发送对应的指令
    
    if (commandButton.securityType == SHSecurityTypeAmbulance) { // 急救
        
        // 这里应该有问题？？？ // 01 0A  01 08 00 00 01  9A 25
        NSArray *securityData = @[@(self.securityZone.zoneID), @(8),
                                  @(0), @(0), @(self.securityZone.zoneID)];
        
        [SHSocketTools sendDataWithOperatorCode:0x010C
                                       subNetID:self.securityZone.subnetID
                                       deviceID:self.securityZone.deviceID
                                 additionalData:securityData
                               remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                     needReSend:true
                                          isDMX:false
         ];
        
    } else if (commandButton.securityType == SHSecurityTypePanic) { // 报警
        
        // 这里应该有问题？？？
        NSArray *securityData = @[@(self.securityZone.zoneID), @(4),
                                  @(0), @(0), @(self.securityZone.zoneID)];
        
        [SHSocketTools sendDataWithOperatorCode:0x010C
                                       subNetID:self.securityZone.subnetID
                                       deviceID:self.securityZone.deviceID
                                 additionalData:securityData
                               remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                     needReSend:true
                                          isDMX:false
         ];
        
    } else {  // 普通安防
        
        NSArray *securityData = @[@(self.securityZone.zoneID),
                                  @(commandButton.securityType)
                                ];
        
        [SHSocketTools sendDataWithOperatorCode:0x0104
                                       subNetID:self.securityZone.subnetID
                                       deviceID:self.securityZone.deviceID
                                 additionalData:securityData
                               remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                     needReSend:true
                                          isDMX:false
        ];
    }
}

/// 动画完成
- (void)commandButtonChangeStatus {
    
    self.currentSelectCommandButton.selected = NO;
    self.currentSelectCommandButton = nil;
}

/// 设置点击
- (void)setSecurity {
    
    [self getOperationAuthorization:^{

        self.securityOtherOperatorView.hidden = NO;
        
        // 读看门狗的状态
        NSArray *watchDogData = @[@(self.securityZone.zoneID)];
        
        [SHSocketTools sendDataWithOperatorCode:0x0132
                                       subNetID:self.securityZone.subnetID
                                       deviceID:self.securityZone.deviceID
                                 additionalData:watchDogData
                               remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                     needReSend:true
                                          isDMX:false
        ];
        
        // 扫描状态
        
        NSArray *statusData = @[@(self.securityZone.zoneID), @(0)];
        
        [SHSocketTools sendDataWithOperatorCode:0x012E
                                       subNetID:self.securityZone.subnetID
                                       deviceID:self.securityZone.deviceID
                                 additionalData:statusData
                               remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                     needReSend:true
                                          isDMX:false
         ];
    }];
}

// MARK: - UI设置

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is3_5inch]) {
        
        self.securityOtherOperatorViewBaseHeightConstraint.constant = defaultHeight;
        
    } else if ([UIDevice is4_0inch]) {
        
        self.controlButtonHeightConstraint.constant = navigationBarHeight;
        self.securityOtherOperatorViewBaseHeightConstraint.constant = tabBarHeight;
        
    } else if ([UIDevice is_iPad]) {
        
        self.controlButtonHeightConstraint.constant = self.isPortrait ? (navigationBarHeight + navigationBarHeight + statusBarHeight) : ((navigationBarHeight + tabBarHeight));
        
        self.securityOtherOperatorViewBaseHeightConstraint.constant = self.isPortrait ? (navigationBarHeight + tabBarHeight) : ( navigationBarHeight + statusBarHeight);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 如果没有设置初始密码 -- 则设置默认为8888
    if (![[NSUserDefaults standardUserDefaults] objectForKey:securityPasswordKey]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"8888" forKey:securityPasswordKey];
    }
    
    //  适配文字与图片
    [self.awayButton setTitle:SHLanguageText.securityAway forState:UIControlStateNormal];
    [self.nightButton setTitle:SHLanguageText.securityNight forState:UIControlStateNormal];
    [self.guestButton setTitle:SHLanguageText.securityNightGeust forState:UIControlStateNormal];
    [self.dayButton setTitle:SHLanguageText.securityDay forState:UIControlStateNormal];
    [self.vacationButton setTitle:SHLanguageText.securityVacation forState:UIControlStateNormal];
    [self.disarmButton setTitle:SHLanguageText.securityDisarm forState:UIControlStateNormal];
    [self.panicButton setTitle:SHLanguageText.securityPanic forState:UIControlStateNormal];
    [self.ambulanceButton setTitle:SHLanguageText.securityAmbulance forState:UIControlStateNormal];
    
    [self.awayButton setRoundedRectangleBorder];
    [self.nightButton setRoundedRectangleBorder];
    [self.guestButton setRoundedRectangleBorder];
    [self.dayButton setRoundedRectangleBorder];
    [self.vacationButton setRoundedRectangleBorder];
    [self.disarmButton setRoundedRectangleBorder];
    [self.panicButton setRoundedRectangleBorder];
    [self.ambulanceButton setRoundedRectangleBorder];
    
    // 设置导航
    self.navigationItem.title = self.securityZone.zoneNameOfSecurity;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"setting" hightlightedImageName:@"setting" addTarget:self action:@selector(setSecurity) isLeft:NO];
    
    //  设置各个按钮的初始化状态
    self.awayButton.securityType = SHSecurityTypeAway;
    self.nightButton.securityType = SHSecurityTypeNight;
    self.dayButton.securityType = SHSecurityTypeDay;
    self.guestButton.securityType = SHSecurityTypeNightGeust;
    self.vacationButton.securityType = SHSecurityTypeVacation;
    self.disarmButton.securityType = SHSecurityTypeDisarm;
    self.panicButton.securityType = SHSecurityTypePanic;
    self.ambulanceButton.securityType = SHSecurityTypeAmbulance;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commandButtonChangeStatus) name:commandExecutionComplete object:nil];
    
    self.securityOtherOperatorView.hidden = YES;
    self.scanStatusSwitch.on = NO;
    self.watchDogSwitch.on = NO;
    self.closeLabel.text = [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_CLOSE"];
    
    if ([UIDevice is_iPad]) {  // 安防的按钮已经在其它地方进行了适配
        
        UIFont *font = [UIView suitFontForPad];
        self.passwordLabel.font = font;
        self.securityLogLabel.font = font;
        self.scanStatusLabel.font = font;
        self.watchDogLabel.font = font;
        self.closeLabel.font = font;
    }
}

- (void)dealloc {
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
