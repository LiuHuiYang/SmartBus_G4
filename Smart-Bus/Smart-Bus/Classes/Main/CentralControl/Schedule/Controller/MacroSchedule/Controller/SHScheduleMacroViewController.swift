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
    var schedule: SHSchedual?
    
    /// 所有的宏
    private lazy var macros  = [SHMacro]()
    
    /// 当前选择的宏
    private lazy var selectMacros = NSMutableArray()
    
    /// 宏列表
    @IBOutlet weak var macroListView: UITableView!
   
}


// MARK: - 保存选择的macro
extension SHScheduleMacroViewController {
    
    /// 保存数据
    @objc private func saveMacros() {
        
        guard let saveMacros = selectMacros as? [SHMacro],
            let plan = schedule,
            var commands = plan.commands as? [SHSchedualCommand] else {
            return
        }
        
        // 删除同类型的数据
        _ =
            SHSQLiteManager.shared.deleteSchedualeCommand(
                plan.scheduleID,
                controlType: .marco
        )
        
        // 删除原来的相同类型 command
        commands =
            SHSQLiteManager.shared.getSchedualCommands(
                plan.scheduleID
        )
        
        plan.commands = NSMutableArray(array: commands)
        
        for macro in saveMacros {
            
            let macroCommand = SHSchedualCommand()
            macroCommand.typeID =
                SHSchdualControlItemType.marco.rawValue
            macroCommand.scheduleID = plan.scheduleID
            macroCommand.parameter1 = macro.macroID

            plan.commands.add(macroCommand)
        }
        
        _ = navigationController?.popViewController(
            animated: true
        )
    }
}


// MARK: - UI 初始化
extension SHScheduleMacroViewController {
    
    /// 视图出现展示已配置数据
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            
            return
        }
        
        macros =  SHSQLiteManager.shared.getMacros()
        
        if macros.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        }
        
        macroListView.reloadData()
        
        // ===== 命令部分 =====
        
        guard let commands = plan.commands as? [SHSchedualCommand] else {
            
            return
        }
        
        for command in commands {
            
            if command.typeID != SHSchdualControlItemType.marco.rawValue {
                
                continue
            }
            
            for macro in macros.enumerated() {
                
                if macro.element.macroID == command.parameter1 {
                    
                    let index =
                        IndexPath(
                            row: macro.offset,
                            section: 0
                    )
                    
                    macroListView.selectRow(
                        at: index,
                        animated: true,
                        scrollPosition: .top
                    )
                    
                    self.tableView(macroListView,
                                   didSelectRowAt: index
                    )
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航
        navigationItem.title = "Macro"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "back",
                hightlightedImageName: "back",
                addTarget: self,
                action: #selector(saveMacros),
                isLeft: false
        )
        
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


// MARK: - UITableViewDelegate
extension SHScheduleMacroViewController: UITableViewDelegate {
    
    /// 取消选择
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let macro = macros[indexPath.row]
        
        if selectMacros.contains(macro) {
   
            selectMacros.remove(macro)
        }
    }
    
    /// 选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let macro = macros[indexPath.row]
        
        if selectMacros.contains(macro) == false {
            
            selectMacros.add(macro)
        }
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
