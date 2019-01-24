//
//  SHSchduleMacroView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 重用标示
private let schduleMacroCellReuseIdentifier =
    "SHSchduleMacroCell"

class SHSchduleMacroView: UIView, loadNibView {
    
    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
             
            guard let plan = schedual else {
                
                return
            }
            
            allMacros =  SHSQLiteManager.shared.getMacros()
            
            if allMacros.isEmpty {
                
                SVProgressHUD.showInfo(
                    withStatus: SHLanguageText.noData
                )
            }
            
            marcoListView.reloadData()
            
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

    /// 所有的宏命令
    private lazy var allMacros: [SHMacro] = [SHMacro]()
    
    /// 当前修改的宏命令
    private var selectMacro: SHMacro?

    /// 宏列表
    @IBOutlet weak var marcoListView: UITableView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        marcoListView.register(
            UINib(
                nibName: schduleMacroCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
                schduleMacroCellReuseIdentifier
        )
        
        marcoListView.rowHeight = SHSchduleMacroCell.rowHeight
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveMacro(_:)),
            name: NSNotification.Name.SHSchedualSaveData,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 保存数据
    @objc func saveMacro(_ notification: Notification?) {
    
        guard let type = notification?.object as? SHSchdualControlItemType,
        let plan = schedual else {
            return
        }
        
        if type == .marco {
            
            if selectMacro == nil {
                
                return
            }
            
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
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension SHSchduleMacroView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectMacro = allMacros[indexPath.row]
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allMacros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleMacroCellReuseIdentifier,
                for: indexPath
            ) as! SHSchduleMacroCell
        
        cell.macro = allMacros[indexPath.row]
        
        return cell
    }
}
