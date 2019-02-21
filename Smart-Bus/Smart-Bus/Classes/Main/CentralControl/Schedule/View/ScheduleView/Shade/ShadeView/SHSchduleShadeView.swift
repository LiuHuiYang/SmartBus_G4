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
    
   
 */
}
