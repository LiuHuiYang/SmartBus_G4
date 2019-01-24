//
//  SHSchduleMoodView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// mood重用标示
private let schduleMoodCellReuseIdentifier =
    "SHSchduleMoodCell"

class SHSchduleMoodView: UIView, loadNibView {

    /// 计划模型
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                
                return
            }
            
            allMoods =
                SHSQLiteManager.shared.getMoods(plan.zoneID)
            
            if allMoods.isEmpty {
                
                SVProgressHUD.showInfo(
                    withStatus: SHLanguageText.noData
                )
            }
            
            moodListView.reloadData()
            
            guard let command = SHSQLiteManager.shared.getSchedualCommands(plan.scheduleID).last else {
                
                return
            }
            
            
            for mood in allMoods.enumerated() {
                
                if (mood.element.moodID == command.parameter1) &&
                    (mood.element.zoneID == command.parameter2) {
                    
                    let index =
                        IndexPath(
                            row: mood.offset,
                            section: 0
                    )
                    
                    moodListView.selectRow(
                        at: index,
                        animated: true,
                        scrollPosition: .top
                    )
                    
                    self.tableView(moodListView,
                                   didSelectRowAt: index
                    )
                }
            }
        }
    }
    
    /// 所有的宏命令
    private lazy var allMoods: [SHMood] = [SHMood]()
    
    /// 当前修改的宏命令
    private var selectMood: SHMood?
    
    /// 宏列表
    @IBOutlet weak var moodListView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moodListView.register(
            UINib(
                nibName: schduleMoodCellReuseIdentifier,
                bundle: nil),
            forCellReuseIdentifier:
            schduleMoodCellReuseIdentifier
        )
        
        moodListView.rowHeight = SHSchduleMoodCell.rowHeight
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveMood(_:)),
            name: NSNotification.Name.SHSchedualSaveData,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 保存数据
    @objc func saveMood(_ notification: Notification?) {
        
        guard let type = notification?.object as? SHSchdualControlItemType,
            let plan = schedual else {
                return
        }
        
        if type == .mood {
            
            if selectMood == nil {
                
                return
            }
            
            // 先删除以前的命令
            _ = SHSQLiteManager.shared.deleteSchedualeCommand(
                plan
            )
            
            // 保存到数据库
            let command = SHSchedualCommand()
            command.typeID =
                SHSchdualControlItemType.mood.rawValue
            command.scheduleID = plan.scheduleID
            command.parameter1 = selectMood!.moodID
            command.parameter2 = selectMood!.zoneID
            
            _ = SHSQLiteManager.shared.insertSchedualeCommand(command)
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension SHSchduleMoodView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectMood = allMoods[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allMoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: schduleMoodCellReuseIdentifier,
                for: indexPath
                ) as! SHSchduleMoodCell
        
        cell.mood = allMoods[indexPath.row]
        
        return cell
    }
}
