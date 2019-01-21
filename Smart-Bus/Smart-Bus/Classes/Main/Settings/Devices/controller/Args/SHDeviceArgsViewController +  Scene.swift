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
        
        guard let scene = self.scene else {
            return
        }
        
        switch (index) {
            
        case 0:
            scene.remark = value
            
        case 1:
            scene.subnetID = UInt8(value) ?? 0
            
        case 2:
            scene.deviceID = UInt8(value) ?? 0
            
        case 3:
            scene.areaNo = UInt8(value) ?? 0
            
        case 4:
            scene.sceneNo = UInt8(value) ?? 0
            
        default:
            break;
        }
         
        SHSQLiteManager.shared.updateScene(scene)
    }
}
