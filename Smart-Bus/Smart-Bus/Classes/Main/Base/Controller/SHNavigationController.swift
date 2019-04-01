//
//  SHNavigationController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 导航栏的字体
let navigationBarFont: UIFont =
    (UIDevice.is_iPad() ? UIView.suitFontForPad() : UIFont.boldSystemFont(ofSize: 20))

class SHNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.setBackgroundImage(
            UIImage(
                named: "navigationbarbackground"),
                for: .default
        )

        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: navigationBarFont,

            NSAttributedString.Key.foregroundColor:
                UIView.textWhiteColor() as Any
        ]
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            viewController.navigationItem.leftBarButtonItem =
                UIBarButtonItem(title: nil,
                                font: nil,
                                normalTextColor: nil,
                                highlightedTextColor: nil,
                                imageName: "navigationbarback",
                                hightlightedImageName: "navigationbarback",
                                addTarget: self,
                                action: #selector(popBack),
                                isNavigationBackItem:true)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    /// 控制器出栈
    @objc func popBack() {
        
        popViewController(animated:true)
    }
    
    /// 横竖屏适配
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if UIDevice.is_iPad() {
            return super.supportedInterfaceOrientations
        }
        
        return .portrait
    }
    
    /// 状态栏隐藏
    override var prefersStatusBarHidden: Bool {
        
        return false
    }
    
    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
}

