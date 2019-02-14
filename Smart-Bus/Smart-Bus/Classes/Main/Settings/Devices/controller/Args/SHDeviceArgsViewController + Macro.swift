//
//  SHDeviceArgsViewController + Macro.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
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
        
        guard let command = macroCommand else {
            return
        }
        
        // 更新每一个参数
        switch index {
            
        case 0:
            command.remark = value
            
        case 1:
            command.subnetID = UInt8(value) ?? 1
            
        case 2:
            command.deviceID = UInt8(value) ?? 0
            
        case 3:
            command.commandTypeID = UInt(value) ?? 0
            
        case 4:
            command.firstParameter = UInt(value) ?? 0
            
        case 5:
            command.secondParameter = UInt(value) ?? 0
            
        case 6:
            command.thirdParameter = UInt(value) ?? 0
            
        case 7:
            command.delayMillisecondAfterSend =
                UInt(value) ?? 0
            
        default:
            break
        }
        
        // 保存到数据库
        _ = SHSQLiteManager.shared.updateMacroCommand(
            command
        )
    }
}
