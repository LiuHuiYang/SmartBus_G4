//
//  SHEditMoodCommandViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/30.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHEditMoodCommandViewController: SHViewController {
    
    /// 场景
   @objc var mood: SHMood?
    
    /// 所有的场景指令集
    private lazy var allCommands = [SHMoodCommand]()
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    /// 按钮高度
    @IBOutlet weak var iconButtonHeightConstraint: NSLayoutConstraint!
    
    /// 按钮宽度
    @IBOutlet weak var iconButtonWidthConstraint: NSLayoutConstraint!
    
    /// 图标按钮
    @IBOutlet weak var iconButton: UIButton!
    
    /// 名称
    @IBOutlet weak var nameTextField: UITextField!
    
    /// 指令列表
    @IBOutlet weak var moodCommandsListView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Mood Commands"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addNewComands),
                isLeft: false
        )
        
        moodCommandsListView.rowHeight = SHZoneDeviceGroupSettingCell.rowHeight
        
        moodCommandsListView.register(
            UINib(nibName: deviceGroupSettingCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: deviceGroupSettingCellReuseIdentifier
        )
        
        nameTextField.text = mood?.moodName
        
        iconButton.setImage(
            UIImage(named: "\(mood?.moodIconName ?? "")_normal"),
            for: UIControl.State.normal
        )
        
        iconButton.setImage(
            UIImage(named: "\(mood?.moodIconName ?? "")_highlighted"),
            for: UIControl.State.highlighted
        )
        
        if UIDevice.is_iPad() {
            nameTextField.font = UIView.suitFontForPad()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mood != nil {
            
            allCommands =
                SHSQLiteManager.shared.getMoodCommands(mood!)
        }
        
        moodCommandsListView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            headerViewHeightConstraint.constant = (navigationBarHeight * 2 + statusBarHeight)
            
            iconButtonWidthConstraint.constant =
                (navigationBarHeight * 2)
            
            iconButtonHeightConstraint.constant =
                (navigationBarHeight * 2)
        }
    }
    
    // MARK: - 点击事件
    @IBAction func iconButtonClick() {
        
        let changeMoodImageController =
            SHChangeMoodImageViewController()
        
        changeMoodImageController.selectMoodImage = {(moodIconName: String?) -> () in
            
            guard let name = moodIconName,
            let mood = self.mood else {
                return
            }
            
            if name == mood.moodIconName {
                
                return
            }
            
            mood.moodIconName = name
            
            self.iconButton.setImage(
                UIImage.resize(name + "_normal"),
                for: UIControl.State.normal
            )
            
            self.iconButton.setImage(
                UIImage.resize(name + "_highlighted"),
                for: UIControl.State.highlighted
            )
            
            _ = SHSQLiteManager.shared.updateMood(mood)
        }
        
        let changeImageNavigationController =
            SHNavigationController(
                rootViewController: changeMoodImageController
        )
        
    UIApplication.shared.keyWindow?.rootViewController?.present(
            changeImageNavigationController,
            animated: true,
            completion: nil
        )
        
    }
}


// MARK: - 添加新的命令
extension SHEditMoodCommandViewController {
    
    @objc fileprivate func addNewComands() {
        
        let detailViewController = SHDeviceArgsViewController()
        
        let command = SHMoodCommand()
        command.moodID = mood!.moodID
        command.zoneID = mood!.zoneID
        command.deviceName = "device name"
        command.id =
            SHSQLiteManager.shared.getMaxIDForMoodCommand() + 1
          
        _ = SHSQLiteManager.shared.insertMoodCommand(command)
        
        detailViewController.moodCommand = command
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}


// MARK: - UITableViewDelegate
extension SHEditMoodCommandViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = SHDeviceArgsViewController()
        
        detailViewController.moodCommand =
            allCommands[indexPath.row]
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "\t\(SHLanguageText.delete)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let command = self.allCommands[indexPath.row]
            
            self.allCommands.remove(at: indexPath.row)
            
            _ = SHSQLiteManager.shared.deleteMoodCommand(
                command
            )
            
            tableView.reloadData()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: SHLanguageText.edit) { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let detailViewController = SHDeviceArgsViewController()
            
            detailViewController.moodCommand = self.allCommands[indexPath.row]
            
            self.navigationController?.pushViewController(
                detailViewController,
                animated: true
            )
        }
        
        return [deleteAction, editAction]
    }
}

// MARK: - UITableViewDataSource
extension SHEditMoodCommandViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allCommands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: deviceGroupSettingCellReuseIdentifier,
            for: indexPath
        ) as! SHZoneDeviceGroupSettingCell
        
        cell.moodCommand = allCommands[indexPath.row]
        
        return cell
    }
}


// MARK: - UITextFieldDelegate
extension SHEditMoodCommandViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIView.textWhiteColor()
        textField.textColor = UIColor(white: 0.3, alpha: 1.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIView.textWhiteColor()
        
        guard let scene = mood,
            let name = textField.text else {
            SVProgressHUD.showInfo(withStatus: "The name cannot be empty!")
            return false
        }
        
        // 获得新名字
        scene.moodName = name
        textField.endEditing(true)
        
        _ = SHSQLiteManager.shared.updateMood(scene)
        
        return true
    }
}
