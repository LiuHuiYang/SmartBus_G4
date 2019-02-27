//
//  SHHomeViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHMainViewController: SHTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加所有的子控制器
        addChildControllers()
        
        // 设置背景
//        tabBar.backgroundImage =
//            UIImage(named: "tabBarbackground")
       
        // 解决 iOS 12.1 开始， pop返回时 tabBar 子控件抖动
        tabBar.isTranslucent = false
        tabBar.barTintColor =
            UIColor(hex: 0x5c493d, alpha: 1.0)
       
    }
}

// MARK: - 添加子控制器
extension SHMainViewController {
    
    /// 添加不同模块的子控制器
    fileprivate func addChildControllers() {
        
        // 标题数组
        let titleArray: [String] = SHLanguageTools.share()?.getTextFromPlist("MAIN_PAGE", withSubTitle: "MAIN_LABEL") as! Array
        
        // 区域控制
        setChildViewController(
            viewController: SHZoneControlViewController(),
            title: titleArray[0],
            imageName: "zones_tabBar"
        )
        
//        // 多区域控制
//        setChildViewController(
//            viewController: SHRegionViewController(),
//            title: titleArray[0],
//            imageName: "zones_tabBar"
//        )
        
        // 中心控制
        setChildViewController(
            viewController: SHCentralControlViewController(),
            title: titleArray[1],
            imageName: "central_tabBar"
        )
        
        // 公共服务
        setChildViewController(
            viewController: SHCommunalServicesViewController(),
            title: titleArray[2],
            imageName: "service_tabBar"
        )
        
        // 设置
        let settingText = SHLanguageTools.share()?.getTextFromPlist("SETTINGS", withSubTitle: "SETTINGS") as! String
        
        setChildViewController(
            viewController: SHSettingViewController(),
            title: settingText,
            imageName: "setting_tabBar"
        )
    }
    
    
    /// 设置控制器的相关属性
    ///
    /// - Parameters:
    ///   - viewController: 实例化控制器
    ///   - title: 标题
    ///   - imageName: 图片名称
    private func setChildViewController(
        viewController: SHViewController,
        title: String,
        imageName: String) {
        
//        viewController.title = title
        
        viewController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        
        viewController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_highlighted")?.withRenderingMode(.alwaysOriginal)
        
        let childNaviationViewController =
            SHNavigationController(rootViewController: viewController)
        
        viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 4, left: 0, bottom: -4, right: 0)
        
        addChild(childNaviationViewController)
    }
}
