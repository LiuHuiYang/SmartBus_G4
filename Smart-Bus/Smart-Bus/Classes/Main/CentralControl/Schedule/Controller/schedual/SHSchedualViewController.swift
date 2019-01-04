//
//  SHSchedualViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/5.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 计划cel重用标示
private let schedualViewCellReuseIdentifier = "SHScheduleViewCell"

class SHSchedualViewController: SHViewController {

    ///所有的计划列表
    private lazy var allSchedules = [SHSchedual]()
    
    /// 高度约束
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    /// 编辑按钮的高度
    @IBOutlet weak var editButtonHeightConstraint: NSLayoutConstraint!
    
    /// 计划名称
    @IBOutlet weak var scheduleNameLabel: UILabel!
    
    /// 频率
    @IBOutlet weak var frequencyLabel: UILabel!
    
    /// 日期
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    /// 是否开启
    @IBOutlet weak var validityLabel: UILabel!
    
    /// 计划列表
    @IBOutlet weak var scheduleTableView: UITableView!
    
    /// 编辑计划列表按钮
    @IBOutlet weak var editScheduleButton: UIButton!
    
    /// 编辑计算列表
    @IBAction func editScheduleClick() {
        
        let editViewController = SHSchedualEditViewController()
        
        editViewController.isAddSedual = true
        
        let schedual = SHSchedual()
        schedual.scheduleID = (SHSQLManager.share()?.getMaxScheduleID() ?? 0) + 1
        schedual.scheduleName = "new schedule"
        schedual.controlledItemID = .marco
        schedual.frequencyID = .oneTime
        
        editViewController.schedual = schedual
        
        navigationController?.pushViewController(
            editViewController,
            animated: true
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         // 设置导航栏
        navigationItem.title =
            (SHLanguageTools.share()?.getTextFromPlist(
                "SCHEDULE",
                withSubTitle: "TITLE_NAME")
            ) as? String
        
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(imageName: "setting",
                            hightlightedImageName: "setting",
                            addTarget: self,
                            action: #selector(navigationrightItemClick),
                            isLeft: false
        )
        
        // 其它语言适配
        scheduleNameLabel.text =
            (SHLanguageTools.share()?.getTextFromPlist(
                "SCHEDULE",
                withSubTitle: "SCHEDULE_NAME")
            ) as? String
        
        frequencyLabel.text =
            (SHLanguageTools.share()?.getTextFromPlist(
                "SCHEDULE",
                withSubTitle: "FREQUENCY")
            ) as? String
        
        dateTimeLabel.text =
            (SHLanguageTools.share()?.getTextFromPlist(
                "SCHEDULE",
                withSubTitle: "DATE_TIME")
            ) as? String
        
        validityLabel.text =
            (SHLanguageTools.share()?.getTextFromPlist(
                "SCHEDULE",
                withSubTitle: "VALIDITY")
            ) as? String
        
        navigationItem.title =
            (SHLanguageTools.share()?.getTextFromPlist(
                "SCHEDULE",
                withSubTitle: "TITLE_NAME")
            ) as? String
  
        
        editScheduleButton.setTitle(
            SHLanguageText.newSchedual,
            for: .normal
        )
        
        editScheduleButton.titleLabel?.numberOfLines = 0
        editScheduleButton.setRoundedRectangleBorder()
        
        
        // 初始化表格
        scheduleTableView.allowsSelectionDuringEditing = true
        scheduleTableView.rowHeight = SHScheduleViewCell.rowHeight
        scheduleTableView.register(
            UINib(nibName: schedualViewCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: schedualViewCellReuseIdentifier
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            scheduleNameLabel.font = font
            frequencyLabel.font = font
            dateTimeLabel.font = font
            validityLabel.font = font
            editScheduleButton.titleLabel?.font = font
        }
    }
    
 
    /// 右侧点击
    @objc private func navigationrightItemClick() {
        
        let settingViewController = SHSchedualSettingViewController()
        
        navigationController?.pushViewController(
            settingViewController,
            animated: true
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            headerViewHeightConstraint.constant =
                (navigationBarHeight + tabBarHeight)
            
            editButtonHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        allSchedules =
            (SHSQLManager.share()?.getAllSchdule() as? [SHSchedual]) ?? [SHSchedual]()
        
        scheduleTableView.reloadData()
    }
}


// MARK: - UITableViewDelegate
extension SHSchedualViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editViewController = SHSchedualEditViewController()
        
        editViewController.isAddSedual = false
        
        editViewController.schedual = allSchedules[indexPath.row]
        
        navigationController?.pushViewController(
            editViewController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let schedual = allSchedules[indexPath.row]
            
            allSchedules.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            SHSQLManager.share()?.deleteScheduale(schedual)
            
            SHSchedualExecuteTools.share().updateSchduals()
        }
    }
}

// MARK: - UITableViewDataSource
extension SHSchedualViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schedualViewCellReuseIdentifier,
                for: indexPath
            ) as! SHScheduleViewCell
        
        cell.schedual = allSchedules[indexPath.row]
        cell.isAddSchedual = false
        
        return cell
    }
    
    
}
