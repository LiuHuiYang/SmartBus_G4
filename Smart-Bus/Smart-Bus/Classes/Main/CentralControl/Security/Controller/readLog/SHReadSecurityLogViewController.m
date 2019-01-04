//
//  SHReadSecurityLogViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/15.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHReadSecurityLogViewController.h"

/// 安防日志重用标示
static NSString *securityLogcellReuseIdentifier = @"SHSecurityLogCell";

@interface SHReadSecurityLogViewController () <UITableViewDataSource>


/// 清除按钮
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;

/// 读取按钮
@property (weak, nonatomic) IBOutlet UIButton *readButton;

/// 开始日期按钮
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;

/// 结束日期按钮
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;

/// 选择的按钮
@property (weak, nonatomic) UIButton *selectButton;

/// 控制按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlButtonHeightConstraint;

/// 日期选择器的顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerTopConstraint;

/// 日期选择
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

/// 日期格式化字符串
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

/// 所有的历史记录
@property (strong, nonatomic) NSMutableArray *securityLogs;

//// 日志历表
@property (weak, nonatomic) IBOutlet UITableView *logListView;

@end

@implementation SHReadSecurityLogViewController


// MARK: - 数据解析

- (void)analyzeReceivedSocketData:(SHSocketData *)socketData {
    
    if (socketData.subNetID != self.securityZone.subnetID ||
        socketData.deviceID != self.securityZone.deviceID) {
        return;
    }
    
    NSUInteger count = socketData.additionalData.count;
    Byte recivedData[count];
    
    for (int i = 0; i < count; i++) {
        
        recivedData[i] =
        ([socketData.additionalData[i] integerValue]) & 0xFF;
    }
    
    // 解析数据
    switch (socketData.operatorCode) {
            
            // 获得历史记录的数量
        case 0x0139: {
            
            [self readLogData:recivedData[0] startIndexlow:recivedData[1] indexHigh:recivedData[2] indexLow:recivedData[3]];
        }
            
            break;
            
            // 获得查询的历史记录
        case 0x013B: {
            
            if (recivedData[9] != 0xF8) {
                return;
            }
            
            SHSecurityLog *log = [[SHSecurityLog alloc] init];
            
            log.logNumber = recivedData[1] * 256 + recivedData[2];
            log.areaNumber = recivedData[3];
            log.securityTypeName = [NSString stringWithFormat:@"%d-%02d-%02d/%02d:%02d:%02d", recivedData[4], recivedData[5], recivedData[6], recivedData[7], recivedData[8], recivedData[9]];
            log.subNetID = recivedData[10];
            log.deviceID = recivedData[11];
            log.securityType = recivedData[12];
            log.channelNumber = recivedData[13];
            NSData *data = [NSData dataWithBytes:&(recivedData[14]) length:20];
            log.remark = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
            
            // 只有是这个区域的才添加
            if (log.areaNumber == self.securityZone.zoneID) {
                
                [self.securityLogs addObject:log];
                
                [self.logListView reloadData];
            }
        }
            break;
            
        case 0x014B: {
            
            if (recivedData[0] == 0xF8 && recivedData[1] == 0) {
                
                [self.securityLogs removeAllObjects];
                [self.logListView reloadData];
                
                [SVProgressHUD showSuccessWithStatus:@"Clear history success"];
            }
        }
            break;
            
        default:
            break;
    }
}



// MARK: - 事件处理

/// 开始日期选择
- (IBAction)startDateButtonClick {
    
    if (self.selectButton != self.startDateButton) {
        
        self.selectButton.selected = NO;
    }
    
    self.startDateButton.selected = !self.startDateButton.selected;
    
    self.startDateButton.selected ? [self showDatePicker] : [self hideDatePicker];
    
    if (self.startDateButton.selected) {
        
        self.selectButton = self.startDateButton;
    }
}

/// 结束日期选择
- (IBAction)endDateButtonClick {
    
    if (self.selectButton != self.endDateButton) {
        
        self.selectButton.selected = NO;
    }
    
    self.endDateButton.selected = !self.endDateButton.selected;
    
    self.endDateButton.selected ? [self showDatePicker] : [self hideDatePicker];
    
    if (self.endDateButton.selected) {
        
        self.selectButton = self.endDateButton;
    }
}

/// 读取日志
- (IBAction)readLogButtonClick {
    
    [self hideDatePicker];
    [self readLogTotals];
}

/// 读取历史记录总数
- (void)readLogTotals {

    NSArray *startDate = [self.startDateButton.currentTitle componentsSeparatedByString:@"-"];
    NSArray *endDate = [self.endDateButton.currentTitle componentsSeparatedByString:@"-"];
    
    NSArray *readLogData =
        @[ @([[startDate objectAtIndex:0] integerValue] % 100),
           @([[startDate objectAtIndex:1] integerValue]),
           @([[startDate objectAtIndex:2] integerValue]),
    
           @([[endDate objectAtIndex:0] integerValue] % 100),
           @([[endDate objectAtIndex:1] integerValue]),
           @([[endDate objectAtIndex:2] integerValue])
    ];
    
    [SHSocketTools sendDataWithOperatorCode:0x0138
                                   subNetID:self.securityZone.subnetID
                                   deviceID:self.securityZone.deviceID
                             additionalData:readLogData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
     ];
}


/**
 读取最终的历史记录数据

 @param startIndexHigh 历史记录开始位置高八位
 @param startIndexlow 历史记录开始位置低八位
 @param indexHigh 序号高八位
 @param indexLow 序号低八位
 */
- (void)readLogData:(Byte)startIndexHigh startIndexlow:(Byte)startIndexlow indexHigh:(Byte)indexHigh indexLow:(Byte)indexLow {
    
    NSArray *startDate = [self.startDateButton.currentTitle componentsSeparatedByString:@"-"];
    NSArray *endDate = [self.endDateButton.currentTitle componentsSeparatedByString:@"-"];
    
    NSArray *logData = @[ @([[startDate objectAtIndex:0] integerValue] % 100),
                          @([[startDate objectAtIndex:1] integerValue]),
                          @([[startDate objectAtIndex:2] integerValue]),
    
                          @([[endDate objectAtIndex:0] integerValue] % 100),
                          @([[endDate objectAtIndex:1] integerValue]),
                          @([[endDate objectAtIndex:2] integerValue]),
    
                          @(startIndexHigh),
                          @(startIndexlow),
                          @(indexHigh),
                          @(indexLow)
                        ];
    
    [SHSocketTools sendDataWithOperatorCode:0x013A
                                   subNetID:self.securityZone.subnetID
                                   deviceID:self.securityZone.deviceID
                             additionalData:logData
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
}

/// 清除日志
- (IBAction)cleanLogButtonClick {
    
    [self hideDatePicker];
    
    NSArray *clean = @[@(0xF8), @(1), @(1), @(1), @(1), @(1), @(1)];
    
    [SHSocketTools sendDataWithOperatorCode:0x014A
                                   subNetID:self.securityZone.subnetID
                                   deviceID:self.securityZone.deviceID
                             additionalData:clean
                           remoteMacAddress:SHSocketTools.remoteControlMacAddress
                                 needReSend:true
                                      isDMX:false
    ];
}


/// 选择日期
- (IBAction)selectDate {
 
    [self.selectButton setTitle:([NSString stringWithFormat:@"%@\n %@", (self.selectButton == self.startDateButton ? @"Start Date" : @"End Date") ,[self.dateFormatter stringFromDate:self.datePicker.date]]) forState:UIControlStateNormal];
}

/// 显示日期选择器
- (void)showDatePicker {
    
    CGFloat scale = [UIDevice is_iPad] ? 1.8 : 1.2;

    if (CGAffineTransformEqualToTransform(self.datePicker.transform, CGAffineTransformIdentity)) {
        self.datePicker.transform = CGAffineTransformMakeScale(scale, scale);
    }

    self.logListView.hidden = YES;
    if (!self.datePickerTopConstraint.constant) {

        self.datePickerTopConstraint.constant -= self.datePicker.frame_height;

        [UIView animateWithDuration:0.3 animations:^{
             [self.view layoutIfNeeded];
            
        }];
    }
}

/// 隐藏日期选择器
- (void)hideDatePicker {
    
    self.selectButton.selected = NO;
    self.selectButton = nil;
    self.logListView.hidden = NO;
    
    if (self.datePickerTopConstraint.constant) {
     
        self.datePickerTopConstraint.constant = 0;
        self.datePicker.transform = CGAffineTransformIdentity;
 
        [UIView animateWithDuration:0.3 animations:^{
             [self.view layoutIfNeeded];
            
        }];
    }
}


// 测试数据  -- 日志历史记录
//- (void)viewDidAppear:(BOOL)animated {
//
//    [super viewDidAppear:animated];
//    
//    for (int i = 0; i < 6; i++) {
//        
//        SHSecurityLog *log = [[SHSecurityLog alloc] init];
//        
//        log.logNumber = 100 + i + 1;
//        log.areaNumber = i + 1;
//        log.securityTime = @"2017-11-15 15:46:08";
//        log.subNetID = self.securityZone.subnetID;
//        log.deviceID = self.securityZone.deviceID;
//        log.securityType = i;
//        log.channelNumber = self.securityZone.zoneID;
//        log.remark = @"hello";
//        
//        [self.securityLogs addObject:log];
//    }
//    
//    [self.logListView reloadData];
//}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.securityLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SHSecurityLogCell *cell = [tableView dequeueReusableCellWithIdentifier:securityLogcellReuseIdentifier forIndexPath:indexPath];
    
    cell.securityLog = self.securityLogs[indexPath.row];
    
    return cell;
}

// MARK : - UI加载

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.controlButtonHeightConstraint.constant = navigationBarHeight + statusBarHeight;
    }
}

// 加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Security Log";
   
    // 时间
    self.datePicker.date = [NSDate date];
    [self.datePicker setValue:[UIView textWhiteColor] forKey:@"textColor"];

    self.startDateButton.titleLabel.numberOfLines = 0;
    self.endDateButton.titleLabel.numberOfLines = 0;
    self.startDateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.endDateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.startDateButton setTitle:[NSString stringWithFormat:@"Start Date \n %@", [self.dateFormatter stringFromDate:self.datePicker.date]] forState:UIControlStateNormal];
    
    [self.endDateButton setTitle:([NSString stringWithFormat:@"End Date \n %@", [self.dateFormatter stringFromDate:self.datePicker.date]]) forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.datePicker];

    // 日志列表
    self.logListView.backgroundColor = [UIColor clearColor];
    
    [self.logListView registerNib:[UINib nibWithNibName:securityLogcellReuseIdentifier bundle:nil] forCellReuseIdentifier:securityLogcellReuseIdentifier];
    
    self.logListView.rowHeight = [SHSecurityLogCell rowHeight];
    
    self.logListView.hidden = YES;
    
    [self.startDateButton setRoundedRectangleBorder];
    [self.endDateButton setRoundedRectangleBorder];
    [self.readButton setRoundedRectangleBorder];
    [self.cleanButton setRoundedRectangleBorder];
    
    if ([UIDevice is_iPad]) {
        
        self.startDateButton.titleLabel.font = [UIView suitFontForPad];
        self.endDateButton.titleLabel.font = [UIView suitFontForPad];
        self.readButton.titleLabel.font = [UIView suitFontForPad];
        self.cleanButton.titleLabel.font = [UIView suitFontForPad];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// MARK: - getter && setter

- (NSMutableArray *)securityLogs {

    if (!_securityLogs) {
        _securityLogs = [NSMutableArray array];
    }
    return _securityLogs;
}

- (NSDateFormatter *)dateFormatter {

    if (!_dateFormatter) {
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

@end
