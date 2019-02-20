//
//  SHMacroCommandsViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/12.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHMacroCommandsViewController: SHViewController {
    
    /// 宏
    var macro: SHMacro?
    
    /// 所有的宏命令集合
    private lazy var allCommands:[SHMacroCommand] =
        [SHMacroCommand]()
    
    /// 命令列表
    @IBOutlet weak var commandsListView: UITableView!
    
    /// 按钮
    @IBOutlet weak var iconButton: UIButton!
    
    /// 名称
    @IBOutlet weak var nameTextField: UITextField!
    
    /// 顶部显示区域的高度约束
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    /// 图标按钮高度的约束
    @IBOutlet weak var iconButtonHeightConstraint: NSLayoutConstraint!
    
    /// 图标按钮宽度约束
    @IBOutlet weak var iconButtonWidthConstraint: NSLayoutConstraint!
    
    
    /// 图标按钮点击
    @IBAction func iconButtonClick() {
        
        let changeImageController = SHChangeMacroImageViewController()
        
        changeImageController.selectMacroImage = { (macroImageName: String) -> Void in
            
            self.macro!.macroIconName = macroImageName
            
            self.iconButton.setImage(
                UIImage.resize("\(macroImageName)_normal"),
                for: .normal
            )
            
            self.iconButton.setImage(
                UIImage.resize("\(macroImageName)_highlighted"),
                for: .highlighted
            )
             
            _ = SHSQLiteManager.shared.updateMacro(
                self.macro!
            )
        }
        
        let changeImageNavigationController =
            SHNavigationController(
                rootViewController: changeImageController
        )
        
        UIApplication.shared.keyWindow?.rootViewController?.present(
            changeImageNavigationController,
            animated: true,
            completion: nil
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 导航栏设置
        navigationItem.title = "Macro Commands"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(imageName: "addDevice_navigationbar",
                            hightlightedImageName: "addDevice_navigationbar",
                            addTarget: self,
                            action: #selector(addNewComands),
                            isLeft: false
        )
        
        // 初始化列表
        commandsListView.rowHeight =
            SHZoneDeviceGroupSettingCell.rowHeight
        
        commandsListView.register(
            UINib(nibName: deviceGroupSettingCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: deviceGroupSettingCellReuseIdentifier
        )
        
        // 设置界面上的其它内容
        
        iconButton.setImage(
            UIImage.resize("\(macro!.macroIconName!)_normal"),
            for: .normal
        )
        
        iconButton.setImage(
            UIImage.resize("\(macro!.macroIconName!)_highlighted"),
            for: .highlighted
        )
        
        nameTextField.text = macro?.macroName
        
        if UIDevice.is_iPad() {
            
            nameTextField.font = UIView.suitFontForPad()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        if macro == nil {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
            
            return
        }
        
        allCommands =  SHSQLiteManager.shared.getMacroCommands(macro!)
        
        
       
        commandsListView.reloadData()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            headerViewHeightConstraint.constant =
                navigationBarHeight * 2 + statusBarHeight
            
            iconButtonHeightConstraint.constant =
                navigationBarHeight * 2
            
            iconButtonWidthConstraint.constant =
                navigationBarHeight * 2
        }
    }
}


// MARK: - 操作command
extension SHMacroCommandsViewController {
    
    /// 增加新的command
    @objc fileprivate func addNewComands() {
   
        let detailViewController = SHDeviceArgsViewController()
        
        let command = SHMacroCommand()
        command.macroID = macro?.macroID ?? 1
        command.remark = macro?.macroName ?? "macro"
        command.id =
            SHSQLiteManager.shared.insertMacroCommand(
                command
            ) + 1
        
        detailViewController.macroCommand = command
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}



// MARK: - UITableViewDelegate
extension SHMacroCommandsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = SHDeviceArgsViewController()
        
        detailViewController.macroCommand = allCommands[indexPath.row]
            
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "\t\(SHLanguageText.delete)\t") { (action: UITableViewRowAction, indexPath: IndexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let command = self.allCommands[indexPath.row]
            
            self.allCommands.remove(at: indexPath.row)
            
            _ = SHSQLiteManager.shared.deleteMacroCommand(
                command
            )
            
            tableView.reloadData()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: SHLanguageText.edit) { (action: UITableViewRowAction, indexPath: IndexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let detailViewController = SHDeviceArgsViewController()
            
            detailViewController.macroCommand =
                self.allCommands[indexPath.row]
            
            self.navigationController?.pushViewController(
                detailViewController,
                animated: true
            )
        }
    
        return [deleteAction, editAction]
    }
}

// MARK: - UITableViewDataSource
extension SHMacroCommandsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allCommands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: deviceGroupSettingCellReuseIdentifier,
            for: indexPath
        ) as! SHZoneDeviceGroupSettingCell
        
        cell.macroCommand = allCommands[indexPath.row]
        
        return cell
    }
}


// MARK: - UITextFieldDelegate
extension SHMacroCommandsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIView.textWhiteColor()
        textField.textColor = UIColor(white: 0.3, alpha: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        // 修改样式
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIView.textWhiteColor()
        
        // 处理名称: 没有 @“” 就不处理了  // 和cell中原来的标题一样
        
        guard let name = textField.text else {
            
            return
        }
        
        if name.isEqual(macro!.macroName) {
            
            return;
        }
        
        // 更新
        macro!.macroName = name
        
        _ = SHSQLiteManager.shared.updateMacro(macro!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textFieldDidEndEditing(textField)
        
        textField.resignFirstResponder()
    
        return true
    }
}
