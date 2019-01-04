//
//  SHScheduleViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/5.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHScheduleViewCell: UITableViewCell {
    
    /// 计划的模型对象
    var schedual: SHSchedual? {
        
        didSet {
            
            guard let plan = schedual else {
                return
            }
            
            nameLabel.text = plan.scheduleName
            validitySwitch.isOn = plan.enabledSchedule
            
            switch plan.frequencyID {
            
            case .oneTime:
                
                frequencyLabel.text = SHLanguageText.frequencyOnce
                
                timeLabel.text = plan.executionDate
            
            case .dayily:
            
                frequencyLabel.text = SHLanguageText.frequencyDaily
                
                timeLabel.text = plan.executionDate.components(separatedBy: " ").last
                
            case .weekly:
                
                frequencyLabel.text = SHLanguageText.frequencyWeekly
            
                timeLabel.text = plan.executionDate
            }
        }
    }
    
    /// 增加计划类型
    var isAddSchedual = false {
        
        didSet {
            
            validitySwitch.isHidden = isAddSchedual
         
            if isAddSchedual {
                
                let name =
                    SHLanguageTools.share()?.getTextFromPlist(
                        "SCHEDULE",
                        withSubTitle: "ADD_NEW"
                    ) as! String
                
                nameLabel.text = name
                validitySwitch.isOn = false
                frequencyLabel.text = nil
                timeLabel.text = nil
            }
        }
    }

    /// 行高
    static var rowHeight: CGFloat {
    
        if UIDevice.is_iPad()  {
            
            return navigationBarHeight + tabBarHeight
        }
    
        return navigationBarHeight
    }
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 频率
    @IBOutlet weak var frequencyLabel: UILabel!
    
    /// 触发时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 开启开关
    @IBOutlet weak var validitySwitch: UISwitch!


    /// 开启计划的开启点击
    @IBAction func validitySwitchClick() {

        schedual?.enabledSchedule = validitySwitch.isOn
        
        SHSQLManager.share()?.updateSchedule(schedual)
        
        SHSchedualExecuteTools.share().updateSchduals()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        validitySwitch.isOn = false
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            nameLabel.font = font
            frequencyLabel.font = font
            timeLabel.font = font
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
