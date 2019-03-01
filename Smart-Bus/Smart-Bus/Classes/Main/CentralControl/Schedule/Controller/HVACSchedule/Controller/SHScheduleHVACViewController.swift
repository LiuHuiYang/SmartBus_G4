//
//  SHScheduleHVACViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// hvac重用标示
private let schduleHVACCellReuseIdentifier =
    "SHSchedualHVACCell"

class SHScheduleHVACViewController: SHViewController {

    /// 计划
    var schedule: SHSchedule?
    
    /// 是否展开的状态
    private lazy var isExpandStauts = [false]
    
    /// 包含HVAC的所有区域
    private lazy var hvacZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.hvac.rawValue
    )
    
    /// 所有的HVAC
    private lazy var scheduleHVACs = [[SHHVAC]]()
    
    /// 空调列表
    @IBOutlet weak var hvacListView: UITableView!

}


// MARK: - 保存数据
extension SHScheduleHVACViewController {
    
    /// 更新数据
    @objc private func updateScheduleHVACCommands() {
        
        guard let plan = schedule else {
            return
        }
        
        plan.deleteShceduleCommands(.hvac)
        
        for sectionHVACs in scheduleHVACs {
            
            for hvac in sectionHVACs where hvac.schedualEnable {
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID = .hvac
                
                command.parameter1 = UInt(hvac.subnetID)
                command.parameter2 = UInt(hvac.deviceID)
                
                command.parameter3 =
                    hvac.schedualIsTurnOn ? 1 : 0
                command.parameter4 = UInt(hvac.schedualFanSpeed.rawValue)
                command.parameter5 = UInt(hvac.schedualMode.rawValue)
                
                // 模式温度 -> 具体是哪种模式温度 取决于 parameter5
                command.parameter6 = UInt(hvac.schedualTemperature)
                
                plan.commands.append(command)
            }
        }
        
        _ = navigationController?.popViewController(
            animated: true
        )
    }
}


// MARK: - UI初始化
extension SHScheduleHVACViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            return
        }
        
        // 命令处理
        
        for command in plan.commands where command.typeID == .hvac {
            
            for sectionHVACs in scheduleHVACs {
                
                for hvac in sectionHVACs {
                    
                    if hvac.subnetID == command.parameter1 &&
                       hvac.deviceID == command.parameter2 {
                        
                        if !hvac.isUpdateSchedualCommand {
                            
                            continue
                        }
                        
                        // 只要是存在的命令就一定是选中的
                        hvac.schedualEnable = true
                        
                        hvac.schedualIsTurnOn = (command.parameter3 != 0)
                        
                        hvac.schedualFanSpeed = SHAirConditioningFanSpeedType(rawValue: UInt8(command.parameter4)) ?? .auto;
                        
                        hvac.schedualMode = SHAirConditioningModeType(rawValue: UInt8(command.parameter5)) ?? .cool;
                        
                        hvac.schedualTemperature = Int(command.parameter6);
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isExpandStauts =
            [Bool](repeating: false, count: hvacZones.count)
        
        // 加载 所有的数据
        for zone in hvacZones {
            
            let hvacs =
                SHSQLiteManager.shared.getHVACs(
                    zone.zoneID
            )
            
            scheduleHVACs.append(hvacs)
        }
        
        // 设置导航
        navigationItem.title = "HVAC"
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                imageName: "navigationbarback",
                hightlightedImageName: "navigationbarback",
                addTarget: self,
                action: #selector(updateScheduleHVACCommands),
                isLeft: true
        )
        
        // 注册cell
        hvacListView.register(
            UINib(
                nibName: schduleHVACCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleHVACCellReuseIdentifier
        )
        
        hvacListView.rowHeight = SHSchedualHVACCell.rowHeight
    }
}



// MARK: - UITableViewDelegate
extension SHScheduleHVACViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let hvacController =
            SHScheduleHVACViewDetailController()
        
        hvacController.schedualHVAC =
            scheduleHVACs[indexPath.section][indexPath.row]
        
        navigationController?.pushViewController(
            hvacController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionHVACs = scheduleHVACs[section]
        
        return sectionHVACs.isEmpty ? 0 :
            SHScheduleSectionHeader.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = SHScheduleSectionHeader.loadFromNib()
        
        headerView.sectionZone = hvacZones[section]
        
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
extension SHScheduleHVACViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hvacZones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isExpandStauts[section] ?
               scheduleHVACs[section].count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleHVACCellReuseIdentifier,
                for: indexPath
                ) as! SHSchedualHVACCell
        
        cell.schedualHVAC =
            scheduleHVACs[indexPath.section][indexPath.row]
        
        return cell
    }
}
