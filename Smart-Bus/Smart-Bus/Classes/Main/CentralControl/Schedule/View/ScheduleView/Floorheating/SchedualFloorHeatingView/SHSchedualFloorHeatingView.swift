//
//  SHSchedualFloorHeatingView.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/10.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// 重用标示
private let schduleFloorHeatingCellReuseIdentifier =
    "SHSchedualFloorHeatingCell"

class SHSchedualFloorHeatingView: UIView, loadNibView {

    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                return
            }
            
            if plan.isDifferentZoneSchedual ||
                (!plan.isDifferentZoneSchedual &&
                    floorHeatings.count == 0) {
                
                let commands =
                    SHSQLiteManager.shared.getSchedualCommands(
                        plan.scheduleID
                )
               
                floorHeatings =
                    SHSQLiteManager.shared.getFloorHeatings(
                    plan.zoneID
                )
                
                for floorHeating in floorHeatings {
                    
                    for command in commands {
                        
                        if command.typeID != SHSchdualControlItemType.floorHeating.rawValue {
                            
                            continue
                        }
                        
                        if (floorHeating.subnetID == command.parameter1) &&
                            (floorHeating.deviceID == command.parameter2) {
                            
                            // 只要是存在的命令就一定是选中的
                            floorHeating.schedualEnable = true
                            
                            floorHeating.channelNo = UInt8(command.parameter3)
                            floorHeating.schedualIsTurnOn = (command.parameter4 != 0)
                            
                            floorHeating.schedualModeType = SHFloorHeatingModeType(rawValue: UInt8(command.parameter5)) ?? .manual
                            floorHeating.schedualTemperature = Int(command.parameter6)
                            
                        }
                    }
                }
            }
            
            listView.reloadData()
        }
    }
  
    /// 列表
    @IBOutlet weak var listView: UITableView!
    
    /// 所有的地热供暖
    private lazy var floorHeatings: [SHFloorHeating] =
        [SHFloorHeating]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listView.register(
            UINib(
                nibName: schduleFloorHeatingCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleFloorHeatingCellReuseIdentifier
        )
        
        listView.rowHeight =
            SHSchedualFloorHeatingCell.rowHeight
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveFloorHeating(_:)),
            name: NSNotification.Name.SHSchedualSaveData,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 保存数据
    @objc func saveFloorHeating(_ notification: Notification?) {
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .floorHeating {
            
            // 先删除以前的命令
            _ = SHSQLiteManager.shared.deleteSchedualeCommand(
                plan
            )
            
            for floorHeating in floorHeatings {
                
                if floorHeating.schedualEnable == false {
                    
                    continue
                }
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID =
                    SHSchdualControlItemType.floorHeating.rawValue
                
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
              
                _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
            }
        }
    }

}


// MARK: - UITableViewDataSource
extension SHSchedualFloorHeatingView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return floorHeatings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleFloorHeatingCellReuseIdentifier,
                for: indexPath
                ) as! SHSchedualFloorHeatingCell
        
        cell.schedualFloorHeating =
            floorHeatings[indexPath.row]
        
        cell.schedual = self.schedual
        
        return cell
    }
}
