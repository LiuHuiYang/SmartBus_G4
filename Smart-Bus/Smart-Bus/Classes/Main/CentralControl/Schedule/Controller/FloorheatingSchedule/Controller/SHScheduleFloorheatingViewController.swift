//
//  SHScheduleFloorheatingViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// 重用标示
private let schduleFloorHeatingCellReuseIdentifier =
    "SHSchedualFloorHeatingCell"

class SHScheduleFloorheatingViewController: SHViewController {

    /// 计划
    var schedule: SHSchedule?
    
    /// 包含floorHeating的所有区域
    private lazy var floorHeatingZones =
        SHSQLiteManager.shared.getZones(
            deviceType:
                SHSystemDeviceType.floorHeating.rawValue
    )
    
    /// 所有的地热
    private lazy var scheduleFloorHeatings = [[SHFloorHeating]]()
    
    /// 地热列表
    @IBOutlet weak var floorheatingListView: UITableView!
    
}

extension SHScheduleFloorheatingViewController {
    
    /// 更新数据
    @objc private func updateScheduleFloorHeatingCommands() {
        
        guard let plan = schedule else {
            return
        }
        
        plan.deleteShceduleCommands(.floorHeating)
        
        for sectionFloorHeatings in scheduleFloorHeatings {
            
            for floorHeating in sectionFloorHeatings where floorHeating.schedualEnable {
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID = .floorHeating
                
                command.parameter1 =
                    UInt(floorHeating.subnetID)
                
                command.parameter2 =
                    UInt(floorHeating.deviceID)
                
                command.parameter3 =
                    UInt(floorHeating.channelNo)
                
                command.parameter4 =
                    floorHeating.schedualIsTurnOn ? 1 : 0
                
                command.parameter5 = UInt(floorHeating.schedualModeType.rawValue)
                
                // 手动模式温度
                command.parameter6 = UInt(floorHeating.schedualTemperature)
                
                plan.commands.append(command)

            }
        }
        
        _ = navigationController?.popViewController(
            animated: true
        )
    }
}

// MARK: - UI初始化
extension SHScheduleFloorheatingViewController {
    
    /// 设置schedule
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            return
        }
        
        // 命令处理
        
        for command in plan.commands where command.typeID == .floorHeating {
            
            for sectionFloorHeatings in scheduleFloorHeatings {
                
                for floorHeating in sectionFloorHeatings {
                    
                    if floorHeating.subnetID == command.parameter1 &&
                       floorHeating.deviceID == command.parameter2 &&
                       floorHeating.channelNo == command.parameter3 {
                        
                        if !floorHeating.isUpdateSchedualCommand {
                            
                            continue
                        }
                         
                        floorHeating.schedualEnable = true
                        
                        floorHeating.schedualIsTurnOn =
                            command.parameter4 != 0
                        
                        floorHeating.schedualModeType =
                            SHFloorHeatingModeType(rawValue:
                                UInt8(command.parameter5)
                        ) ?? .manual
                        
                        floorHeating.schedualTemperature =
                            Int(command.parameter6)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载 所有的数据
        for zone in floorHeatingZones {
            
            let floorHeatings =
                SHSQLiteManager.shared.getFloorHeatings(
                    zone.zoneID
            )
            
            scheduleFloorHeatings.append(floorHeatings)
        }
        
        // 设置导航
        navigationItem.title = "Floor heating"
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                imageName: "navigationbarback",
                hightlightedImageName: "navigationbarback",
                addTarget: self,
                action: #selector(updateScheduleFloorHeatingCommands),
                isLeft: true
        )
        
        // 注册 cell
        floorheatingListView.register(
            UINib(
                nibName: schduleFloorHeatingCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleFloorHeatingCellReuseIdentifier
        )
        
        floorheatingListView.rowHeight =
            SHSchedualFloorHeatingCell.rowHeight
    }
}


// MARK: - UITableViewDelegate
extension SHScheduleFloorheatingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let floorHeatingController =
            SHScheduleFloorHeatingDetailController()
 
        floorHeatingController.schedualFloorHeating =
            scheduleFloorHeatings[indexPath.section][indexPath.row]
        
        navigationController?.pushViewController(
            floorHeatingController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionLights = scheduleFloorHeatings[section]
        
        return sectionLights.isEmpty ? 0 :
            SHScheduleSectionHeader.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = SHScheduleSectionHeader.loadFromNib()
        
        headerView.sectionZone = floorHeatingZones[section]
        
        return headerView
    }
}

// MARK: - UITableViewDataSource
extension SHScheduleFloorheatingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return floorHeatingZones.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scheduleFloorHeatings[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleFloorHeatingCellReuseIdentifier,
                for: indexPath
                ) as! SHSchedualFloorHeatingCell
        
        cell.schedualFloorHeating =
            scheduleFloorHeatings[indexPath.section][indexPath.row]
       
        return cell
    }
}
