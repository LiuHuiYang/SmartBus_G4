//
//  SHSchduleShadeView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// light生用标标
private let schduleShadeCellReuseIdentifier =
    "SHSchduleShadeCell"

class SHSchduleShadeView: UIView, loadNibView {
 
    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual,
            let shades = SHSQLManager.share()?.getShadeForZone(
                    plan.zoneID ) as? [SHShade],
            
            let commands = SHSQLManager.share()?.getSchedualCommands(
                    plan.scheduleID
                    ) as? [SHSchedualCommand]
                
                else {
                    
                    SVProgressHUD.showInfo(
                        withStatus: SHLanguageText.noData
                    )
                    
                return
            }
            
            allShades = shades
            
            for command in commands {
                
                for shade in allShades {
                    
                    if (shade.shadeID == command.parameter1) &&
                        (shade.zoneID == command.parameter2) {
                        
                        shade.currentStatus =
                            SHShadeStatus(
                                rawValue: command.parameter3
                            ) ?? .unKnow
                    }
                }
            }
            
            shadeListView.reloadData()
        }
    }
    
    /// 所有的窗帘
    private lazy var allShades: [SHShade] = [SHShade]()
    
    /// 窗帘列表
    @IBOutlet weak var shadeListView: UITableView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadeListView.register(
            UINib(
                nibName: schduleShadeCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleShadeCellReuseIdentifier
        )
        
        shadeListView.rowHeight = SHSchduleShadeCell.rowHeight
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveShade(_:)),
            name: NSNotification.Name.SHSchedualSaveData,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 保存数据
    @objc func saveShade(_ notification: Notification?) {
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .shade {
            
            // 先删除以前的命令
            SHSQLManager.share()?.deleteSchedualeCommand(
                plan
            )
            
            for shade in allShades {
                
                let command = SHSchedualCommand()
                
                command.typeID =
                    SHSchdualControlItemType.shade.rawValue
                
                command.scheduleID = plan.scheduleID
                
                command.parameter1 = shade.shadeID
                command.parameter2 = shade.zoneID
                command.parameter3 =
                    shade.currentStatus.rawValue
             
                SHSQLManager.share()?.insertNewSchedualeCommand(command)
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension SHSchduleShadeView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allShades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleShadeCellReuseIdentifier,
                for: indexPath
            ) as! SHSchduleShadeCell
        
        cell.shade = allShades[indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
}


// MARK: - SHEditRecordShadeStatusDelegate
extension SHSchduleShadeView: SHEditRecordShadeStatusDelegate {
    
    func edit(shade: SHShade, status: String) {
        
        for curtain in allShades {
            
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
