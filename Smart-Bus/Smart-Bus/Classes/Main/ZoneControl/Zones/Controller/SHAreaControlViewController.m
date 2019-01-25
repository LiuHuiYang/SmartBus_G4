//
//  SHAreaControlViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/13.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "SHAreaControlViewController.h"
#import "SHZoneAudioPlayControlViewController.h"
#import "SHAreaSettingViewController.h"
 
@interface SHAreaControlViewController ()

// MARK: - 区域与类型

/// 当前区域
@property (assign, nonatomic) SHZone *currentZone;

/// 所有的设置类型ID
@property (strong, nonatomic) NSArray *allDeviceTypeIDs;

/// 系统相关的名称
@property (strong, nonatomic) NSMutableArray *deviceTypeNames;

// MARK: - tarBar区域

///  tarBarScrollView （要设置tarBar的滚动范围）
@property (strong, nonatomic) UIScrollView *tabBarScrollView;

/// 上一次选中的按钮
@property (weak, nonatomic) SHZoneControlButton *preivousButton;

@end

@implementation SHAreaControlViewController


// MARK: - 初始化设置导航

/// 设置区域
- (void)setArea {
    
    // 无操作权限 或者没有设备模块
    if ([SHAuthorizationViewController isOperatorDisable] ||
        !self.selectedViewController) {
        
        return;
    }
    
    SHSystemDeviceType deviceType = 0;
    
    /// 列表类
    if ([self.selectedViewController isKindOfClass:[SHZoneDevicesViewController class]]) {
        
        SHZoneDevicesViewController *zoneDevicesViewController = self.selectedViewController;
        
        switch (zoneDevicesViewController.deviceType) {
            
            case SHSystemDeviceTypeHvac: {
                
                deviceType = SHSystemDeviceTypeHvac;
            }
                break;
                
            case SHSystemDeviceTypeAudio: {
                
                deviceType = SHSystemDeviceTypeAudio;
            }
                break;
                
            case SHSystemDeviceTypeFloorHeating: {
                
                deviceType = SHSystemDeviceTypeFloorHeating;
            }
                break;
                
            case SHSystemDeviceTypeNineInOne: {
                
                deviceType = SHSystemDeviceTypeNineInOne;
            }
                break;
                
            case SHSystemDeviceTypeTv: {
                
                deviceType = SHSystemDeviceTypeTv;
            }
                break;
                
            case SHSystemDeviceTypeDvd: {
                
                deviceType = SHSystemDeviceTypeDvd;
            }
                break;
                
            case SHSystemDeviceTypeSat: {
                
                deviceType = SHSystemDeviceTypeSat;
            }
                break;
                
            case SHSystemDeviceTypeAppletv: {
                
                deviceType = SHSystemDeviceTypeAppletv;
            }
                break;
                
            case SHSystemDeviceTypeProjector: {
                
                deviceType = SHSystemDeviceTypeProjector;
            }
                break;
                
            case SHSystemDeviceTypeDmx: {
                 
                SHZoneDmxGroupSettingViewController *dmxGroupSettingController = [[SHZoneDmxGroupSettingViewController alloc] init];
                
                dmxGroupSettingController.currentZone = self.currentZone;
                
                [self.navigationController pushViewController:dmxGroupSettingController animated:YES];
 
                return;
            }
                break;
                
            default:
                break;
        }
        
        // 灯泡列表
    } else if ([self.selectedViewController isKindOfClass:[SHZoneLightViewController class]]){
        
        deviceType = SHSystemDeviceTypeLight;
    
        // 窗帘
    } else if ([self.selectedViewController isKindOfClass:[SHZoneShadeViewController class]]){
        
        deviceType = SHSystemDeviceTypeShade;
    
        // Mood
    } else if ([self.selectedViewController isKindOfClass:[SHZoneMoodViewController class]]){ 
        
        SHZoneControlEditMoodViewController *editMoodController = [[SHZoneControlEditMoodViewController alloc] init];
        
        editMoodController.currentZone = self.currentZone;
        
        [self.navigationController pushViewController:editMoodController animated:YES];
        
        return; // Mood是不同的方式
    
        // Fan
    } else if ([self.selectedViewController isKindOfClass:[SHZoneFanViewController class]]){
     
        deviceType = SHSystemDeviceTypeFan;
     
        // 干节点
    } else if ([self.selectedViewController isKindOfClass:[SHZoneDryContactViewController class]]){

        deviceType = SHSystemDeviceTypeDryContact;
       
        // 温度传感器
    } else if ([self.selectedViewController isKindOfClass:[SHZoneTemperatureSensorViewController class]]){
        
        deviceType = SHSystemDeviceTypeTemperatureSensor;
    
        // scene控制
    } else if ([self.selectedViewController isKindOfClass:[SHSceneControlViewController class]]){
        
        deviceType = SHSystemDeviceTypeSceneControl;
        
        // Sequence 控制
    } else if ([self.selectedViewController isKindOfClass:[SHSequenceControlViewController class]]){
        
        deviceType = SHSystemDeviceTypeSequenceControl;
        
        // otherControl 控制
    } else if ([self.selectedViewController isKindOfClass:[SHOtherControlViewController class]]){
        
        deviceType = SHSystemDeviceTypeOtherControl;
    }
    
    // 进入设置页面
     SHSystemDetailViewController *systemDetailViewController = [[SHSystemDetailViewController alloc] init];
    
    systemDetailViewController.currentZone =
        [self.selectedViewController currentZone];
  
    systemDetailViewController.systemType = deviceType;
    
    [self.navigationController pushViewController:systemDetailViewController animated:YES];
}

/// 设置导航栏
- (void)setUpNavigationBar {
    
    self.navigationItem.title = self.currentZone.zoneName;
    
    self.navigationItem.rightBarButtonItem =
        [UIBarButtonItem barButtonItemWithImageName:@"setting"
                              hightlightedImageName:@"setting"
                                          addTarget:self
                                             action:@selector(setArea)
                                             isLeft:NO
        ];
    
   
//    self.navigationItem.rightBarButtonItem.customView.hidden = !self.childViewControllers.count;
    
    // 由结构的变化 Navi Push TabBar 所以在这里再写一次
    UIView *leftCustomView = self.navigationItem.leftBarButtonItem.customView;
    UIView *rightCustomView = self.navigationItem.rightBarButtonItem.customView;
    
    CGFloat itemSize =  [UIDevice is_iPad] ?
        (navigationBarHeight + statusBarHeight) : tabBarHeight;
    
    leftCustomView.bounds = CGRectMake(0, 0, itemSize, itemSize);
    rightCustomView.bounds = CGRectMake(0, 0, itemSize, itemSize);
    
    //    leftCustomView.backgroundColor = [UIColor orangeColor];
    //    rightCustomView.backgroundColor = [UIColor greenColor];
}


// MARK: - 初始化UI

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self setUpNavigationBar];
}


/// 初始化控制器时设置 Zone
- (instancetype)initWithZone:(SHZone *)zone {
    
    if (self = [super init]) {
        
        self.currentZone = zone;
        [self addChildViewControllers];
        [self setUpTabBar];
    }
    
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// MARK: -  tabBar

- (void)setUpTabBar {

    self.tabBar.backgroundImage = [UIImage resizeImage:@"tabBarbackground"];
    
    [self.view addSubview:self.tabBarScrollView];
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        
        SHZoneControlButton *zoneControlButton = [[SHZoneControlButton alloc] init];
        
        zoneControlButton.tag = i;
        
        // 设置图片
        //  [zoneControlButton setBackgroundImage:[UIImage resizeImage:@"tabBarSelectedbackground"] forState:UIControlStateSelected];
        
        [zoneControlButton setImage:[UIImage imageNamed:[self.deviceTypeNames[i] stringByAppendingString:@"TabBar"]] forState:UIControlStateNormal];
        
        [zoneControlButton setImage:[UIImage imageNamed:[self.deviceTypeNames[i] stringByAppendingString:@"TabBar_highlighted"]] forState:UIControlStateSelected];
        
        // 获得按钮名称 -- 取消文字显示
        //        [zoneControlButton setTitle:[[SHLanguageTools shareLanguageTools] getTextFromPlist:@"MAIN_PAGE" withSubTitle:self.systemNames[i]] forState:UIControlStateNormal];
        
        // ========== 不同的部分
        [zoneControlButton addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBarScrollView addSubview:zoneControlButton];
        
        if (!i) { // 默认第一个是选中状态
            
            [self changeViewController:zoneControlButton];
        }
    }
}

/// 修改状态
- (void)changeViewController:(SHZoneControlButton *)button {
    
    if (button == self.preivousButton ) {
        return;
    }
    
    button.selected = !button.selected;
    self.preivousButton.selected = !self.preivousButton.selected;
    self.preivousButton = button;
    
    if (button.selected) {
        
        [self setSelectedIndex:button.tag];
    }
}

// MARK: - 添加子控制器

/// 添加区域中的所有子控制器
- (void)addChildViewControllers {

    self.allDeviceTypeIDs =
        [SHSQLiteManager.shared
            getSystemIDs:self.currentZone.zoneID];
    
    if (!self.allDeviceTypeIDs.count) {
        
        [SVProgressHUD showInfoWithStatus:SHLanguageText.noData];
        
        return;
    }
    
    // 查询
    for (NSUInteger i = 0; i < self.allDeviceTypeIDs.count; i++) {
        
        NSUInteger systemIDValue = [self.allDeviceTypeIDs[i] integerValue];

        
        switch (systemIDValue) {
                
            case SHSystemDeviceTypeLight: {
                
                SHZoneLightViewController *zoneLight = [[SHZoneLightViewController alloc] init];
                zoneLight.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"alight"];
                
                [self addChildViewController:zoneLight];
            }
                break;
                
            case SHSystemDeviceTypeHvac: {
                
                SHZoneDevicesViewController *zoneHVAC = [[SHZoneDevicesViewController alloc] init];
                
                zoneHVAC.currentZone = self.currentZone;
                zoneHVAC.deviceType = SHSystemDeviceTypeHvac;
                
                [self.deviceTypeNames addObject:@"bhvac"];
                
                [self addChildViewController:zoneHVAC];
                
            }
                break;
                
            case SHSystemDeviceTypeAudio: {
 
                SHZoneDevicesViewController *zoneAudio = [[SHZoneDevicesViewController alloc] init];
                
                zoneAudio.currentZone = self.currentZone;
                zoneAudio.deviceType = SHSystemDeviceTypeAudio;
                
                [self.deviceTypeNames addObject:@"czaudio"];
                [self addChildViewController:zoneAudio];
     
            }
                break;
                
            case SHSystemDeviceTypeShade: {
                
                SHZoneShadeViewController *zoneShade = [[SHZoneShadeViewController alloc] init];
        
                zoneShade.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"dshades"];
                
                [self addChildViewController:zoneShade];
      
            }
                break;
                
            case SHSystemDeviceTypeTv: {
 
                SHZoneDevicesViewController *zoneTV = [[SHZoneDevicesViewController alloc] init];
                
                zoneTV.currentZone = self.currentZone;
                zoneTV.deviceType = SHSystemDeviceTypeTv;
                
                [self.deviceTypeNames addObject:@"etv"];
                
                [self addChildViewController:zoneTV];
            }
                break;
                
            case SHSystemDeviceTypeSat: {
                
                SHZoneDevicesViewController *zoneDVD = [[SHZoneDevicesViewController alloc] init];
                
                zoneDVD.currentZone = self.currentZone;
                zoneDVD.deviceType = SHSystemDeviceTypeSat;
                
                [self.deviceTypeNames addObject:@"esat"];
                
                [self addChildViewController:zoneDVD];
            }
                break;
                
            case SHSystemDeviceTypeDvd: {
                
                SHZoneDevicesViewController *zoneDVD = [[SHZoneDevicesViewController alloc] init];
                
                zoneDVD.currentZone = self.currentZone;
                zoneDVD.deviceType = SHSystemDeviceTypeDvd;
                
                [self.deviceTypeNames addObject:@"edvd"];
                
                [self addChildViewController:zoneDVD];
                
            }
                break;
                
            case SHSystemDeviceTypeAppletv: {
                
                SHZoneDevicesViewController *zoneDVD = [[SHZoneDevicesViewController alloc] init];
                
                zoneDVD.currentZone = self.currentZone;
                zoneDVD.deviceType = SHSystemDeviceTypeAppletv;
                
                [self.deviceTypeNames addObject:@"eappletv"];
                
                [self addChildViewController:zoneDVD];
            }
                break;
                
            case SHSystemDeviceTypeProjector: {
                
                SHZoneDevicesViewController *zoneProjector = [[SHZoneDevicesViewController alloc] init];
                
                zoneProjector.currentZone = self.currentZone;
                zoneProjector.deviceType = SHSystemDeviceTypeProjector;
                
                [self.deviceTypeNames addObject:@"eprojector"];
                
                [self addChildViewController:zoneProjector];
            }
                break;
                
            case SHSystemDeviceTypeMood: {
                
                SHZoneMoodViewController *zoneMood = [[SHZoneMoodViewController alloc] init];
              
                zoneMood.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"fmoods"];
                
                [self addChildViewController:zoneMood];
            }
                break;
                
            case SHSystemDeviceTypeFan: {
        
                SHZoneFanViewController *zoneFan = [[SHZoneFanViewController alloc] init];
                
                zoneFan.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"gfan"];
                
                [self addChildViewController:zoneFan];
              
            }
                break;
            
            case SHSystemDeviceTypeFloorHeating: {
                
                SHZoneDevicesViewController *floorHeating = [[SHZoneDevicesViewController alloc] init];
                
                floorHeating.currentZone = self.currentZone;
                floorHeating.deviceType = SHSystemDeviceTypeFloorHeating;
                
                [self.deviceTypeNames addObject:@"hFloorheating"];
                
                [self addChildViewController:floorHeating];
            }
                break;
              
            case SHSystemDeviceTypeNineInOne: {
                
                SHZoneDevicesViewController *nineInOne = [[SHZoneDevicesViewController alloc] init];
                
                nineInOne.currentZone = self.currentZone;
                nineInOne.deviceType = SHSystemDeviceTypeNineInOne;
                
                [self.deviceTypeNames addObject:@"jnieInOne"];
                
                [self addChildViewController:nineInOne];
            }
                break;
           
            case SHSystemDeviceTypeDryContact: {
                
                SHZoneDryContactViewController *dryContact = [[SHZoneDryContactViewController alloc] init];
                    
                dryContact.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"kdryInput"];
                
                [self addChildViewController:dryContact];
            }
                break;
                
            case SHSystemDeviceTypeTemperatureSensor: {
            
                SHZoneTemperatureSensorViewController *temperatureSensor = [[SHZoneTemperatureSensorViewController alloc] init];
                
                temperatureSensor.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"ltemperature"];
                
                [self addChildViewController:temperatureSensor];
            }
                break;
                
            case SHSystemDeviceTypeDmx: {
                
                SHZoneDevicesViewController *dmx = [[SHZoneDevicesViewController
                                                     alloc] init];
                
                dmx.currentZone = self.currentZone;
                dmx.deviceType = SHSystemDeviceTypeDmx;
                [self.deviceTypeNames addObject:@"mdmx"];
                
                [self addChildViewController:dmx];
            }
                break;
                
            case SHSystemDeviceTypeSceneControl: {
                
                SHSceneControlViewController *sceneController = [[SHSceneControlViewController alloc] init];
                
                sceneController.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"nscene"];
                
                [self addChildViewController:sceneController];
            }
                break;
                
            case SHSystemDeviceTypeSequenceControl: {
                
                SHSequenceControlViewController
                * sequenceController =
                    [[SHSequenceControlViewController alloc] init];
                
                sequenceController.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"psequence"];
                
                [self addChildViewController:sequenceController];
            }
                break;
                
            case SHSystemDeviceTypeOtherControl: {
               
                SHOtherControlViewController *otherController = [[SHOtherControlViewController alloc] init];
                
                otherController.currentZone = self.currentZone;
                
                [self.deviceTypeNames addObject:@"qother"];
                
                [self addChildViewController:otherController];
            }
                break;
                
            default:
                break;
        }
    }
}

// MARK: -  布局

/// 布局子控件
- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    
    // 保证iPhoneX时的选项卡位置大小和系统一致
    self.tabBarScrollView.frame = CGRectMake(0, self.view.bounds.size.height - self.tabBar.frame_height, self.view.frame.size.width, tabBarHeight);
   
    CGFloat itemHeight = self.tabBarScrollView.frame_height;
    CGFloat itemWidth = self.view.frame_width / 4;
    
    CGFloat startX = (self.view.frame_width - (self.childViewControllers.count > 4 ? 4 : self.allDeviceTypeIDs.count) * itemWidth) * 0.5;
    
    for (NSUInteger i = 0; i < self.tabBarScrollView.subviews.count; i++) {
        
        SHZoneControlButton *zoneControllerButton = self.tabBarScrollView.subviews [i];
        
        zoneControllerButton.frame = CGRectMake((zoneControllerButton.tag) * itemWidth + startX, (self.tabBarScrollView.frame_height - itemHeight) * 0.5, itemWidth, itemHeight);
    }
    
    self.tabBarScrollView.contentSize = CGSizeMake(self.childViewControllers.count * itemWidth, itemHeight);
}

// MARK: - getter && setter

/// tabBarScrollView
- (UIScrollView *)tabBarScrollView {

    if (!_tabBarScrollView) {
        
        _tabBarScrollView = [[UIScrollView alloc] init];
        _tabBarScrollView.scrollEnabled = YES;
        _tabBarScrollView.showsVerticalScrollIndicator = NO;
        _tabBarScrollView.showsHorizontalScrollIndicator = NO;
        _tabBarScrollView.pagingEnabled = NO;
    }
    
    return _tabBarScrollView;
}

/// 设备图片名称
- (NSMutableArray *)deviceTypeNames {
    
    if (!_deviceTypeNames) {
        _deviceTypeNames = [NSMutableArray array];
    }
    return _deviceTypeNames;
}

@end
