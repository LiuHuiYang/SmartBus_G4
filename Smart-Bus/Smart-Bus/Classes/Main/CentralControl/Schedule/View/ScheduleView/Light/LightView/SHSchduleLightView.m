//
//  SHSchduleLightView.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchduleLightView.h"

/// 计划light重用标示
static NSString *schduleLightCellReuseIdentifier = @"SHSchduleLightCell";

@interface SHSchduleLightView () <UITableViewDelegate, UITableViewDataSource>

/// 灯光列表
@property (weak, nonatomic) IBOutlet UITableView *lightsListView;

/// 所有的灯泡
@property (strong, nonatomic) NSMutableArray *allLights;

@end

@implementation SHSchduleLightView


/// 保存数据
- (void)saveLight:(NSNotification *)notification {

    SHSchdualControlItemType controlItemType = [notification.object integerValue];
    
    if (controlItemType == SHSchdualControlItemTypeLight) {
        
        // 删除数据
        [[SHSQLManager shareSQLManager] deleteSchedualeCommand:self.schedual];
        
        // 获得状态
        for (SHLight *light in self.allLights) {
            
            if (light.schedualEnable) {
                
                SHSchedualCommand *command = [[SHSchedualCommand alloc] init];
                command.scheduleID = self.schedual.scheduleID;
                command.typeID = SHSchdualControlItemTypeLight;
                command.parameter1 = light.lightID; // 灯号
                command.parameter2 = self.schedual.zoneID; // 区号
                
                if (light.lightTypeID != SHZoneControlLightTypeLed) {
                    
                    command.parameter3 = light.schedualBrightness;
                    
                } else {  // LED
                    
                    command.parameter3 = light.schedualRedColor;
                    command.parameter4 = light.schedualGreenColor;
                    command.parameter5 = light.schedualBlueColor;
                    command.parameter6 = light.schedualWhiteColor;
                }
                
                // 存入数据库
                [[SHSQLManager shareSQLManager] insertNewSchedualeCommand:command];

            }
        }
    }
}


/// 设置模型
- (void)setSchedual:(SHSchedual *)schedual {
    
    _schedual = schedual;
    

    // 获得所有的light
    
    // 这个条件表达式是判断是从数据库还是从内存中获得相关的数据
    if (schedual.isDifferentZoneSchedual || (!self.allLights.count && !schedual.isDifferentZoneSchedual)) {
        
        self.allLights = [[SHSQLManager shareSQLManager] getLightForZone:schedual.zoneID];
        
        // 将schedual中的状态来进行设置
        NSMutableArray *schedualCommandforLights = [[SHSQLManager shareSQLManager] getSchedualCommands:schedual.scheduleID];
        
        // 设置状态
        for (SHLight *light in self.allLights) {
            
            for (SHSchedualCommand *command in schedualCommandforLights) {
                
                if (command.typeID != SHSchdualControlItemTypeLight) {
                    continue;
                }
                
                // 找到具体的设备
                if (light.lightID == command.parameter1 && light.zoneID == command.parameter2) {
                    
                    // 只要是存在的命令就一定是选中的
                    light.schedualEnable = YES;
                    
                    if (light.lightTypeID == SHZoneControlLightTypeLed) {
                        
                        light.schedualRedColor = command.parameter3;
                        light.schedualGreenColor = command.parameter4;
                        light.schedualBlueColor = command.parameter5;
                        light.schedualWhiteColor = command.parameter6;
                        
                    } else {
                        
                        light.schedualBrightness = command.parameter3;
                    }
                }
            }
        }
    }
    
    [self.lightsListView reloadData];
    
}

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allLights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHSchduleLightCell *cell = [tableView dequeueReusableCellWithIdentifier:schduleLightCellReuseIdentifier forIndexPath:indexPath];
    
    cell.light = self.allLights[indexPath.row];
    
    return cell;
}

// MARK: - UI 设置

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 注册cell
    [self.lightsListView registerNib:[UINib nibWithNibName:schduleLightCellReuseIdentifier bundle:nil] forCellReuseIdentifier:schduleLightCellReuseIdentifier];
    
    // 设置行高
    self.lightsListView.rowHeight = [SHSchduleLightCell rowHeight];
    
    self.lightsListView.allowsMultipleSelection = YES;
    
    // 增加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLight:) name:SHSchedualSaveDataNotification object:nil];

}



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// lightView
+ (instancetype)schduleLightView {
    
    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

@end
