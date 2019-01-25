//
//  SHZoneDmxGroupViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHZoneDmxGroupViewController: SHTabBarController {
   
    /// 类型名称
    private lazy var deviceTypeNames = [String]()
    
    /// 选项卡
    private lazy var tabBarScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        
        return scrollView
    }()
    
    /// 上一次选中的按钮
    var preivousButton: SHZoneControlButton?
 
 
    /// 设置控制器
    func setupDmxGroupController(dmxGroup: SHDmxGroup?) {
      
        navigationItem.title = dmxGroup?.groupName
     
        addChildViewControllers(dmxGroup)
        
        setUpTabBar()
    }
    
    /// 设置tabBar
    private func setUpTabBar() {
        
        tabBar.backgroundImage =
            UIImage(named: "tabBarbackground")
        
        view.addSubview(tabBarScrollView)
        
        let count = children.count
        
        for i in 0 ..< count {
            
            let zoneControlButton = SHZoneControlButton()
            
            zoneControlButton.tag = i
            
            // 设置图片
            //  [zoneControlButton setBackgroundImage:[UIImage resizeImage:@"tabBarSelectedbackground"] forState:UIControlStateSelected];
            
            let normalImage =
                UIImage(named: deviceTypeNames[i] + "TabBar")
            
            zoneControlButton.setImage(normalImage,
                                       for: .normal
            )
            
            let selectedImage =
                UIImage(named: deviceTypeNames[i] +
                        "TabBar_highlighted"
            )
            
            zoneControlButton.setImage(selectedImage,
                                       for: .selected
            )
            
            
            tabBarScrollView.addSubview(zoneControlButton)
            
            zoneControlButton.addTarget(
                self,
                action: #selector(changeViewController(_:)),
                for: .touchUpInside
            )
            
            if i == 0 { // 默认第一个是选中状态
                
                changeViewController(zoneControlButton)
            }
        }
    }
    
    /// 选择不同的控制器
    @objc private func changeViewController(_ button: SHZoneControlButton) {
    
        if button == preivousButton {
            
            return
        }
        
        button.isSelected = !button.isSelected
        
        preivousButton?.isSelected =
            !(preivousButton?.isSelected ?? false)
        
        preivousButton = button
        
        if button.isSelected {
            
            selectedIndex = button.tag
        }
        
    }
    
    /// 添加子控制器
    private func addChildViewControllers(_ dmxGroup: SHDmxGroup?) {
        
        // 单 channel
        deviceTypeNames.append("dmxChannel")
        let channelController = SHDmxChannelViewController()
        channelController.dmxGroup = dmxGroup
        addChild(channelController)
        
        // 颜色
        deviceTypeNames.append("dmxColor")
        let colorController = SHDmxColorViewController()
        colorController.dmxGroup = dmxGroup
        addChild(colorController)
        
        // 图片
        deviceTypeNames.append("dmxPicture")
        let pictureController = SHDmxPictureViewController()
        pictureController.dmxGroup = dmxGroup
        addChild(pictureController)
        
        // 组合颜色模式
        deviceTypeNames.append("dmxFunction")
        let funtionController = SHDmxFunctionViewController()
        funtionController.dmxGroup = dmxGroup
        addChild(funtionController)
        
        // 声音
//        deviceTypeNames.append("dmxVoice")
//        let voiceController = SHDmxVoiceViewController()
//        voiceController.dmxGroup = self.dmxGroup
//        addChild(voiceController)
    }

    /// 布局子控件
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBarScrollView.frame = tabBar.frame
        
        let itemHeight = tabBarHeight
        let itemWidth = tabBar.frame_width * 0.25 // (1/4)
        
        let startX =
            (tabBar.frame_width -
                CGFloat(children.count > 4 ? 4 : children.count) * itemWidth
            ) * 0.5
        
        let count = tabBarScrollView.subviews.count
        
        for i in 0 ..< count {
            
            let button = tabBarScrollView.subviews[i]
            
            button.frame =
                CGRect(x: CGFloat(button.tag) * itemWidth
                        + startX,
                       y: 0,
                       width: itemWidth,
                       height: itemHeight
            )
        }
        
        tabBarScrollView.contentSize =
            CGSize(width: itemWidth * CGFloat(children.count),
                   height: itemHeight
        )
    }
}
