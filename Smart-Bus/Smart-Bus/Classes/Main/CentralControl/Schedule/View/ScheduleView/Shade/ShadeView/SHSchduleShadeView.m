//
//  SHSchduleShadeView.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchduleShadeView.h"
#import "SHSchduleShadeCell.h"

@interface SHSchduleShadeView  () <UITableViewDataSource, UITableViewDelegate, SHEditRecordShadeStatusDelegate>

/// 窗帘列表
@property (weak, nonatomic) IBOutlet UITableView *shadeListView;

/// 所有的窗帘
@property (nonatomic, strong) NSMutableArray *allShades;

@end

@implementation SHSchduleShadeView

/// 保存窗帘
- (void)saveShade:(NSNotification *)notification {
    
    SHSchdualControlItemType controlItemType = [notification.object integerValue];
    
    if (controlItemType == SHSchdualControlItemTypeShade) {
        
        [[SHSQLManager shareSQLManager] deleteSchedualeCommand:self.schedual];
       
        for (SHShade *shade in self.allShades) {
            
            SHSchedualCommand *command = [[SHSchedualCommand alloc] init];
            
            command.typeID = SHSchdualControlItemTypeShade;
            command.scheduleID = self.schedual.scheduleID;
            
            command.parameter1 = shade.shadeID; // 窗帘ID
            command.parameter2 = shade.zoneID; // 备用
            command.parameter3 = shade.currentStatus; // 窗帘状态

            [[SHSQLManager shareSQLManager] insertNewSchedualeCommand:command];
        }
    }
}

// MARK: - 设置窗帘的状态代理

- (void)editShade:(SHShade *)shade currentStatus:(NSString *)status {
    
    for (SHShade *currentShade in self.allShades) {
        
        if (currentShade.shadeID == shade.shadeID && currentShade.subnetID == shade.subnetID && currentShade.deviceID == shade.deviceID) {
            
            if ([status isEqualToString: [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_OPEN"]]) {
                
                currentShade.currentStatus = SHShadeStatusOpen;
                
            } else if ([status isEqualToString:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MOOD_IN_ZONE" withSubTitle:@"SHADE_CLOSE"]]) {
                
                currentShade.currentStatus = SHShadeStatusClose;
                
            } else {
                
                currentShade.currentStatus = SHShadeStatusUnKnow;
            }
        }
    }
}

- (void)setSchedual:(SHSchedual *)schedual {
    
    _schedual = schedual;
    
    self.allShades = [[SHSQLManager shareSQLManager] getShadeForZone:schedual.zoneID];
    
    [self.shadeListView reloadData];
    
    if (!self.allShades.count) {
        
        [SVProgressHUD showInfoWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"NO_DATA"]];
        
        return;
    }
    
   
    NSMutableArray *commands = [[SHSQLManager shareSQLManager] getSchedualCommands:schedual.scheduleID];
    
    if (!commands.count) {
        return;
    }
    
    // 设置状态
    for (SHSchedualCommand *command in commands) {
        
        for (SHShade *shade in self.allShades) {
            
            if (shade.shadeID == command.parameter1 && shade.zoneID == command.parameter2) {
                
                shade.currentStatus = command.parameter3;
            }
        }
    }
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allShades.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHSchduleShadeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHSchduleShadeCell class]) forIndexPath:indexPath];
    
    cell.shade = self.allShades[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

// MARK: - UI 设置

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.shadeListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHSchduleShadeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHSchduleShadeCell class])];
    
    self.shadeListView.rowHeight = [SHSchduleShadeCell rowHeightForShadeCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveShade:) name:SHSchedualSaveDataNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// shade
+ (instancetype)schduleShadeView {
    
    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

@end
