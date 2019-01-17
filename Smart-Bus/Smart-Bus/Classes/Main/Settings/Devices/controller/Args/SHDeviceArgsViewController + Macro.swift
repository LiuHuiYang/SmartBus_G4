//
//  SHDeviceArgsViewController + Macro.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import Foundation

// MARK: - macroCommand
extension SHDeviceArgsViewController {
    
    func refreshMacroCommand() {
        
        argsNames = [
            "Remark",
            "Subnet ID",
            "Device ID",
            "CommandTypeID",
            "First Parameter",
            "Second Parameter",
            "Third Parameter",
            "Delay Millisecond AfterSend"
        ]
        
        argsValues = [
            
            macroCommand?.remark ?? "macro Command",
            "\(macroCommand?.subnetID ?? 1)",
            "\(macroCommand?.deviceID ?? 0)",
            "\(macroCommand?.commandTypeID ?? 0)",
            "\(macroCommand?.firstParameter ?? 0)",
            "\(macroCommand?.secondParameter ?? 0)",
            "\(macroCommand?.thirdParameter ?? 0)",
            "\(macroCommand?.delayMillisecondAfterSend ?? 0)"
        ]
    }
    
    /// 更新
    func updateMacroCommand(value: String, index: Int) {
        
        // 更新每一个参数
        switch index {
            
        case 0:
            self.macroCommand?.remark = value
            
        case 1:
            self.macroCommand?.subnetID = UInt8(value) ?? 1
            
        case 2:
            self.macroCommand?.deviceID = UInt8(value) ?? 0
            
        case 3:
            self.macroCommand?.commandTypeID = UInt(value) ?? 0
            
        case 4:
            self.macroCommand?.firstParameter = UInt(value) ?? 0
            
        case 5:
            self.macroCommand?.secondParameter = UInt(value) ?? 0
            
        case 6:
            self.macroCommand?.thirdParameter = UInt(value) ?? 0
            
        case 7:
            self.macroCommand?.delayMillisecondAfterSend =
                UInt(value) ?? 0
            
        default:
            break
        }
        
        // 保存到数据库
        SHSQLManager.share()?.updateCentralMacroCommand(
            macroCommand
        )
    }
}
