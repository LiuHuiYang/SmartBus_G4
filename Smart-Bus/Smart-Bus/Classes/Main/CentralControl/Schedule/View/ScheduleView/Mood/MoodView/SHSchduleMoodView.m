//
//  SHSchduleMoodView.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchduleMoodView.h"


static NSString * schduleMoodCellReuseIdentifier =
    @"SHSchduleMoodCell";

@interface SHSchduleMoodView () <UITableViewDelegate, UITableViewDataSource>

/// 颜色
@property (weak, nonatomic) IBOutlet UITableView *moodListView;

/// 所有的音乐
@property (strong, nonatomic) NSMutableArray *allMoods;

/// 当前修改的宏命令
@property (strong, nonatomic) SHMood *selectMood;

@end

@implementation SHSchduleMoodView


/// 保存数据
- (void)saveMood:(NSNotification *)notification {
    
    SHSchdualControlItemType controlItemType = [notification.object integerValue];
    
    if (controlItemType == SHSchdualControlItemTypeMood) {
        
        if (!self.selectMood) {  // 没有选中不保存
            
            return;
        }
        
        // 1.先删除以前的命令
        [[SHSQLManager shareSQLManager] deleteSchedualeCommand:self.schedual];
        
        // 保存到数据库
        SHSchedualCommand *command = [[SHSchedualCommand alloc] init];
        
        command.typeID = SHSchdualControlItemTypeMood;
        command.scheduleID = self.schedual.scheduleID;
        command.parameter1 = self.selectMood.moodID;
        command.parameter2 = self.selectMood.zoneID; // 备用
        
        [[SHSQLManager shareSQLManager] insertNewSchedualeCommand:command];
    }
}


/// 设置模型
- (void)setSchedual:(SHSchedual *)schedual {
    
    _schedual = schedual;
    
    // 查询所有的Mood
    self.allMoods = [[SHSQLManager shareSQLManager] getAllMoodFor:self.schedual.zoneID];
    
    [self.moodListView reloadData];
    
    if (!self.allMoods.count) {
        
        [SVProgressHUD showInfoWithStatus:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"NO_DATA"]];
        
        return;
    }
    
    // 查找要的计划具体的指令
    SHSchedualCommand *command = [[[SHSQLManager shareSQLManager] getSchedualCommands:self.schedual.scheduleID] lastObject];
    
    if (!command) {  // 新增的，还不存在
        return;
    }
    
    for (SHMood *mood in self.allMoods) {
        
        if (command.parameter1 == mood.moodID && command.parameter2 == mood.zoneID) {
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:mood.moodID - 1 inSection:0];
            
            [self.moodListView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            [self tableView:self.moodListView didSelectRowAtIndexPath:index];
            
        }
    }
}


// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMood *mood = self.allMoods[indexPath.row];
    
    self.selectMood = mood;
}


// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allMoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHSchduleMoodCell *cell = [tableView dequeueReusableCellWithIdentifier:schduleMoodCellReuseIdentifier forIndexPath:indexPath];
    
    cell.mood = self.allMoods[indexPath.row];
    
    return cell;
}

// MARK: - UI 设置

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.moodListView registerNib:[UINib nibWithNibName:schduleMoodCellReuseIdentifier bundle:nil] forCellReuseIdentifier:schduleMoodCellReuseIdentifier];

    self.moodListView.rowHeight = [SHSchduleMoodCell rowHeight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMood:) name:SHSchedualSaveDataNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// mood
+ (instancetype)schduleMoodView {
    
    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

@end
