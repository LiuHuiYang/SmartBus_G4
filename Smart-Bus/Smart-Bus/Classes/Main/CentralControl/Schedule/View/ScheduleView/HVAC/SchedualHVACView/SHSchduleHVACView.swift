//
//  SHSchduleHVACView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit
 

class SHSchduleHVACView: UIView, loadNibView {
    /*
    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                return
            }
            
            if plan.isDifferentZoneSchedual ||
                (!plan.isDifferentZoneSchedual &&
                    hvacs.count == 0) {
                
                let commands =
                    SHSQLiteManager.shared.getSchedualCommands(
                        plan.scheduleID
                )
               
                hvacs =
                    SHSQLiteManager.shared.getHVACs(
                        plan.zoneID
                )
                
                for hvac in hvacs {
                    
                    for command in commands {
                        
                        if command.typeID != SHSchdualControlItemType.HVAC.rawValue {
                            
                            continue
                        }
                        
                        if (hvac.subnetID == command.parameter1) &&
                            (hvac.deviceID == command.parameter2) {
                            
                            // 只要是存在的命令就一定是选中的
                            hvac.schedualEnable = true
                            
                            hvac.schedualIsTurnOn = (command.parameter3 != 0)
                            
                            hvac.schedualFanSpeed = SHAirConditioningFanSpeedType(rawValue: UInt8(command.parameter4)) ?? .auto;
                            
                            hvac.schedualMode = SHAirConditioningModeType(rawValue: UInt8(command.parameter5)) ?? .cool;
                            
                            hvac.schedualTemperature = Int(command.parameter6);
                            
                        }
                    }
                }
            }
            
            
            allHVACListView.reloadData()
        }
    }
 
    /// 保存数据
    @objc func saveHVAC(_ notification: Notification?) {
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .HVAC {
            
            // 先删除以前的命令
            _ = SHSQLiteManager.shared.deleteSchedualeCommands(
                plan
            )
            
            for hvac in hvacs {
                
                if hvac.schedualEnable == false {
                    
                    continue
                }
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID =
                    SHSchdualControlItemType.HVAC.rawValue
                
                command.parameter1 = UInt(hvac.subnetID)
                command.parameter2 = UInt(hvac.deviceID)
                
                command.parameter3 =
                    hvac.schedualIsTurnOn ? 1 : 0
                command.parameter4 = UInt(hvac.schedualFanSpeed.rawValue)
                command.parameter5 = UInt(hvac.schedualMode.rawValue)
                
                 // 模式温度 -> 具体是哪种模式温度 取决于 parameter5
                command.parameter6 = UInt(hvac.schedualTemperature)
                
                _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
            }
        }
    }

 */
    
}

