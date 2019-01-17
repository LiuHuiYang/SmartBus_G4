//
//  SHDeviceArgsViewController +  Scene.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - Scene 控制
extension SHDeviceArgsViewController {
    
    /// 刷新 scene
    func refreshScene() {
        
        argsNames = [
            "Remark",
            "Subnet ID",
            "Device ID",
            "Area No.",
            "Scene No."
        ]
        
        argsValues = [
            
            scene?.remark ?? "Scene",
            "\(scene?.subnetID ?? 0)",
            "\(scene?.deviceID ?? 0)",
            "\(scene?.areaNo ?? 0)",
            "\(scene?.sceneNo ?? 0)"
        ]
    }
    
    /// 保存
    func updateScene(value: String, index: Int) {
        
        switch (index) {
            
        case 0:
            self.scene?.remark = value
            
        case 1:
            self.scene?.subnetID = UInt8(value) ?? 0
            
        case 2:
            self.scene?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.scene?.areaNo = UInt8(value) ?? 0
            
        case 4:
            self.scene?.sceneNo = UInt8(value) ?? 0
            
        default:
            break;
        }
        
        SHSQLManager.share()?.updateScene(inZone: scene)
    }
}
