//
//  SHSchedualWeekView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/26.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

/// 星期的重用标示符
private let scheduleWeekCelleuseIdentifier = "SHScheduleWeekCell"

@objcMembers class SHSchedualWeekView: UIView {

    /// 计划
    var schedual: SHSchedule?
    
    /// 星期
    @IBOutlet weak var listView: UITableView!
 
}


// MARK: - UITableViewDelegate
extension SHSchedualWeekView: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.isSelected = true
        
        selectWeekDay(
            weekDay: SHSchdualWeek(rawValue:
                UInt8(indexPath.row + 1)
                ) ?? .none,
            
            isSelected: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.isSelected = false
        
        selectWeekDay(
            weekDay:
                SHSchdualWeek(rawValue:
                    UInt8(indexPath.row + 1)
                ) ?? .none,
            
            isSelected: false)
    }
    
    private func selectWeekDay(weekDay: SHSchdualWeek, isSelected: Bool) {
        
        switch weekDay {
        
        case .sunday:
            schedual?.withSunday = isSelected
            
        case .monday:
            schedual?.withMonday = isSelected
            
        case .tuesday:
            schedual?.withTuesday = isSelected
            
        case .wednesday:
            schedual?.withWednesday = isSelected
            
        case .thursday:
            schedual?.withThursday = isSelected
            
        case .friday:
            schedual?.withFriday = isSelected
            
        case .saturday:
            schedual?.withSaturday = isSelected
        
        default:
            break
        }
    }
    
}

// MARK: - UITableViewDataSource
extension SHSchedualWeekView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: scheduleWeekCelleuseIdentifier,
                for: indexPath
            ) as! SHScheduleWeekCell
        
        let day = UInt8(indexPath.row + 1)
       
        cell.weekDay =
            SHSchdualWeek(rawValue: day) ?? .none
        
        return cell
    }
    
}


// MARK: - UI初始化
extension SHSchedualWeekView {
    
    /// 实例化View
    class func schedualWeekView(_ schedual: SHSchedule?) -> SHSchedualWeekView {
        
        let weeekView = Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! SHSchedualWeekView
        
        weeekView.schedual = schedual
        
        let width: CGFloat = UIView.frame_screenWidth() * 0.65
        
        weeekView.frame_width = width > 280 ? width : 280
        
        weeekView.frame_height = SHScheduleWeekCell.rowHeight * 7
        
        return weeekView
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let plan = schedual else {
            return
        }
        
        let days = plan.getExecutWeekDays()
        
  
        for day in days {

            listView.selectRow(
                at: IndexPath(row: Int(day.rawValue - 1), section: 0),
                animated: true,
                scrollPosition: .middle
            )
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listView.backgroundColor = UIColor.clear
        
        listView.register(
            UINib(nibName: scheduleWeekCelleuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
            scheduleWeekCelleuseIdentifier
        )
        
        listView.rowHeight = SHScheduleWeekCell.rowHeight
        
        listView.allowsMultipleSelection = true
        
        // 整体背景
        backgroundColor = UIColor(hex: 0xddFbFb, alpha: 0.9)
        
        layer.cornerRadius =
            UIDevice.is_iPad() ? statusBarHeight :
            statusBarHeight * 0.5
        
        clipsToBounds = true
    }
}
