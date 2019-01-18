//
//  SHZoneDmxGroupViewController.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/4.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHZoneDmxGroupViewController.h"
#import "SHZoneControlButton.h"
#import "SHDmxVoiceViewController.h"

@interface SHZoneDmxGroupViewController ()

/// 当前dmx
@property (strong, nonatomic) SHDmxGroup *dmxGroup;

///  tarBarScrollView （要设置tarBar的滚动范围）
@property (strong, nonatomic) UIScrollView *tabBarScrollView;

/// 上一次选中的按钮
@property (weak, nonatomic) SHZoneControlButton *preivousButton;

/// 不同模块相关图片的名称
@property (strong, nonatomic) NSMutableArray *deviceTypeNames;

@end

@implementation SHZoneDmxGroupViewController

/// 通过指定的dmx进行初始化控制器 (尝试使用Swift通过属性传递来设置)
- (instancetype)initWithDmxGroup:(SHDmxGroup *)dmxGroup {
    
    if (self = [super init]) {
        
        self.dmxGroup = dmxGroup;
        self.navigationItem.title = dmxGroup.groupName;
        
        [self addChildViewControllers];
        
        [self setUpTabBar];
        
    }
    
    return self;
}


/// 设置tabBar
- (void)setUpTabBar {
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabBarbackground"];
 

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

/// 增加控制器
- (void)addChildViewControllers {
    
    // 单 channel
    SHDmxChannelViewController *channelController = [[SHDmxChannelViewController
                                                      alloc] init];
    channelController.dmxGroup = self.dmxGroup;
    [self.deviceTypeNames addObject:@"dmxChannel"];
    [self addChildViewController:channelController];
    
    // 取色
    SHDmxColorViewController *colorController = [[SHDmxColorViewController
                                                      alloc] init];
    colorController.dmxGroup = self.dmxGroup;
    [self.deviceTypeNames addObject:@"dmxColor"];
    [self addChildViewController:colorController];
    
    // 选择图片颜色
    SHDmxPictureViewController *pictureController = [[SHDmxPictureViewController
                                                      alloc] init];
    pictureController.dmxGroup = self.dmxGroup;
    [self.deviceTypeNames addObject:@"dmxPicture"];
    [self addChildViewController:pictureController];
    
    // 设置不同的模式
    SHDmxFunctionViewController *funtionController = [[SHDmxFunctionViewController
                                                      alloc] init];
    funtionController.dmxGroup = self.dmxGroup;
    [self.deviceTypeNames addObject:@"dmxFunction"];
    [self addChildViewController:funtionController];
    
    // 声音
//    SHDmxVoiceViewController *voiceController = [[SHDmxVoiceViewController
//                                                  alloc] init];
//    
//    voiceController.dmxGroup = self.dmxGroup;
//    [self.deviceTypeNames addObject:@"dmxVoice"];
//    [self addChildViewController:voiceController];
}

/// 布局子控件
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    // 保证iPhoneX时的选项卡位置大小和系统一致
    self.tabBarScrollView.frame = CGRectMake(0, self.view.bounds.size.height - self.tabBar.frame_height, self.view.frame.size.width, tabBarHeight);
    
    CGFloat itemHeight = self.tabBarScrollView.frame_height;
    CGFloat itemWidth = self.view.frame_width / 4;
    
    CGFloat startX = (self.view.frame_width - (self.childViewControllers.count > 4 ? 4 : self.childViewControllers.count) * itemWidth) * 0.5;
    
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
