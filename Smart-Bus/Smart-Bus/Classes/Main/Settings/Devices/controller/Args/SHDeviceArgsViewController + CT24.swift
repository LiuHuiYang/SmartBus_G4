//
//  SHDeviceArgsViewController + CT24.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation


// MARK: - CT24
extension SHDeviceArgsViewController {
    
    /// 刷新CT24
    func refreshCurrentTransformer() {
        
        // 属性名称
        argsNames = [
            "Remark",
            "Subnet ID",
            "Device ID",
            "Voltage",
            "Channnel1 remark",
            "Channnel2 remark",
            "Channnel3 remark",
            "Channnel4 remark",
            "Channnel5 remark",
            "Channnel6 remark",
            "Channnel7 remark",
            "Channnel8 remark",
            "Channnel9 remark",
            "Channnel10 remark",
            "Channnel11 remark",
            "Channnel12 remark",
            "Channnel13 remark",
            "Channnel14 remark",
            "Channnel15 remark",
            "Channnel16 remark",
            "Channnel17 remark",
            "Channnel18 remark",
            "Channnel19 remark",
            "Channnel20 remark",
            "Channnel21 remark",
            "Channnel22 remark",
            "Channnel23 remark",
            "Channnel24 remark"
        ]
        
        // 属性值
        argsValues = [
            currentTransformer?.remark ?? "CT24",
            "\(currentTransformer?.subnetID ?? 1)",
            "\(currentTransformer?.deviceID ?? 0)",
            "\(currentTransformer?.voltage ?? 0)",
            
            "\(currentTransformer?.channel1 ?? "CH1")",
            "\(currentTransformer?.channel2 ?? "CH2")",
            "\(currentTransformer?.channel3 ?? "CH3")",
            "\(currentTransformer?.channel4 ?? "CH4")",
            "\(currentTransformer?.channel5 ?? "CH5")",
            "\(currentTransformer?.channel6 ?? "CH6")",
            "\(currentTransformer?.channel7 ?? "CH7")",
            "\(currentTransformer?.channel8 ?? "CH8")",
            "\(currentTransformer?.channel9 ?? "CH9")",
            "\(currentTransformer?.channel10 ?? "CH10")",
            "\(currentTransformer?.channel11 ?? "CH11")",
            "\(currentTransformer?.channel12 ?? "CH12")",
            "\(currentTransformer?.channel13 ?? "CH13")",
            "\(currentTransformer?.channel14 ?? "CH14")",
            "\(currentTransformer?.channel15 ?? "CH15")",
            "\(currentTransformer?.channel16 ?? "CH16")",
            "\(currentTransformer?.channel17 ?? "CH17")",
            "\(currentTransformer?.channel18 ?? "CH18")",
            "\(currentTransformer?.channel19 ?? "CH19")",
            "\(currentTransformer?.channel20 ?? "CH20")",
            "\(currentTransformer?.channel21 ?? "CH21")",
            "\(currentTransformer?.channel22 ?? "CH22")",
            "\(currentTransformer?.channel23 ?? "CH23")",
            "\(currentTransformer?.channel24 ?? "CH24")"
            
        ]
    }
    
    /// 更新并保存CT24
    func updateCurrentTransformer(value: String, index: Int) {
        
        guard let ct24 = self.currentTransformer else {
            return
        }
        
        // 更新每一个参数
        switch index {
            
        case 0:
            ct24.remark = value
            
        case 1:
            ct24.subnetID = UInt8(value) ?? 1
            
        case 2:
            ct24.deviceID = UInt8(value) ?? 0
            
        case 3:
            ct24.voltage = UInt(value) ?? 0
            
        case 4:
            ct24.channel1 = value
            
        case 5:
            ct24.channel2 = value
            
        case 6:
            ct24.channel3 = value
            
        case 7:
            ct24.channel4 = value
            
        case 8:
            ct24.channel5 = value
            
        case 9:
            ct24.channel6 = value
            
        case 10:
            ct24.channel7 = value
            
        case 11:
            ct24.channel8 = value
            
        case 12:
            ct24.channel9 = value
            
        case 13:
            ct24.channel10 = value
            
        case 14:
            ct24.channel11 = value
            
        case 15:
            ct24.channel12 = value
            
        case 16:
            ct24.channel13 = value
            
        case 17:
            ct24.channel14 = value
            
        case 18:
            ct24.channel15 = value
            
        case 19:
            ct24.channel16 = value
            
        case 20:
            ct24.channel17 = value
            
        case 21:
            ct24.channel18 = value
            
        case 22:
            ct24.channel19 = value
            
        case 23:
            ct24.channel20 = value
            
        case 24:
            ct24.channel21 = value
            
        case 25:
            ct24.channel22 = value
            
        case 26:
            ct24.channel23 = value
            
        case 27:
            ct24.channel24 = value
            
        default:
            break
        }
       
        _ = SHSQLiteManager.shared.updateCurrentTransformer(
            ct24
        )
    }
}
