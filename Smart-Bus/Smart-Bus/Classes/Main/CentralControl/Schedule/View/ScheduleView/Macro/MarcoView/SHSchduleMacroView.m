//
//  SHSchduleMacroView.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHSchduleMacroView.h"

static NSString *schduleMacroCellReuseIdentifier =
    @"SHSchduleMacroCell";

@interface SHSchduleMacroView () <UITableViewDelegate, UITableViewDataSource>

/// 宏列表
@property (weak, nonatomic) IBOutlet UITableView *marcoListView;

/// 所有的宏命令
@property (strong, nonatomic) NSMutableArray *allMacros;

/// 当前修改的宏命令
@property (strong, nonatomic) SHMacro *selectMacro;

@end

@implementation SHSchduleMacroView

/// 保存数据
- (void)saveMacro:(NSNotification *)notification {

    SHSchdualControlItemType controlItemType = [notification.object integerValue];
  
    if (controlItemType == SHSchdualControlItemTypeMarco) {
        
        if (!self.selectMacro) {  // 没有选中不保存
            
            return;
        }
        
        // 1.先删除以前的命令
        [[SHSQLManager shareSQLManager] deleteSchedualeCommand:self.schedual];
        
        // 保存到数据库
        SHSchedualCommand *command = [[SHSchedualCommand alloc] init];
        
        command.typeID = SHSchdualControlItemTypeMarco;
        command.scheduleID = self.schedual.scheduleID;
        command.parameter1 = self.selectMacro.macroID; 
        
        [[SHSQLManager shareSQLManager] insertNewSchedualeCommand:command];
    }
}

/// 设置模型
- (void)setSchedual:(SHSchedual *)schedual {

    _schedual = schedual;
    
    // 查询所有的宏按钮
    self.allMacros = [[SHSQLManager shareSQLManager] getAllCentralMacros];
    
    [self.marcoListView reloadData];
    
    // 没有宏命令
    if (!self.allMacros.count) {
         
        [SVProgressHUD showInfoWithStatus: SHLanguageText.noData];
        
        return;
    }
    
    // 查找要的计划具体的指令
    SHSchedualCommand *command = [[[SHSQLManager shareSQLManager] getSchedualCommands:self.schedual.scheduleID] lastObject];
    
    if (!command) {  // 新增的，还不存在
        return;
    }
    
    for (SHMacro *macro in self.allMacros) {
        
        if (macro.macroID == command.parameter1) {
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:macro.macroID - 1 inSection:0];
            
            [self.marcoListView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            [self tableView:self.marcoListView didSelectRowAtIndexPath:index];
        }
    }
}


// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SHMacro *macro = self.allMacros[indexPath.row];
    
    self.selectMacro = macro;
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allMacros.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SHSchduleMacroCell *cell = [tableView dequeueReusableCellWithIdentifier:schduleMacroCellReuseIdentifier forIndexPath:indexPath];
    
    cell.macro = self.allMacros[indexPath.row];
    
    return cell;
}

// MARK: - UI 设置

- (void)awakeFromNib {

    [super awakeFromNib];
   
    [self.marcoListView registerNib:[UINib nibWithNibName:schduleMacroCellReuseIdentifier bundle:nil] forCellReuseIdentifier:schduleMacroCellReuseIdentifier];

    self.marcoListView.rowHeight =
        [SHSchduleMacroCell rowHeight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMacro:) name:SHSchedualSaveDataNotification object:nil];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 宏命令
+ (instancetype)schduleMacroView {

    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

// MARK: - getter && setter


@end
