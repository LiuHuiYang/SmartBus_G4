//
//  SHMediaSATCategoryViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/28.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHMediaSATCategoryViewController.h"

@interface SHMediaSATCategoryViewController () <UITableViewDataSource, UITableViewDelegate>

/// 名称
@property (weak, nonatomic) IBOutlet UIButton *nameButton;

/// 分类列表
@property (weak, nonatomic) IBOutlet UITableView *categoryListView;

/// 所有的分类
@property (strong, nonatomic) NSMutableArray *categories;


/// 编辑的cell位置
@property (nonatomic, assign) CGRect editCellRect;

/// 当前行
@property (nonatomic, assign) NSUInteger currentRow;

/// 上一次移动的距离
@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation SHMediaSATCategoryViewController

// MARK: - tableView的代理

/// 样式操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if (indexPath.row < self.categories.count) {
        
        TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:nil message:@"Are you sure to delete SAT.Category ?" isCustom:YES];
        
        
        [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.yes style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            
            SHMediaSATCategory *category = [self.categories objectAtIndex:indexPath.row];
            
            [self.categories removeObject:category];
         
            [SHSQLiteManager.shared deleteSatCategory:category];
            
            [tableView reloadData];
            
        }]];
      
        
        [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.no style:TYAlertActionStyleCancel handler:nil]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:@"Are you sure to Add New SAT.Category ?" message:nil isCustom:YES];
        
        [alertView addAction:[TYAlertAction actionWithTitle:SHLanguageText.no style:TYAlertActionStyleCancel handler:nil]];
        
        [alertView addAction: [TYAlertAction actionWithTitle:SHLanguageText.yes style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            
            SHMediaSATCategoryEditViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            cell.editNewCategory = YES;
            
            [tableView reloadData];
            
        }]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


/// 设置cell的的编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
        
        return ((indexPath.row == self.categories.count) ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete);
    }
    
    return UITableViewCellEditingStyleNone; // 什么也没有
}


// MARK: - tableView的数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableView.isEditing ? (self.categories.count + 1) : self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMediaSATCategoryEditViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHMediaSATCategoryEditViewCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.categories.count) {
        
         cell.category = self.categories[indexPath.row];
   
    } else {
     
        // 出现新增加的分类
        SHMediaSATCategory *satCategory = [[SHMediaSATCategory alloc] init];
       
        // 设置默认名称
        satCategory.categoryName = [NSString stringWithFormat:@"%@ %@", SHLanguageText.add, [[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MEDIA_IN_ZONE" withSubTitle:@"CATEGORY"]];
        
        // 返回数据
        cell.category = satCategory;
    }
    
    // cell的移动回调
    cell.cellMove = ^() {
        
        // 记录当前行
        self.currentRow = indexPath.row;
        
        // 获得cell的位置
        CGRect rectCell =  [tableView rectForRowAtIndexPath:indexPath];
        
        // 转换为父控件的self.view中的位置
        self.editCellRect = [tableView convertRect:rectCell toView:self.view];
    };
    
    cell.isNew = (indexPath.row == self.categories.count);
    
    return cell;
}

// MARK: - 通知处理

/// 复位
- (void)moveBack:(NSNotification *)notification{
    
    // 回滚到上一次滚动的位置
    [self.categoryListView setContentOffset:CGPointMake(self.categoryListView.contentOffset.x, self.lastOffsetY) animated:YES];
}

/// 移动到指定位置
- (void)moveToNewLocation:(NSNotification *)notification {
    
    // 记录起始位置
    self.lastOffsetY = self.categoryListView.contentOffset.y;
    
    // 滚动到指定的位置
    [self.categoryListView setContentOffset:CGPointMake(self.categoryListView.contentOffset.x, self.currentRow * self.editCellRect.size.height) animated:YES];
}

/// 移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - UI初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化列表
    self.categoryListView.rowHeight = navigationBarHeight;
    self.categoryListView.backgroundColor = [UIColor clearColor];
    self.categoryListView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    // 增加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToNewLocation:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveBack:) name:UIKeyboardWillHideNotification object:nil];
}


/// 设置分类数据
- (void)setCategoryData {
    
    // 没有数据不能编辑
    if (!self.categories.count) {
        return;
    }
    
    // 设置编辑状态
    self.categoryListView.editing = !self.categoryListView.isEditing;
    
    // 要在最后面增加一个cell, 但是不能创建对象，确定下来以后，再进行。
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.categories.count inSection:0];
    
    if (self.categoryListView.isEditing) {  // 处理编辑状态
        
        // 增加一行
        [self.categoryListView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else {
        
        // 不是编辑状态 删除最后一行
        [self.categoryListView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // 刷新表格
    [self.categoryListView reloadData];
}

@end
