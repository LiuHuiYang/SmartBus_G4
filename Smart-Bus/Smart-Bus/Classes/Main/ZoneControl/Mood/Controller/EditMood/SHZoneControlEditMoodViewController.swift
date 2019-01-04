//
//  SHZoneControlEditMoodViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/11.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

/// cell重用标示
private let moodEditCellReusableIdentifier =  "SHZoneDeviceGroupSettingCell"

@objcMembers class SHZoneControlEditMoodViewController: SHViewController {

    /// 当前区域
    var currentZone: SHZone?
    
    /// 所有的场景
    private lazy var allMoods = [SHMood]()
    
    /// 当前设置的模式
    var currentSetMood: SHMood?
    
    /// 所有的场景列表
    @IBOutlet weak var moodsListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title =
            SHLanguageTools.share()?.getTextFromPlist(
                "MOOD_IN_ZONE",
                withSubTitle: "EDIT_MOOD"
            ) as! String
        
        navigationItem.title = title
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addNewMood),
                isLeft: false
        )

        moodsListView.rowHeight =
            SHZoneDeviceGroupSettingCell.rowHeight
        
        moodsListView.register(
            UINib(nibName: moodEditCellReusableIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                moodEditCellReusableIdentifier
        )
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID,
            let moods = SHSQLManager.share()?.getAllMood(for: zoneID) as? [SHMood] else {
                
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
                
            return
        }
        
        allMoods = moods
        
        moodsListView.reloadData()
    }
    
    /// 添加mood
    @objc private func addNewMood() {
        
        guard let zoneID = currentZone?.zoneID else {
            return
        }
        
        let editMoodViewController =
            SHEditMoodCommandViewController()
        
        let mood = SHMood()
        
        mood.zoneID = zoneID
        mood.moodID =
            ((SHSQLManager.share()?.getMaxMoodID(for: zoneID)) ?? 0) + 1
        
        mood.moodName = "newMood"
        mood.moodIconName = "mood_romantic"
        
        SHSQLManager.share()?.insertNewMood(mood)
        
        editMoodViewController.mood = mood
        
        navigationController?.pushViewController(
            editMoodViewController,
            animated: true
        )
    }
}
 
// MARK: - UITableViewDelegate
extension SHZoneControlEditMoodViewController: UITableViewDelegate {
    
    /// 选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let editCommandController =
            SHEditMoodCommandViewController()
        
        editCommandController.mood = allMoods[indexPath.row]
        
        navigationController?.pushViewController(
            editCommandController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: SHLanguageText.delete) { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let mood = self.allMoods[indexPath.row]
            self.allMoods.remove(at: indexPath.row)
            SHSQLManager.share()?.deleteCurrentMood(mood)
            
            tableView.reloadData()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: SHLanguageText.edit) { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let editCommandController =
                SHEditMoodCommandViewController()
            
            editCommandController.mood =
                self.allMoods[indexPath.row]
            
            self.navigationController?.pushViewController(
                editCommandController,
                animated: true
            )
        }
        
        return [deleteAction, editAction]
    }
    
}

// MARK: - UITableViewDataSource
extension SHZoneControlEditMoodViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allMoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: moodEditCellReusableIdentifier,
                for: indexPath
                ) as! SHZoneDeviceGroupSettingCell

        cell.mood = allMoods[indexPath.row]
        
        return cell
    }
    
    
    
}
