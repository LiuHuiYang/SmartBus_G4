//
//  SHSchduleLightView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit


class SHSchduleLightView: UIView, loadNibView {
     /*
    /// 计划模型
    var schedual: SHSchedual? {
        
       
        didSet {
         
            guard let plan = schedual else {
                return
            }
            
            if plan.isDifferentZoneSchedual ||
                (!plan.isDifferentZoneSchedual &&
                allLights.count == 0) {
                
                allLights =
                    SHSQLiteManager.shared.getLights(
                        plan.zoneID
                )
               
                let commands =
                    SHSQLiteManager.shared.getSchedualCommands(
                        plan.scheduleID
                )
                
                if commands.isEmpty {
                    return
                }
                
                for light in allLights {
                    
                    for command in commands {
                        
                        if command.typeID != SHSchdualControlItemType.light.rawValue {
                            
                            continue
                        }
                        
                        if (light.lightID == command.parameter1) &&
                            (light.zoneID == command.parameter2) {
                            
                            // 只要是存在的命令就一定是选中的
                            light.schedualEnable = true
                            
                            if light.lightTypeID == .led {
                                
                                light.schedualRedColor = UInt8(command.parameter3)
                                
                                light.schedualGreenColor = UInt8(command.parameter4)
                                
                                light.schedualBlueColor = UInt8(command.parameter5)
                                
                                light.schedualWhiteColor = UInt8(command.parameter6)
                                
                            } else {
                                
                                light.schedualBrightness = UInt8(command.parameter3)
                            }
                        }
                    }
                }
            }
            
        }
 
    }

   
    /// 保存数据
    @objc func saveLight(_ notification: Notification?){
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .light {
            
            // 先删除以前的命令
            _ = SHSQLiteManager.shared.deleteSchedualeCommands(
                plan
            )
            
            for light in allLights {
                
                if light.schedualEnable == false {
                    
                    continue
                }
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID =
                    SHSchdualControlItemType.light.rawValue
                command.parameter1 = light.lightID
                command.parameter2 = plan.zoneID
                
                if light.lightTypeID == .led {
                    
                    command.parameter3 = UInt(light.schedualRedColor)
                    
                    command.parameter4 = UInt(light.schedualGreenColor)
                    
                    command.parameter5 = UInt(light.schedualBlueColor)
                    
                    command.parameter6 = UInt(light.schedualWhiteColor)
                    
                    
                } else {
                    
                    command.parameter3 =
                        UInt(light.schedualBrightness)
                }
                
                _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
            }
        }
    }
*/
}
 
