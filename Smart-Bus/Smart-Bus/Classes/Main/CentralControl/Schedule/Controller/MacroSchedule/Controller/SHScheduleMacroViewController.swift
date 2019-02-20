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
    private lazy var macros = [SHMacro]()
    
    /// 当前选择的宏
    private lazy var selectMacros = [SHMacro]()
    
    /// 宏列表
    @IBOutlet weak var macroListView: UITableView!
}


// MARK: - 保存选择的macro
extension SHScheduleMacroViewController {
    
    /// 保存数据
    @objc private func saveMacrosClick() {
        
        guard let plan = schedule else {
            return
        }
        
        // 删除同类型的数据
        _ =
            SHSQLiteManager.shared.deleteSchedualeCommand(
                plan.scheduleID,
                controlType: .marco
        )
        
        // 更新 plan 中的 命令
        plan.commands =
            SHSQLiteManager.shared.getSchedualCommands(
                plan.scheduleID
        )
        
        for macro in selectMacros {
            
            let macroCommand = SHSchedualCommand()
            macroCommand.typeID = .marco
            macroCommand.scheduleID = plan.scheduleID
            macroCommand.parameter1 = macro.macroID
            
            plan.commands.append(macroCommand)
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
        
        for command in plan.commands {
            
            if command.typeID != .marco {
                
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
                action: #selector(saveMacrosClick),
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
        
        let selectMacro = macros[indexPath.row]
        
        for macro in selectMacros.enumerated() {
            
            if macro.element.macroID == selectMacro.macroID {
                
                selectMacros.remove(at: macro.offset)
            }
        }
    }
    
    /// 选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectMacro = macros[indexPath.row]
        
        for macro in selectMacros {
            
            if macro.macroID == selectMacro.macroID {
                
                return
            }
        }
        
        // 来到这里肯定是不存在
        selectMacros.append(selectMacro)
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
