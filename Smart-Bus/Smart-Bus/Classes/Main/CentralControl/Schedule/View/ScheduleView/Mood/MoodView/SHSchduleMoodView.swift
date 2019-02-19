//
//  SHSchduleMoodView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit


class SHSchduleMoodView: UIView, loadNibView {
    
    /*

    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                
                return
            }
            
            allMoods =
                SHSQLiteManager.shared.getMoods(plan.zoneID)
            
            if allMoods.isEmpty {
                
                SVProgressHUD.showInfo(
                    withStatus: SHLanguageText.noData
                )
            }
            
            moodListView.reloadData()
            
            guard let command = SHSQLiteManager.shared.getSchedualCommands(plan.scheduleID).last else {
                
                return
            }
            
            
            for mood in allMoods.enumerated() {
                
                if (mood.element.moodID == command.parameter1) &&
                    (mood.element.zoneID == command.parameter2) {
                    
                    let index =
                        IndexPath(
                            row: mood.offset,
                            section: 0
                    )
                    
                    moodListView.selectRow(
                        at: index,
                        animated: true,
                        scrollPosition: .top
                    )
                    
                    self.tableView(moodListView,
                                   didSelectRowAt: index
                    )
                }
            }
        }
    }
  
 */
}


