//
//  SHSchduleMacroView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHSchduleMacroView: UIView, loadNibView {
    
    /*
    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
             
            guard let plan = schedual else {
                
                return
            }
            
            
//            marcoListView.reloadData()
            
            // 查找要的计划具体的指令
            guard let command = SHSQLiteManager.shared.getSchedualCommands(plan.scheduleID).last else {
                
                return
            }
            
            for macro in allMacros.enumerated() {
                
                if macro.element.macroID == command.parameter1 {
                    
                    let index =
                        IndexPath(
                            row: macro.offset,
                            section: 0
                    )
                    
                    marcoListView.selectRow(
                        at: index,
                        animated: true,
                        scrollPosition: .top
                    )
                    
                    self.tableView(marcoListView,
                                   didSelectRowAt: index
                    )
                }
            }
            
        }
    }
   
    /// 保存数据
    @objc func saveMacro(_ notification: Notification?) {
    
        guard let type = notification?.object as? SHSchdualControlItemType,
        let plan = schedual else {
            return
        }
        
        if type == .marco {
            
            // 先删除以前的命令
           _ = SHSQLiteManager.shared.deleteSchedualeCommand(
                plan
            )
            
            // 保存到数据库
            let command = SHSchedualCommand()
            command.typeID =
                SHSchdualControlItemType.marco.rawValue
            command.scheduleID = plan.scheduleID
            command.parameter1 = selectMacro!.macroID
            
            _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
            
        }
    }
 
 */
}

