//
//  SHScheduleLightViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/19.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// light重用标示
private let schduleLightCellReuseIdentifier =
    "SHSchduleLightCell"

class SHScheduleLightViewController: SHViewController {

    /// 计划
    var schedule: SHSchedule?
    
    /// 包含light的所有区域
    private lazy var lightZones =
        SHSQLiteManager.shared.getZones(
            deviceType: SHSystemDeviceType.light.rawValue
    )
    
    /// 标记分组是否打开的状态标记
    private lazy var isExpandStauts = [false]
    
    /// 所有的灯泡
    private lazy var scheduleLights = [[SHLight]]()
    
    /// 灯泡列表
    @IBOutlet weak var lightListView: UITableView!
    
}


// MARK: - 保存数据
extension SHScheduleLightViewController {
    
    /// 更新
    private func updateScheduleLightCommands() {
        
        guard let plan = schedule else {
            return
        }
        
        plan.deleteShceduleCommands(.light)
        
        for sectionLights in scheduleLights {
            
            for light in sectionLights where light.schedualEnable {
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID = .light
                
                command.parameter1 = light.lightID
                command.parameter2 = light.zoneID
                
                if light.lightTypeID == .led {
                    
                    command.parameter3 = UInt(light.schedualRedColor)
                    
                    command.parameter4 = UInt(light.schedualGreenColor)
                    
                    command.parameter5 = UInt(light.schedualBlueColor)
                    
                    command.parameter6 = UInt(light.schedualWhiteColor)
                    
                    
                } else {
                    
                    command.parameter3 =
                        UInt(light.schedualBrightness)
                }
                
                plan.commands.append(command)
            }
        }
  
    }
}

// MARK: - UI初始化
extension SHScheduleLightViewController {
    
    /// 更新数据
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateScheduleLightCommands()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let plan = schedule else {
            
            return
        }
        
        // ===== 命令部分 =====
        
        for command in plan.commands where command.typeID == .light {
            
            for sectionLights in scheduleLights {
                
                for light in sectionLights {
                    
                    if (light.lightID == command.parameter1) &&
                        (light.zoneID == command.parameter2) {
                        
                        // 只要是存在的命令就一定是选中的
                        light.schedualEnable = true
                        
                        if light.lightTypeID == .led {
                            
                            light.schedualRedColor = UInt8(command.parameter3)
                            
                            light.schedualGreenColor = UInt8(command.parameter4)
                            
                            light.schedualBlueColor = UInt8(command.parameter5)
                            
                            light.schedualWhiteColor = UInt8(command.parameter6)
                            
                        } else {
                            
                            light.schedualBrightness = UInt8(command.parameter3)
                        }
                    }
                    
                }
            }
        }
        
        lightListView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化所有的是否展开标记
        isExpandStauts =
            [Bool](repeating: false, count: lightZones.count)
        
        // 加载所有的区域的灯泡数据
        for zone in lightZones {
            
            let lights =
                SHSQLiteManager.shared.getLights(zone.zoneID)
            
            scheduleLights.append(lights)
        }
        
        
        navigationItem.title = "Light"
      
        lightListView.register(
            UINib(
                nibName: schduleLightCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleLightCellReuseIdentifier
        )
        
        lightListView.rowHeight = SHSchduleLightCell.rowHeight
    }
}


// MARK: - UITableViewDelegate
extension SHScheduleLightViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionLights = scheduleLights[section]
        
        return sectionLights.isEmpty ? 0 :
            SHScheduleSectionHeader.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = SHScheduleSectionHeader.loadFromNib()

        headerView.sectionZone = lightZones[section]
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
extension SHScheduleLightViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return scheduleLights.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  isExpandStauts[section] ?
                scheduleLights[section].count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleLightCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleLightCell
        
        cell.light =
            scheduleLights[indexPath.section][indexPath.row]
        
        return cell
    }
}
