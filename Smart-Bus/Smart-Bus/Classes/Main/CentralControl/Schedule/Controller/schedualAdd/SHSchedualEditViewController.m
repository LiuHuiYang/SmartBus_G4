//
//  SHSchedualEditViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/20.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchedualEditViewController.h"
#import "SHSchduleMacroView.h"
#import "SHSchduleMoodView.h"
#import "SHSchduleLightView.h"
#import "SHSchduleHVACView.h"
#import "SHSchduleAudioView.h"
#import "SHSchduleShadeView.h"


/// 控制区域重用标示符
static NSString *schdualContolItemAndZoneCellReusableIdentifier =
    @"SHSchdualContolItemAndZoneCell";

@interface SHSchedualEditViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

// MARK: - 约束相关

/// 向上移动的基础约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseTopConstraint;

/// 设置view的顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingViewTopConstraint;

/// 子控件的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *basseViewHeightConstraint;

// MARK: - 不同的计划部分

/// 所有的控制类型数据
@property (strong, nonatomic) NSMutableArray *controlItems;

/// 宏命令展示
@property (strong, nonatomic) SHSchduleMacroView *macroView;

/// mood展示
@property (strong, nonatomic) SHSchduleMoodView *moodView;

/// light展示
@property (strong, nonatomic) SHSchduleLightView *lightView;

/// HVAC展示
@property (strong, nonatomic) SHSchduleHVACView *hvacView;

/// audio展示
@property (strong, nonatomic) SHSchduleAudioView *audioView;

/// shade展示
@property (strong, nonatomic) SHSchduleShadeView *shadeView;

// MARK： - 计划名称

/// 计划名称textField
@property (weak, nonatomic) IBOutlet UITextField *scheduleNameTextField;

// MARK: - 控制类型

/// 控制类型的提示Label
@property (weak, nonatomic) IBOutlet UILabel *controlItemLabel;

/// 控制类型按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *controlItemButton;

/// 控制类型列表
@property (weak, nonatomic) IBOutlet UITableView *controlItemListView;

// MARK: - 控制区域

/// 区域控制Label
@property (weak, nonatomic) IBOutlet UILabel *controlZoneLabel;

/// 区域按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *controlZoneButton;

/// 控制区域列表
@property (weak, nonatomic) IBOutlet UITableView *controlZoneListView;



/// 所有的区域
@property (strong, nonatomic) NSMutableArray *allZones;

// MARK: - 显示需要控制的内容

/// 选择区域展示列表
@property (weak, nonatomic) IBOutlet UIView *showControlScheduleView;

/// 执行频率
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;

/// 保存数据
@property (weak, nonatomic) IBOutlet SHCommandButton *saveButton;

/// 声音按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *soundButton;


/// 执行频率按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *frequencyButton;

/// 时间按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *timeButton;

/// 选择星期按钮
@property (weak, nonatomic) IBOutlet SHCommandButton *selectWeekButton;

/// 日期选择器
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SHSchedualEditViewController


// MARK: - 按钮点击

/// 选择执行的时间
- (IBAction)selectExecuteTime {
    
    [self showTime];
}

/// 选择星期
- (IBAction)selectWeekButtonClick {
    
    SHSchedualWeekView *weekView = [SHSchedualWeekView schedualWeekView:self.schedual];
 
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:weekView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];

    alertController.backgoundTapDismissEnable = YES; // 点击其它地方关闭
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 时间按钮
- (IBAction)timeButtonClick {
    
    CGFloat scale = [UIDevice is_iPad] ? 1.8 : 1.3;
    CGFloat moveMarign = pickerViewHeight * scale;
  
    if (self.baseTopConstraint.constant >= 0) {
        
        if (CGAffineTransformEqualToTransform(self.datePicker.transform, CGAffineTransformIdentity)) {
            self.datePicker.transform = CGAffineTransformMakeScale(scale, scale);
        }
        
        self.baseTopConstraint.constant -= moveMarign;
        self.settingViewTopConstraint.constant += moveMarign;
        
    } else {
        
        self.baseTopConstraint.constant += moveMarign;
        
        self.settingViewTopConstraint.constant -= moveMarign;
        
        self.datePicker.transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}


/// 执行频率点击
- (IBAction)frequencyButtonClick {
    
    __weak typeof(self) weakSelf = self;
    // 弹出日期选择
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:nil message:nil isCustom:YES];
    

    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.frequencyOnce style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [weakSelf setExecutionFrequency:SHSchdualFrequencyOneTime];
        
    }]];
    
    
    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.frequencyDaily style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [weakSelf setExecutionFrequency:SHSchdualFrequencyDayily];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.frequencyWeekly style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [weakSelf setExecutionFrequency:SHSchdualFrequencyWeekly];
        
    }]];
    
    
    
    [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.cancel style:TYAlertActionStyleCancel handler:nil]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 设置执行频率
- (void)setExecutionFrequency:(SHSchdualFrequency) frequencyID {

    self.schedual.frequencyID = frequencyID;
 
    self.datePicker.datePickerMode = (self.schedual.frequencyID == SHSchdualFrequencyOneTime) ? UIDatePickerModeDateAndTime : UIDatePickerModeTime;
    
    [self showTime];
    
    switch (self.schedual.frequencyID) {
            
        case SHSchdualFrequencyOneTime: {
            
            [self.frequencyButton setTitle:SHLanguageText.frequencyOnce forState:UIControlStateNormal];
        }
            break;
            
        case SHSchdualFrequencyDayily: {
            
            [self.frequencyButton setTitle:SHLanguageText.frequencyDaily forState:UIControlStateNormal];
        }
            break;
            
        case SHSchdualFrequencyWeekly: {
            
            [self.frequencyButton setTitle:SHLanguageText.frequencyWeekly forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    self.selectWeekButton.hidden = (self.schedual.frequencyID != SHSchdualFrequencyWeekly);
    
}

/// 声音按钮点击
- (IBAction)soundButtonClick {
    
    self.soundButton.selected = !self.soundButton.selected;
    
    self.schedual.haveSound = self.soundButton.selected;
    
    self.soundButton.selected ? ([[SoundTools shareSoundTools] playSoundWithName:@"schedulesound.wav"]) : ([[SoundTools shareSoundTools] stopSoundWithName:@"schedulesound.wav"]);
}

/// 保存数据
- (IBAction)saveButtonClick {
    
    // 1.处理名称
    if (![self processingSchedualName]) {
        
        [self.scheduleNameTextField becomeFirstResponder];
        
        return;
    }
    
    // 保存数据
    [[NSNotificationCenter defaultCenter]
        postNotificationName:SHSchedualSaveDataNotification
                      object:@(self.schedual.controlledItemID)
    ];
    
    if (self.isAddSedual) {  // 新增的
        
        [[SHSQLManager shareSQLManager] insertNewScheduale:self.schedual];
        
    } else { // 旧的 // 更新这个计划
        
        [[SHSQLManager shareSQLManager] updateSchedule:self.schedual];
    }
    
    // 更新
    [[SHSchedualExecuteTools shareSchedualExecuteTools] updateSchduals];
   
    [self.navigationController popViewControllerAnimated:YES];
}


/// 控制类型按钮点击
- (IBAction)controlItemButtonClick {
    
    self.controlItemListView.hidden = !self.controlItemListView.hidden;
}

/// 区域点击
- (IBAction)controlZoneButtonClick {
    
    self.controlZoneListView.hidden = !self.controlZoneListView.hidden;
}


// MARK: - UITextField 代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

/// 处理要保存的计划名称
- (BOOL)processingSchedualName {
    
    NSString *name = self.scheduleNameTextField.text;
    
    // 1.检查名字是否为空
    if (!name.length) {
        
        [SVProgressHUD showErrorWithStatus:@"The name cannot be empty!"];
        
        return NO;
    }
    
    // 2.检查名字是否有相同的
    NSMutableArray *allScheduales = [[SHSQLManager shareSQLManager] getAllSchdule];
    
    for (SHSchedual *schdeual in allScheduales) {
        
        // 不能和其他计划重名
        if ([schdeual.scheduleName isEqualToString:name] &&
            (schdeual.scheduleID != self.schedual.scheduleID)) {
            
            [SVProgressHUD showErrorWithStatus:@"The name has been saved!"];
            
            return NO;
        }
    }

    // 3.符合要求可以保存
    self.schedual.scheduleName = name;
    
    return YES;
}

// MARK: - 加载不同的区域及控制数据

/// 设置不同的区域的显示内容
- (void)setDifferentControlItemZoneView {

    switch (self.schedual.controlledItemID) {
        
            // Mood
        case SHSchdualControlItemTypeMood: {
        
            self.moodView.schedual = self.schedual;
        }
            break;
            
            // Light
        case SHSchdualControlItemTypeLight: {
        
            self.lightView.schedual = self.schedual;
        }
            break;
        
            // shade
        case SHSchdualControlItemTypeShade: {
        
            self.shadeView.schedual = self.schedual;
        }
            break;
            
        case SHSchdualControlItemTypeHVAC: {
        
            self.hvacView.schedual = self.schedual;
        }
            break;
            
        case SHSchdualControlItemTypeAudio: {
        
            self.audioView.schedual = self.schedual;
        }
            break;
            
        default:
            break;
    }
}

/// 设置区域界面
- (void)setControlZoneView {
    
    // 显示与隐藏其他的视图
    self.macroView.hidden = (self.schedual.controlledItemID != SHSchdualControlItemTypeMarco);
    self.moodView.hidden = (self.schedual.controlledItemID != SHSchdualControlItemTypeMood);
    self.lightView.hidden = (self.schedual.controlledItemID != SHSchdualControlItemTypeLight);
    self.hvacView.hidden = (self.schedual.controlledItemID != SHSchdualControlItemTypeHVAC);
    self.audioView.hidden = (self.schedual.controlledItemID != SHSchdualControlItemTypeAudio);
    self.shadeView.hidden = (self.schedual.controlledItemID != SHSchdualControlItemTypeShade);
    
    // 1.处理区域按钮
    self.controlZoneButton.userInteractionEnabled = (self.schedual.controlledItemID != SHSchdualControlItemTypeMarco);
    
    // 如果是宏命令
    if (self.schedual.controlledItemID == SHSchdualControlItemTypeMarco) {
        
        [self.controlZoneButton setTitle:@"None" forState:UIControlStateNormal];
        
        if (self.macroView == nil) {
            
            self.macroView = [SHSchduleMacroView schduleMacroView];
            
            [self.showControlScheduleView addSubview:self.macroView];
        }
        
        // 传递数据
        self.macroView.schedual = self.schedual;
        
        return;
    }
    
    // 如果是其它类型
    self.controlZoneButton.userInteractionEnabled = YES;
    
    // 查询具体这种类型的区域

    // 匹配不同的区域
    switch (self.schedual.controlledItemID) {
            
            // 场景
        case SHSchdualControlItemTypeMood: {
            
            if (self.moodView == nil) {
                self.moodView = [SHSchduleMoodView schduleMoodView];
                [self.showControlScheduleView addSubview:self.moodView];
            }
            
            // 匹配具有 MOOD 的区域
            self.allZones = [[SHSQLManager shareSQLManager] getZonesFor: SHSystemDeviceTypeMood];
        }
            break;
            
            // 灯泡
        case SHSchdualControlItemTypeLight: {
            
            if (self.lightView == nil) {
                self.lightView = [SHSchduleLightView schduleLightView];
                [self.showControlScheduleView addSubview:self.lightView];
            }
            
            // 匹配具有灯的区域
            self.allZones = [[SHSQLManager shareSQLManager] getZonesFor: SHSystemDeviceTypeLight];
        }
            break;
            
            // 空调
        case SHSchdualControlItemTypeHVAC: {
            
            if (self.hvacView == nil) {
                
                self.hvacView = [SHSchduleHVACView schduleHVACView];
                
                [self.showControlScheduleView addSubview:self.hvacView];
            }
            
            // 匹配具有灯的区域
            self.allZones = [[SHSQLManager shareSQLManager] getZonesFor: SHSystemDeviceTypeHvac];
        }
            break;
            
            // 音乐
        case SHSchdualControlItemTypeAudio: {
            
            if (self.audioView == nil) {
                
                self.audioView = [SHSchduleAudioView schduleAudioView];
                
                [self.showControlScheduleView addSubview:self.audioView];
            }
            
            self.allZones = [[SHSQLManager shareSQLManager] getZonesFor:SHSystemDeviceTypeAudio];
        }
            break;
            
            // 窗帘
        case SHSchdualControlItemTypeShade: {
            
            if (self.shadeView == nil) {
                
                self.shadeView = [SHSchduleShadeView schduleShadeView];
                
                [self.showControlScheduleView addSubview:self.shadeView];
            }
            
            self.allZones = [[SHSQLManager shareSQLManager] getZonesFor:SHSystemDeviceTypeShade];
        }
            break;
            
        default:
            break;
    }
    
    // 刷新区域列表
    [self.controlZoneListView reloadData];
    
    // 如果新增的，选择第一个，否则选择其它的
    if (self.isAddSedual) {
    
        // 默认选择一个
        [self tableView:self.controlZoneListView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    } else {
        
        // 找到数组中的序号
        [self.allZones enumerateObjectsUsingBlock:^(SHZone *zone, NSUInteger index, BOOL * _Nonnull stop) {
            
            if (zone.zoneID == self.schedual.zoneID) {
                
                // 选择指定的区域
                [self tableView:self.controlZoneListView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                
                *stop = YES;
            }
        }];
    }
}

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.controlItemListView) {
        
        self.schedual.controlledItemID = indexPath.row + 1;
        [self.controlItemButton setTitle:self.controlItems[indexPath.row] forState:UIControlStateNormal];
        
        tableView.hidden = YES;
    
        [self setControlZoneView];
    
    // 选择区域
    } else if (tableView == self.controlZoneListView) {
        
        [self.controlZoneButton setTitle:([self.allZones[indexPath.row] zoneName]) forState:UIControlStateNormal];
        
        SHZone *zone = self.allZones[indexPath.row];
        
        // 选择的区域
        self.schedual.zoneID = zone.zoneID;
        
        tableView.hidden = YES;
        
        // 针对不同的区域进行传值
        [self setDifferentControlItemZoneView];
    }
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.controlItemListView) {
        
        return self.controlItems.count;
        
    } else if (tableView == self.controlZoneListView) {
        
        return self.allZones.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.controlItemListView) {
        
        SHSchdualContolItemAndZoneCell *cell = [tableView dequeueReusableCellWithIdentifier: schdualContolItemAndZoneCellReusableIdentifier forIndexPath:indexPath];
        
        cell.controlItemName = self.controlItems[indexPath.row];
        
        return cell;
    
    } else if (tableView == self.controlZoneListView) {
        
        SHSchdualContolItemAndZoneCell *cell = [tableView dequeueReusableCellWithIdentifier: schdualContolItemAndZoneCellReusableIdentifier forIndexPath:indexPath];
        
        cell.currentZone = self.allZones[indexPath.row];
        
        return cell;
        
    }
    
    return nil;
}

// MARK: - 界面初始化

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.basseViewHeightConstraint.constant =  self.isPortrait ? (navigationBarHeight + statusBarHeight) : navigationBarHeight;
    }
    
    // 不同的控制项的显示
    self.macroView.frame = self.showControlScheduleView.bounds;
    self.moodView.frame = self.showControlScheduleView.bounds;
    self.lightView.frame = self.showControlScheduleView.bounds;
    self.hvacView.frame = self.showControlScheduleView.bounds;
    self.shadeView.frame = self.showControlScheduleView.bounds;
    self.audioView.frame = self.showControlScheduleView.bounds;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 选选中第一个
    [self tableView:self.controlItemListView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [self setExecutionFrequency:self.schedual.frequencyID];
    
    // 选择其它的
    if (self.schedual.controlledItemID != SHSchdualControlItemTypeMarco && !self.isAddSedual) {
        
        // 获得指定的zone
        for (NSUInteger i = 0; i < self.allZones.count; i++) {
            
            if ([self.allZones[i] zoneID] == self.schedual.zoneID) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                
                [self.controlZoneListView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                
                [self tableView:self.controlZoneListView didSelectRowAtIndexPath:indexPath];
                
                break;
            }
        }
    }
    
    // 3. 是否有声音
    self.soundButton.selected = self.schedual.haveSound;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self suitText];
    
    [self initTableView];
}

/// 显示时间
- (void)showTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (self.schedual.frequencyID) {
            
            // 只执行一次 - 默认值
        case SHSchdualFrequencyOneTime: {
            
            dateFormatter.dateFormat = @"MM-dd HH:mm";
            
            self.schedual.executionDate = [dateFormatter stringFromDate:self.datePicker.date];
            
            [self.timeButton setTitle:[dateFormatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
        }
            break;
            
            // 每天
        case SHSchdualFrequencyDayily: {
            
            dateFormatter.dateFormat = @"HH:mm";
            
            self.schedual.executionDate = [dateFormatter stringFromDate:self.datePicker.date];
            
            [self.timeButton setTitle:[dateFormatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
        }
            break;
            
            // 每周
        case SHSchdualFrequencyWeekly: {
            
            dateFormatter.dateFormat = @"HH:mm";
            
            [self.timeButton setTitle:[dateFormatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
            
            NSDateComponents *comps = [NSDate getCurrentDateComponentsFrom:self.datePicker.date];
            
            self.schedual.executionHours = comps.hour;
            self.schedual.executionMins = comps.minute;
            
            self.schedual.executionDate = [NSString stringWithFormat:@"%02d:%02d", self.schedual.executionHours , self.schedual.executionMins];
            
        }
            break;
            
        default:
            break;
    }
}


/// 适配文字
- (void)suitText {
    
 
    self.navigationItem.title = self.isAddSedual ? (SHLanguageText.newSchedual) :([[SHLanguageTools shareLanguageTools] getTextFromPlist:@"SCHEDULE" withSubTitle:@"EDIT_SCHEDULE"]);
    
    [self.scheduleNameTextField setRoundedRectangleBorder];
    self.scheduleNameTextField.text = self.isAddSedual ?  ([[SHLanguageTools shareLanguageTools] getTextFromPlist:@"SCHEDULE" withSubTitle:@"SCHEDULE_NAME"]) : self.schedual.scheduleName;
    
    
    self.controlItemLabel.text = [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"SCHEDULE" withSubTitle:@"CONTROLLED_ITEM"];
    
    self.controlZoneLabel.text = [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"Z_AUDIO" withSubTitle:@"ZONE_LIST"];
    
    self.frequencyLabel.text = [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"SCHEDULE" withSubTitle:@"FREQUENCY"];
    
    [self.soundButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"SCHEDULE" withSubTitle:@"ALARM_CLOCK_BELL"] forState:UIControlStateNormal];
    
    [self.saveButton setTitle:SHLanguageText.saved forState:UIControlStateNormal];
    
    self.controlZoneButton.titleLabel.numberOfLines = 0;
    self.controlZoneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.timeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timeButton.titleLabel.numberOfLines = 0;
    
    [self.datePicker setValue:[UIView textWhiteColor] forKey:@"textColor"];
    
    [self.controlItemButton setRoundedRectangleBorder];
    [self.controlZoneButton setRoundedRectangleBorder];
    [self.timeButton setRoundedRectangleBorder];
    [self.frequencyButton setRoundedRectangleBorder];
    [self.selectWeekButton setRoundedRectangleBorder];
    [self.soundButton setRoundedRectangleBorder];
    [self.saveButton setRoundedRectangleBorder];
    
    if (self.isAddSedual) {
        
        self.datePicker.date = [NSDate date];
        
    } else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        switch (self.schedual.frequencyID) {
                
                // 只执行一次 - 默认值
            case SHSchdualFrequencyOneTime: {
                
                dateFormatter.dateFormat = @"MM-dd HH:mm";
                
                self.datePicker.date = [dateFormatter dateFromString:self.schedual.executionDate];
            }
                break;
                
                // 每天
            case SHSchdualFrequencyDayily: {
                
                dateFormatter.dateFormat = @"HH:mm";
                
                self.datePicker.date = [dateFormatter dateFromString:self.schedual.executionDate];
                
            }
                break;
                
                // 每周
            case SHSchdualFrequencyWeekly: {
             
                dateFormatter.dateFormat = @"HH:mm";
                
                NSString *timeString = [NSString stringWithFormat:@"%02d:%02d", self.schedual.executionHours, self.schedual.executionMins];
                
                self.datePicker.date = [dateFormatter dateFromString:timeString];
            }
                break;
                
            default:
                break;
        }
    }
    
    if ([UIDevice is_iPad]) {
    
        self.scheduleNameTextField.font = [UIView suitFontForPad];
        self.controlItemLabel.font = [UIView suitFontForPad];
        self.controlZoneLabel.font = [UIView suitFontForPad];
        self.frequencyLabel.font = [UIView suitFontForPad];
    }
}

/// 初始化列表
- (void)initTableView {
    
    [self.controlZoneListView registerNib:[UINib nibWithNibName: schdualContolItemAndZoneCellReusableIdentifier bundle:nil] forCellReuseIdentifier: schdualContolItemAndZoneCellReusableIdentifier];
    
    self.controlZoneListView.rowHeight = [SHSchdualContolItemAndZoneCell rowHeight];
  
    self.controlZoneListView.hidden = YES;
    
    [self.controlItemListView registerNib:[UINib nibWithNibName:schdualContolItemAndZoneCellReusableIdentifier bundle:nil] forCellReuseIdentifier:schdualContolItemAndZoneCellReusableIdentifier];
    
    self.controlItemListView.rowHeight = [SHSchdualContolItemAndZoneCell rowHeight];
    
    self.controlItemListView.hidden = YES;
}

 
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - getter && setter

/// 所有的控制项
- (NSMutableArray *)controlItems {
    
    if (!_controlItems) {
        
        _controlItems = [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"REMAINING" withSubTitle:@"SCHEDULE_CONTROLLED_ITEM"];
    }
    
    return _controlItems;
}

@end
