//
//  SHSchduleHVACView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// hvac重用标示
private let schduleHVACCellReuseIdentifier =
    "SHSchedualHVACCell"

class SHSchduleHVACView: UIView, loadNibView {
    
    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                return
            }
            
            if plan.isDifferentZoneSchedual ||
                (!plan.isDifferentZoneSchedual &&
                    hvacs.count == 0) {
                
                let commands =
                    SHSQLiteManager.shared.getSchedualCommands(
                        plan.scheduleID
                )
               
                hvacs =
                    SHSQLiteManager.shared.getHVACs(
                        plan.zoneID
                )
                
                for hvac in hvacs {
                    
                    for command in commands {
                        
                        if command.typeID != SHSchdualControlItemType.HVAC.rawValue {
                            
                            continue
                        }
                        
                        if (hvac.subnetID == command.parameter1) &&
                            (hvac.deviceID == command.parameter2) {
                            
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
            
            
            allHVACListView.reloadData()
        }
    }

    /// 所有的空调
    private lazy var hvacs: [SHHVAC] = [SHHVAC]()
    
    /// 所有的空调列表
    @IBOutlet weak var allHVACListView: UITableView!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        allHVACListView.register(
            UINib(
                nibName: schduleHVACCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleHVACCellReuseIdentifier
        )
        
        allHVACListView.rowHeight = SHSchedualHVACCell.rowHeight
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveHVAC(_:)),
            name: NSNotification.Name.SHSchedualSaveData,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 保存数据
    @objc func saveHVAC(_ notification: Notification?) {
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .HVAC {
            
            // 先删除以前的命令
            _ = SHSQLiteManager.shared.deleteSchedualeCommand(
                plan
            )
            
            for hvac in hvacs {
                
                if hvac.schedualEnable == false {
                    
                    continue
                }
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID =
                    SHSchdualControlItemType.HVAC.rawValue
                
                command.parameter1 = UInt(hvac.subnetID)
                command.parameter2 = UInt(hvac.deviceID)
                
                command.parameter3 =
                    hvac.schedualIsTurnOn ? 1 : 0
                command.parameter4 = UInt(hvac.schedualFanSpeed.rawValue)
                command.parameter5 = UInt(hvac.schedualMode.rawValue)
                
                 // 模式温度 -> 具体是哪种模式温度 取决于 parameter5
                command.parameter6 = UInt(hvac.schedualTemperature)
                
                _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension SHSchduleHVACView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hvacs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleHVACCellReuseIdentifier,
                for: indexPath
                ) as! SHSchedualHVACCell
        
        cell.schedualHVAC = hvacs[indexPath.row]
        
        return cell
    }
}
