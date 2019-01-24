//
//  SHAreaSettingViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/15.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHAreaSettingViewController.h"

/// 系统图片最大ID
NSUInteger maxIconIDForDataBase = 10;

/// 重用cell
static NSString *systemCellReusableIdentifier = @"SHSetSystemViewCell";

@interface SHAreaSettingViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/// 区域高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zoneViewHeightConstraint;

/// 按钮宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconButtonWidthConstraint;

/// 按钮高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconButtonHeightConstraint;

/// 区域
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

/// 名称
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

/// 设置列表
@property (weak, nonatomic) IBOutlet UITableView *deviceListView;

/// 设置名称
@property (strong, nonatomic) NSArray *deviceNames;

/// 区域中包含的所有开启功能的系统设备
@property (nonatomic, strong) NSMutableArray *allSystems;

@end

@implementation SHAreaSettingViewController


// MARK: - 照片的处理

/// 图片按钮点击
- (IBAction)iconButtonClick {
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:nil message:@"Change zone picture?" isCustom:YES];
    
    // 图片库中获取
    [alertView addAction:[TYAlertAction actionWithTitle:@"Library" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        SHZoneIconViewController *zoneIconViewController = [[SHZoneIconViewController alloc] init];
        
        zoneIconViewController.selectImage =  ^(SHIcon *icon) {
            
            if ([icon.iconName isEqualToString: self.currentZone.zoneIconName]) {
                return ;
            }
            self.currentZone.zoneIconName = icon.iconName;
            
            UIImage *zoneImage;
            if (icon.iconID > maxIconIDForDataBase) {
                
                zoneImage = [UIImage imageWithData:icon.iconData];
                
            } else {
                
                zoneImage = [UIImage imageNamed:self.currentZone.zoneIconName];
            }
            
            [self.iconButton setImage:[self.iconButton.imageView circleImageWithImage:zoneImage borderWidth:0 borderColor: nil] forState:UIControlStateNormal];
            
            [SHSQLiteManager.shared updateZone:self.currentZone];
        };
        
        SHNavigationController *navigationController = [[SHNavigationController alloc] initWithRootViewController:zoneIconViewController];
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }]];
    
    // 相册中获取
    [alertView addAction:[TYAlertAction actionWithTitle:@"Photos" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    // 相机中获取
    [alertView addAction:[TYAlertAction actionWithTitle:@"Camera" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    // 取消
    [alertView addAction:[TYAlertAction actionWithTitle:@"Cancel" style:TYAlertActionStyleCancel handler:nil]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
    
    alertController.backgoundTapDismissEnable = YES;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - 照片的代理

/// 取消操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil  ];
}

/// 获得照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 尺寸
    CGSize iconSize =
        CGSizeMake(navigationBarHeight * 2,
                   navigationBarHeight * 2
    );
    
    UIImage *sourceImage =
    [self.iconButton.imageView circleImageWithImage:[self.iconButton.imageView reSizeImage:info[UIImagePickerControllerOriginalImage] toSize: iconSize] borderWidth:3.0 borderColor: [UIColor colorWithHex:0x7b7778 alpha:1.0]];
    
    
    
    // 如果是相机，保存到相册中去
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(sourceImage, self, nil, nil);
    }
    
    // ===========图片需要保存在沙盒中================
    
    SHIcon *icon = [[SHIcon alloc] init];
    icon.iconID =
        SHSQLiteManager.shared.getMaxIconID + 1;
    icon.iconName = [NSString stringWithFormat:@"icon_%tu", icon.iconID];
    icon.iconData = UIImagePNGRepresentation(sourceImage);
  
    [SHSQLiteManager.shared insertIcon:icon];
    
    self.currentZone.zoneIconName = icon.iconName;
    
    [SHSQLiteManager.shared updateZone:self.currentZone];
    
    [self.iconButton setImage:sourceImage forState:UIControlStateNormal];
}

// MARK: - textField代理

/// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
}

/// 结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = [UIColor whiteColor];
    
    if (!textField.text || !textField.text.length || [textField.text isEqualToString:self.currentZone.zoneName]) {
        textField.text = self.currentZone.zoneName;
        return;
    }
    
    self.currentZone.zoneName = textField.text;
  
    [SHSQLiteManager.shared updateZone:self.currentZone];
}

/// 退出
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.deviceNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHSetSystemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellReusableIdentifier forIndexPath:indexPath];
    
    cell.deviceName = self.deviceNames[indexPath.row];
    
    cell.hasDevice = [self.allSystems containsObject:@(indexPath.row + 1)];
    
    cell.choiceDevice = ^(BOOL hasChoice){
        
        NSNumber *deviceSystemID = @(indexPath.row + 1);
        
        if ([self.allSystems containsObject:deviceSystemID] && !hasChoice) {
            
            [self.allSystems removeObject:deviceSystemID];
            
        } else if (hasChoice && ![self.allSystems containsObject:deviceSystemID]){
            if (hasChoice) {
                [self.allSystems addObject:deviceSystemID];
            }
        }
    };
    
    return cell;
}


// MARK: - 视图加载

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([UIDevice is_iPad]) {
        
        self.zoneViewHeightConstraint.constant = navigationBarHeight * 2 + statusBarHeight;
        
        self.iconButtonWidthConstraint.constant = navigationBarHeight * 2;
        self.iconButtonHeightConstraint.constant = navigationBarHeight * 2;
    }
}

/// 保存系统设备ID
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
    [SHSQLiteManager.shared saveSystemIDs:self.allSystems zoneID:self.currentZone.zoneID];
    
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSArray *types =
        [SHSQLiteManager.shared getSystemIDs:self.currentZone.zoneID];
    
    self.allSystems = [NSMutableArray arrayWithArray:types];
  
    
    [self.deviceListView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"System Setting";
    
    self.deviceNames = [SHSQLiteManager.shared getSystemNames];
    
    [self.deviceListView registerNib:[UINib nibWithNibName:systemCellReusableIdentifier bundle:nil] forCellReuseIdentifier:systemCellReusableIdentifier];
    
    self.deviceListView.rowHeight = [SHSetSystemViewCell rowHeight];
    
    UIImage *image = [UIImage imageNamed:self.currentZone.zoneIconName];
    
    if (!image) {
        
        SHIcon *icon =
            [SHSQLiteManager.shared
                getIcon:self.currentZone.zoneIconName];
        
        image = [UIImage imageWithData:icon.iconData];
    }
    
    [self.iconButton setImage:image forState:UIControlStateNormal];
    
    self.nameTextField.text = self.currentZone.zoneName;
    
    if ([UIDevice is_iPad]) {
        
        self.nameTextField.font = [UIView suitFontForPad];
    }
}

// MARK: - getter && setter

/// 所有的系统
- (NSMutableArray *)allSystems {
    
    if (!_allSystems) {
        _allSystems = [NSMutableArray array];
    }
    return _allSystems;
}

@end
