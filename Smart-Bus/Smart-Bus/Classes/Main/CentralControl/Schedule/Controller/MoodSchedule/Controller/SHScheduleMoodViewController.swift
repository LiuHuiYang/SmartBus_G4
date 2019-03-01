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
    
    /// 标记分组是否打开的状态标记
    private lazy var isExpandStauts = [false]
    
    /// 包含mood的所有区域
    private lazy var moodZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.mood.rawValue
    )
    
    /// 所有mood
    private lazy var scheduleMoods = [[SHMood]]()
    
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
//        for mood in selectMoods {
//            
//            let command = SHSchedualCommand()
//            command.typeID = .mood
//            command.scheduleID = plan.scheduleID
//            command.parameter1 = mood.moodID
//            command.parameter2 = mood.zoneID
//            
//            plan.commands.append(command)
//        }
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
            
            for (zoneSection, sectionMoods) in scheduleMoods.enumerated() {
                
                for (moodIndex, mood) in sectionMoods.enumerated() {
                    
                    if mood.moodID == command.parameter1 &&
                        mood.zoneID == command.parameter2 {
                        
                        mood.schedleEnable = true
                        
                        let indexPath =
                            IndexPath(
                                row: moodIndex,
                                section: zoneSection
                        )
                        print("找到了\(indexPath)")
                        
//                        moodListView.selectRow(
//                            at: indexPath,
//                            animated: true,
//                            scrollPosition: .top
//                        )

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
        
        isExpandStauts =
            [Bool](repeating: false, count: moodZones.count)
        
        for zone in moodZones {
            
            let sectionMoods =
                SHSQLiteManager.shared.getMoods(zone.zoneID)
            
            scheduleMoods.append(sectionMoods)
        }
        

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
        
        let selectMood =
            scheduleMoods[indexPath.section][indexPath.row]
        
        selectMood.schedleEnable = false
    }
    
    /// 选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectMood =
            scheduleMoods[indexPath.section][indexPath.row]
        
        selectMood.schedleEnable = true
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        let sectionMoods = scheduleMoods[section]
        
        return sectionMoods.isEmpty ? 0 :
            SHScheduleSectionHeader.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = SHScheduleSectionHeader.loadFromNib()

        headerView.sectionZone = moodZones[section]
        
        headerView.isExpand = isExpandStauts[section]
        
        headerView.callBack = { (status) -> () in
            
            self.isExpandStauts[section] = status
            
            let index = IndexSet(integer: section)
            
            tableView.reloadSections(index, with: UITableView.RowAnimation.fade)
        }

        return headerView
    }
}

// MARK: - UITableViewDataSource
extension SHScheduleMoodViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return moodZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return isExpandStauts[section] ?
               scheduleMoods[section].count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleMoodCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleMoodCell
        
        cell.mood =
            scheduleMoods[indexPath.section][indexPath.row]
        
        return cell
    }
}
