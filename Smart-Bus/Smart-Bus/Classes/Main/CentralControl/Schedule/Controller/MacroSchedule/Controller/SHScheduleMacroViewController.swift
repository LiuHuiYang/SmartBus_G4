//
//  SHScheduleMacroViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/15.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// 重用标示
private let schduleMacroCellReuseIdentifier =
    "SHSchduleMacroCell"

class SHScheduleMacroViewController: SHViewController {
    
    /// 计划
    var schedule: SHSchedule?
    
    /// 所有的宏
    private lazy var macros =
        SHSQLiteManager.shared.getMacros()
    
    /// 宏列表
    @IBOutlet weak var macroListView: UITableView!
}


// MARK: - 保存选择的macro
extension SHScheduleMacroViewController {
    
    /// 更新macro command 数据
    private func updateScheduleMacroCommands() {
        
        guard let plan = schedule else {
            return
        }
 
        plan.deleteShceduleCommands(.macro)
        
        for macro in macros where macro.scheduleEnable {
            
            let macroCommand = SHSchedualCommand()
            macroCommand.typeID = .macro
            macroCommand.scheduleID = plan.scheduleID
            macroCommand.parameter1 = macro.macroID
            
            plan.commands.append(macroCommand)
        }
    }
}


// MARK: - UI 初始化
extension SHScheduleMacroViewController {
    
    /// 视图消失保存数据
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateScheduleMacroCommands()
    }
    
    /// 视图出现展示已配置数据
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            
            return
        }
        
        // ===== 命令部分 =====
        
        for command in plan.commands where command.typeID == .macro {
            
            for macro in macros {
                
                if macro.macroID == command.parameter1 {
                    
                    macro.scheduleEnable = true
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航
        navigationItem.title = "Macro"
        
        macroListView.allowsMultipleSelection = true
        
        // 注册 cell
        macroListView.register(
            UINib(
                nibName: schduleMacroCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleMacroCellReuseIdentifier
        )
        
        macroListView.rowHeight = SHSchduleMacroCell.rowHeight
    }
}



// MARK: - UITableViewDataSource
extension SHScheduleMacroViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return macros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleMacroCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleMacroCell
        
        cell.macro = macros[indexPath.row]
        
        return cell
    }
}
