//
//  SHScheduleMoodViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// mood重用标示
private let schduleMoodCellReuseIdentifier =
    "SHSchduleMoodCell"

class SHScheduleMoodViewController: SHViewController {

    /// 计划
    var schedule: SHSchedule?
    
    /// 当前选择的宏
    private lazy var selectMoods = [SHMood]()
    
    /// 包含mood的所有区域
    private lazy var moodZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.mood.rawValue
    )
    
    /// mood 列表
    @IBOutlet weak var moodListView: UITableView!
    
}


// MARK: - 保存数据
extension SHScheduleMoodViewController {
    
    
    /// 保存选择的mood
    @objc private func saveMoodsClick() {
        
        guard let saveMoods = selectMoods as? [SHMood],
            let plan = schedule else {
            return
        }
        
        // 删除同类型的数据
        _ =
            SHSQLiteManager.shared.deleteSchedualeCommand(
                plan.scheduleID,
                controlType: .mood
        )
        
        // 更新 plan 中的 命令
        let commands =
            SHSQLiteManager.shared.getSchedualCommands(
                plan.scheduleID
        )
        
        plan.commands = commands
        
        // 创建命令集合
        for mood in saveMoods {
            
            let command = SHSchedualCommand()
            command.typeID =
                SHSchdualControlItemType.mood.rawValue
            command.scheduleID = plan.scheduleID
            command.parameter1 = mood.moodID
            command.parameter2 = mood.zoneID
            
            plan.commands.append(command)
        }
        
        _ = navigationController?.popViewController(
            animated: true
        )
    }
}


// MARK: - UI 初始化
extension SHScheduleMoodViewController {
    
    
    /// 设置已配置的信息
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            
            return
        }
        
        moodListView.reloadData()
        
        // ===== 命令部分 =====
        
        guard let commands = plan.commands as? [SHSchedualCommand] else {
            
            return
        }
        
        for command in commands {
            
            if command.typeID !=
                SHSchdualControlItemType.mood.rawValue {
                
                continue
            }
            
            // 查询所有的区域
            for moodZone in moodZones.enumerated() {
                
                let sectionMoods =
                    SHSQLiteManager.shared.getMoods(
                        moodZone.element.zoneID
                )
                
                for mood in sectionMoods.enumerated() {
                    
                    if mood.element.moodID ==
                            command.parameter1
                        &&
                        
                        mood.element.zoneID ==
                            command.parameter2 {
                        
                        let index =
                            IndexPath(
                                row: mood.offset,
                                section: moodZone.offset
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航
        navigationItem.title = "Mood"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "back",
                hightlightedImageName: "back",
                addTarget: self,
                action: #selector(saveMoodsClick),
                isLeft: false
        )
        
        // 注册cell
        moodListView.register(
            UINib(
                nibName: schduleMoodCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleMoodCellReuseIdentifier
        )
        
        moodListView.rowHeight = SHSchduleMoodCell.rowHeight
    }

}


// MARK: - UITableViewDelegate
extension SHScheduleMoodViewController: UITableViewDelegate {
    
    /// 取消选择
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // 获得每个区域
        let moodZone = moodZones[indexPath.section]
        
        // 获得每组的mood
        let sectionMoods =
            SHSQLiteManager.shared.getMoods(moodZone.zoneID)
        
        let selectMood = sectionMoods[indexPath.row]
        
        for mood in sectionMoods.enumerated() {
            
            if mood.element.moodID == selectMood.moodID {
                
                selectMoods.remove(at: mood.offset)
            }
        }
    }
    
    /// 选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 获得每个区域
        let moodZone = moodZones[indexPath.section]
        
        // 获得每组的mood
        let sectionMoods =
            SHSQLiteManager.shared.getMoods(moodZone.zoneID)
        
        let mood = sectionMoods[indexPath.row]
        
        if selectMoods.contains(mood) == false {
            
            selectMoods.append(mood)
        }
        
        print(selectMoods)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return defaultHeight
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let customView = UIView()
//
//        customView.backgroundColor = UIColor.red
//
//        return customView
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return moodZones[section].zoneName ?? "zone"
    }
}

// MARK: - UITableViewDataSource
extension SHScheduleMoodViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return moodZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 获得每个区域
        let moodZone = moodZones[section]
        
        // 获得每组的mood
        let sectionMoods =
            SHSQLiteManager.shared.getMoods(moodZone.zoneID)
        
        return sectionMoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleMoodCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleMoodCell
        
        // 获得每个区域
        let moodZone = moodZones[indexPath.section]
        
        // 获得每组的mood
        let sectionMoods =
            SHSQLiteManager.shared.getMoods(moodZone.zoneID)
        
        cell.mood = sectionMoods[indexPath.row]
        
        return cell
    }
}
