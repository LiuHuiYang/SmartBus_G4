//
//  SHDeviceArgsViewController + Light.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - Light
extension SHDeviceArgsViewController {
     
    /// 刷新 light
    func refreshLight() {
        
        argsNames = [
            "Device Name",
            "Subnet ID",
            "Device ID",
            "Channel No.",
            "Can Dim",
            "LightType"
        ]
        
        argsValues = [
            
            light?.lightRemark ?? "light",
            "\(light?.subnetID ?? 0)",
            "\(light?.deviceID ?? 0)",
            "\(light?.channelNo ?? 0)",
            "\((light?.canDim ?? .notDimmable).rawValue)",
            "\((light?.lightTypeID ?? .incandescent).rawValue)"
        ]
    }
    
    /// 保存
    func updateLight(value: String, index: Int) {
        
        guard let light = self.light else {
            return
        }
        
        switch (index) {
        case 0:
            light.lightRemark = value
            
        case 1:
            light.subnetID = UInt8(value) ?? 0
            
        case 2:
            light.deviceID = UInt8(value) ?? 0
            
        case 3:
            light.channelNo = UInt8(value) ?? 0
            
        case 4:
            light.canDim = SHZoneControlLightCanDimType(rawValue: (UInt8(value) ?? 0)) ?? .notDimmable
            
        case 5:
            light.lightTypeID = SHZoneControlLightType(rawValue: (UInt8(value) ?? 1)) ?? .incandescent
            
        default:
            break;
        }
         
        _ = SHSQLiteManager.shared.updateLight(light)
    }
}

