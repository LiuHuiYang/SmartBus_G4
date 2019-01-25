//
//  SHTabBarController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/13.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHTabBarController: UITabBarController {
    
    /// 背景图片
    private lazy var backgroundView: UIImageView = {
       
        let background =
            UIImageView(image: UIImage.resize("background"))
        
        background.isUserInteractionEnabled = true
        
        return background
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if children.isEmpty {
            
            view.addSubview(backgroundView)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if children.isEmpty {
            
            backgroundView.frame = view.bounds
        }
    }

}
