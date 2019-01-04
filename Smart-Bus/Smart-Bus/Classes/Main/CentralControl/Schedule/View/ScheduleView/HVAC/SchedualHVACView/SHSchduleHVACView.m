//
//  SHSchduleHVACView.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchduleHVACView.h"
#import "SHSchedualHVACCell.h"

/// cell重用标示符
static NSString *schedualHVACCellReuseIdentifier = @"SHSchedualHVACCell";

@interface SHSchduleHVACView () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

/// 所有的空调
@property (nonatomic, strong) NSMutableArray *allHVACs;

/// 所有的空调列表
@property (weak, nonatomic) IBOutlet UITableView *allHVACListView;

@end

@implementation SHSchduleHVACView

// MARK: - 保存数据

/// 保存数据
- (void)saveHVAC:(NSNotification *)notification {
    
    SHSchdualControlItemType controlItemType = [notification.object integerValue];
    
    if (controlItemType == SHSchdualControlItemTypeHVAC) {
        
        // 删除数据
        [[SHSQLManager shareSQLManager] deleteSchedualeCommand:self.schedual];
        
        for (SHHVAC *hvac in self.allHVACs) {
            
            // 启用了计划的才保存
            if (hvac.schedualEnable) {
                
                SHSchedualCommand *command = [[SHSchedualCommand alloc] init];
                
                command.scheduleID = self.schedual.scheduleID;
                command.typeID = SHSchdualControlItemTypeHVAC;
                
                command.parameter1 = hvac.subnetID; // 子网ID
                command.parameter2 = hvac.deviceID; // 设备ID
                
                command.parameter3 = hvac.schedualIsTurnOn; // 开关
                command.parameter4 = hvac.schedualFanSpeed; // 风速
                command.parameter5 = hvac.schedualMode; // 模式
                
                // 模式温度 -> 具体是哪种模式温度 取决于 parameter5
                command.parameter6 = hvac.schedualTemperature;
                
                // 存入数据库
                [[SHSQLManager shareSQLManager] insertNewSchedualeCommand:command];
            }
        }
    }
}

    
- (void)setSchedual:(SHSchedual *)schedual {
    
    _schedual = schedual;
    
    // 获得所有的空调
    if (schedual.isDifferentZoneSchedual ||( !self.allHVACs.count && !schedual.isDifferentZoneSchedual)) {
        
        self.allHVACs = [[SHSQLManager shareSQLManager] getHVACForZone:schedual.zoneID];
        
        // 将schedual中的状态来进行设置
        NSMutableArray *schedualCommandforHVACs = [[SHSQLManager shareSQLManager] getSchedualCommands:schedual.scheduleID];
        
        for (SHHVAC *hvac in self.allHVACs) {
            
            for (SHSchedualCommand *command in schedualCommandforHVACs) {
                
                if (command.typeID != SHSchdualControlItemTypeHVAC) {
                    continue;
                }
                
                // 找到具体的设备
                if (command.parameter1 == hvac.subnetID &&
                    command.parameter2 == hvac.deviceID) {
                    
                    hvac.schedualEnable = YES;
                    
                    hvac.schedualIsTurnOn = command.parameter3;
                    hvac.schedualFanSpeed = command.parameter4;
                    hvac.schedualMode = command.parameter5;
                    hvac.schedualTemperature = command.parameter6;
                }
            }
        }

    }
    
    [self.allHVACListView reloadData];
}
    

// MARK: - 数据源

/// 一共有多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allHVACs.count;
}

/// 显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHSchedualHVACCell *cell = [tableView dequeueReusableCellWithIdentifier:schedualHVACCellReuseIdentifier forIndexPath:indexPath];
    
    cell.schedualHVAC = self.allHVACs[indexPath.row];
    
    return cell;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 增加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveHVAC:) name:SHSchedualSaveDataNotification object:nil];
    
    self.allHVACListView.rowHeight = [SHSchedualHVACCell rowHeightForSchedualHVACCell];
    
    // 注册
    [self.allHVACListView registerNib:[UINib nibWithNibName:schedualHVACCellReuseIdentifier bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHSchedualHVACCell class])];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// HVAC
+ (instancetype)schduleHVACView {
    
    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

@end
