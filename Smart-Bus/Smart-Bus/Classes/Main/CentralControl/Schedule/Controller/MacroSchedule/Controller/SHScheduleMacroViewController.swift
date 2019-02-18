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
    
    /// 保存的闭包回调
    var saveMacroCommands: ((_ macroCommand: [SHSchedualCommand]) -> ())?
    
    /// 计划命令集
//    private lazy var commands = [SHSchedualCommand]()
    
    /// 所有的宏命令
    private lazy var macros  = [SHMacro]()
    
    /// 当前选择的宏命令
    private lazy var selectMacros = NSMutableArray()
    
    /// 宏列表
    @IBOutlet weak var macroListView: UITableView!
    
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
        
        guard let commands = plan.commands as? [SHSchedualCommand] else {
            
            return
        }
        
        // ===== 命令部分 =====
        
        // 查找要的计划具体的指令
//        let commands =
//            SHSQLiteManager.shared.getSchedualCommands(
//                plan.scheduleID
//        )
        
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


// MARK: - 保存选择的macro
extension SHScheduleMacroViewController {
    
   
    /// 保存数据
    @objc private func saveMacros() {
        
        guard let saveMacros = selectMacros as? [SHMacro],
            let plan = schedule,
            var commands = plan.commands as? [SHSchedualCommand] else {
            return
        }
        
//        commands.removeAll()
//
//        // schedule 中的 macro 部分保存到内存中
//
//        for macro in saveMacros {
//
//            let macroCommand = SHSchedualCommand()
//            macroCommand.typeID =
//                SHSchdualControlItemType.marco.rawValue
//            macroCommand.scheduleID = plan.scheduleID
//            macroCommand.parameter1 = macro.macroID
//
////            commands.append(macroCommand)
//        }
//
//        print(commands.count)
//
//        // 执行闭包回调
//        saveMacroCommands?(commands)
        
        // 删除同类型的数据
        _ =
            SHSQLiteManager.shared.deleteSchedualeCommand(
                plan.scheduleID,
                controlType: .marco
        )
        
        var macroCommands = [SHSchedualCommand]()
        for macro in saveMacros {
            
            let macroCommand = SHSchedualCommand()
            macroCommand.typeID =
                SHSchdualControlItemType.marco.rawValue
            macroCommand.scheduleID = plan.scheduleID
            macroCommand.parameter1 = macro.macroID
            
            macroCommands.append(macroCommand)
            commands.append(macroCommand)
        }
        
        // 执行闭包回调
//        saveMacroCommands?(macroCommands)
        
        print(plan.commands.count)
        
        _ = navigationController?.popViewController(
            animated: true
        )
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
