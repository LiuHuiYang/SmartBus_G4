//
//  SHSchduleShadeView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit



class SHSchduleShadeView: UIView, loadNibView {
    
    /*
 
    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                    
                return
            }
            
            let commands =
                SHSQLiteManager.shared.getSchedualCommands(
                    plan.scheduleID
            )
             
            allShades = SHSQLiteManager.shared.getShades(plan.zoneID)
            
            for command in commands {
                
                for shade in allShades {
                    
                    if (shade.shadeID == command.parameter1) &&
                        (shade.zoneID == command.parameter2) {
                        
                        shade.currentStatus =
                            SHShadeStatus(
                                rawValue: command.parameter3
                            ) ?? .unKnow
                    }
                }
            }
            
     
        }
    }
    
    /// 所有的窗帘
    private lazy var allShades: [SHShade] = [SHShade]()
    
    
    /// 保存数据
    @objc func saveShade(_ notification: Notification?) {
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .shade {
            
            // 先删除以前的命令
            _ = SHSQLiteManager.shared.deleteSchedualeCommands(
                plan
            )
            
            for shade in allShades {
                
                let command = SHSchedualCommand()
                
                command.typeID =
                    SHSchdualControlItemType.shade.rawValue
                
                command.scheduleID = plan.scheduleID
                
                command.parameter1 = shade.shadeID
                command.parameter2 = shade.zoneID
                command.parameter3 =
                    shade.currentStatus.rawValue
           
                _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
            }
        }
    }
 
 */
}
