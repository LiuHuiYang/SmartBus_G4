//
//  SHScheduleWeekCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/23.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHScheduleWeekCell: UITableViewCell {
    
    /// 选择的星期
    var selectWeekDay: SHSchdualWeek = .none {
        
        didSet {
            
            iconView.isHighlighted =
                weekDay == selectWeekDay
        }
    }
    
    /// 选择的星期
    var weekDay: SHSchdualWeek = .none {
        
        didSet {
             
            switch weekDay {
                
            case .sunday:
                dayLabel.text = "Sunday"
                
            case .monday:
                dayLabel.text = "Monday"
                
            case .tuesday:
                dayLabel.text = "Tuesday"
                
            case .wednesday:
                dayLabel.text = "Wednesday"
                
            case .thursday:
                dayLabel.text = "Thursday"
                
            case .friday:
                dayLabel.text = "Friday"
                
            case .saturday:
                dayLabel.text = "Saturday"
                
            default:
                break
            }
        }
    }
    
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return tabBarHeight + tabBarHeight
        
        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            return tabBarHeight
        }
        
        return navigationBarHeight
    }
    
    /// 选择图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 星期
    @IBOutlet weak var dayLabel: UILabel!
    
    /// 背景按钮
    @IBOutlet weak var backgroundIconView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        backgroundIconView.layer.cornerRadius = UIDevice.is_iPad() ? statusBarHeight :  statusBarHeight * 0.5
        
        backgroundIconView.clipsToBounds = true
        
        if UIDevice.is_iPad() {
            
            dayLabel.font = UIView.suitFontForPad()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let iconName =
            selected ? "schedualButton_highlighted" :
                "schedualButton_normal"
        
        iconView.image = UIImage(named: iconName)
        
    }

}
