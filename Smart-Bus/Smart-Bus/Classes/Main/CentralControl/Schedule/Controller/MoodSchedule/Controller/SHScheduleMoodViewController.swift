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
    

    /// 更新选择的mood命令数据
    private func updateScheduleMoodCommands() {
        
        guard let plan = schedule else {
            return
        }
        
        plan.deleteShceduleCommands(.mood)
        
        // 创建命令集合
        for mood in selectMoods {
            
            let command = SHSchedualCommand()
            command.typeID = .mood
            command.scheduleID = plan.scheduleID
            command.parameter1 = mood.moodID
            command.parameter2 = mood.zoneID
            
            plan.commands.append(command)
            
        }
    }
}


// MARK: - UI 初始化
extension SHScheduleMoodViewController {
    
    /// 视图消失保存数据
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateScheduleMoodCommands()
    }
    
    /// 设置已配置的信息
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            
            return
        }
        
        moodListView.reloadData()
        
        // ===== 命令部分 =====
        
        for command in plan.commands where command.typeID == .mood {
            
            // 查询所有的区域
            for moodZone in moodZones.enumerated() {
                
                let sectionMoods =
                    SHSQLiteManager.shared.getMoods(
                        moodZone.element.zoneID
                )
                
                for (index, mood) in sectionMoods.enumerated() {
                    
                    if mood.moodID == command.parameter1 &&
                       mood.zoneID == command.parameter2 {
                        
                        let indexPath =
                            IndexPath(
                                row: index,
                                section: moodZone.offset
                        )
                        
                        moodListView.selectRow(
                            at: indexPath,
                            animated: true,
                            scrollPosition: .top
                        )
                        
                        self.tableView(moodListView,
                                       didSelectRowAt: indexPath
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
        
        let selectMood = sectionMoods[indexPath.row]
        
        
        for mood in selectMoods {
            
            if mood.moodID == selectMood.moodID &&
               mood.zoneID == selectMood.zoneID {
               
                return
            }
        }
        
        selectMoods.append(selectMood)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let zone = moodZones[section]
        
        let sectionMoods =
            SHSQLiteManager.shared.getMoods(zone.zoneID)
        
        return sectionMoods.isEmpty ? 0 :
            SHScheduleSectionHeader.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = SHScheduleSectionHeader.loadFromNib()

        headerView.sectionZone = moodZones[section]

        return headerView
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
