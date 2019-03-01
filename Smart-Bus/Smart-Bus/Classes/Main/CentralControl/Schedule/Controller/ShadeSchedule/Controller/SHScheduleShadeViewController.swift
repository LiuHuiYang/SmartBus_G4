//
//  SHScheduleShadeViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// light重用标示
private let schduleShadeCellReuseIdentifier =
    "SHSchduleShadeCell"

class SHScheduleShadeViewController: SHViewController {

    /// 计划
    var schedule: SHSchedule?
    
    /// 标记分组是否打开的状态标记
    private lazy var isExpandStauts = [false]
    
    /// 包含shade的所有区域
    private lazy var shadeZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.shade.rawValue
    )
    
    /// 所有的窗帘
    private lazy var scheduleShades = [[SHShade]]()
    
    /// 窗帘列表
    @IBOutlet weak var shadeListView: UITableView!
    
}


// MARK: - 保存窗帘数据
extension SHScheduleShadeViewController {
    
    private func updateScheduleShadeCommands() {
        
        guard let plan = schedule else {
            return
        }
        
        plan.deleteShceduleCommands(.shade)
        
        for sectionShades in scheduleShades {
            
            for shade in sectionShades where shade.currentStatus != .unKnow {
                
                let command = SHSchedualCommand()
                
                command.typeID = .shade
                command.scheduleID = plan.scheduleID
                
                command.parameter1 = shade.shadeID
                command.parameter2 = shade.zoneID
                command.parameter3 = shade.currentStatus.rawValue
                
                plan.commands.append(command)
            }
        }
    }
}


// MARK: - UI初始化
extension SHScheduleShadeViewController {
    
    /// 更新数据
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateScheduleShadeCommands()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            
            return
        }
        
        // === 命令处理
        
        for command in plan.commands where command.typeID == .shade {
            
            for sectionShades in scheduleShades {
                
                for shade in sectionShades {
                    
                    if shade.shadeID == command.parameter1 &&
                        shade.zoneID == command.parameter2 {
                        
                        shade.currentStatus =
                            SHShadeStatus( rawValue:
                                command.parameter3
                            ) ?? .unKnow
                    }
                }
            }
        }
        
        shadeListView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化所有的是否展开标记
        isExpandStauts =
            [Bool](repeating: false, count: shadeZones.count)
        
        // 加载所有的区域的窗帘数据
        for zone in shadeZones {
            
            let shades =
                SHSQLiteManager.shared.getShades(zone.zoneID)
            
            scheduleShades.append(shades)
        }
        
        // 设置导航
        navigationItem.title = "Shade"
        
        // 注册cell
        shadeListView.register(
            UINib(
                nibName: schduleShadeCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleShadeCellReuseIdentifier
        )
        
        shadeListView.rowHeight = SHSchduleShadeCell.rowHeight
    }
}


// MARK: - SHEditRecordShadeStatusDelegate
extension SHScheduleShadeViewController: SHEditRecordShadeStatusDelegate {
    
    /// 窗帘的代理
    func edit(shade: SHShade, status: String) {
        
        /// 遍历所有的区域
        for sectionShades in scheduleShades {
            
            for curtain in sectionShades {
                
                if (curtain.shadeID == shade.shadeID) &&
                    (curtain.subnetID == shade.subnetID) &&
                    (curtain.deviceID == shade.deviceID)  {
                    
                    if status == SHLanguageText.shadeOpen {
                        
                        shade.currentStatus = .open
                        
                    } else if status == SHLanguageText.shadeClose {
                        
                        shade.currentStatus = .close
                        
                    } else {
                        
                        shade.currentStatus = .unKnow
                    }
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate
extension SHScheduleShadeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionShades = scheduleShades[section]
        
        return sectionShades.isEmpty ? 0 :
            SHScheduleSectionHeader.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = SHScheduleSectionHeader.loadFromNib()
        
        headerView.sectionZone = shadeZones[section]
        
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
extension SHScheduleShadeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return shadeZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  isExpandStauts[section] ?
                scheduleShades[section].count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleShadeCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleShadeCell
        
        cell.shade =
            scheduleShades[indexPath.section][indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
}
