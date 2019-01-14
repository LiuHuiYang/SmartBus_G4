//
//  SHSchduleLightView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// light生用标标
private let schduleLightCellReuseIdentifier =
    "SHSchduleLightCell"

class SHSchduleLightView: UIView, loadNibView {
    
    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                return
            }
            
            if plan.isDifferentZoneSchedual ||
                (!plan.isDifferentZoneSchedual &&
                allLights.count == 0) {
                
                guard let lights =
                    SHSQLManager.share()?.getLightForZone(
                        plan.zoneID
                    ) as? [SHLight] ,
                
                    let commands = SHSQLManager.share()?.getSchedualCommands(plan.scheduleID) as? [SHSchedualCommand] else {
                        
                        return
                }
                
                
                allLights = lights
                
                for light in allLights {
                    
                    for command in commands {
                        
                        if command.typeID != SHSchdualControlItemType.light.rawValue {
                            
                            continue
                        }
                        
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
             
            lightsListView.reloadData()
        }
    }

    /// 灯光列表
    @IBOutlet weak var lightsListView: UITableView!
    
    /// 所有的灯泡
    private lazy var allLights: [SHLight] = [SHLight]()
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lightsListView.register(
            UINib(
                nibName: schduleLightCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleLightCellReuseIdentifier
        )
        
        lightsListView.rowHeight = SHSchduleLightCell.rowHeight
        
        lightsListView.allowsMultipleSelection = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveLight(_:)),
            name: NSNotification.Name.SHSchedualSaveData,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 保存数据
    @objc func saveLight(_ notification: Notification?) {
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .light {
            
            // 先删除以前的命令
            SHSQLManager.share()?.deleteSchedualeCommand(
                plan
            )
            
            for light in allLights {
                
                if light.schedualEnable == false {
                    
                    continue
                }
                
                let command = SHSchedualCommand()
                
                command.scheduleID = plan.scheduleID
                command.typeID =
                    SHSchdualControlItemType.light.rawValue
                command.parameter1 = light.lightID
                command.parameter2 = plan.zoneID
                
                if light.lightTypeID == .led {
                    
                    command.parameter3 = UInt(light.schedualRedColor)
                    
                    command.parameter4 = UInt(light.schedualGreenColor)
                    
                    command.parameter5 = UInt(light.schedualBlueColor)
                    
                    command.parameter6 = UInt(light.schedualWhiteColor)
                    
                    
                } else {
                    
                    command.parameter3 =
                        UInt(light.schedualBrightness)
                }
                
            SHSQLManager.share()?.insertNewSchedualeCommand(command)
            }
        }
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension SHSchduleLightView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ...
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allLights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleLightCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleLightCell
        
        cell.light = allLights[indexPath.row]
        
        return cell
    }
}
