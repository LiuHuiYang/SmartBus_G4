//
//  SHSchedualFloorHeatingController.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/10.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHSchedualFloorHeatingController: SHViewController {

    /// 地热
    var schedualFloorHeating: SHFloorHeating?
    

}


// MARK: - UI初始化
extension SHSchedualFloorHeatingController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Schedule floorHeating"
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                imageName: "close",
                hightlightedImageName: "close`",
                addTarget: self,
                action: #selector(close),
                isLeft: true
        )
    }
    
    /// 关闭控制器
    @objc private func close() {
        
        dismiss(animated: true, completion: nil)
    }
}
