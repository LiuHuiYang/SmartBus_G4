//
//  SHSchedualHVACCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHSchedualHVACCell: UITableViewCell {
    
    /// 空调
    var schedualHVAC: SHHVAC? {
        
        didSet {
            
            guard let hvac = schedualHVAC else {
                return
            }
            
            enableButton.isSelected = hvac.schedualEnable
            
            let title =
                "\(hvac.acRemark) : \(hvac.subnetID) - \(hvac.deviceID)"
            
            schedualHVACButton.setTitle(title,
                                        for: .normal
            )
        }
    }
    
    /// 按钮的高度
    @IBOutlet weak var hvacButtonHeightConstraint: NSLayoutConstraint!
    
    /// 标示的宽度
    @IBOutlet weak var flagViewWidthConstraint: NSLayoutConstraint!
    
    /// 标示的高度
    @IBOutlet weak var flagViewHeightConstraint: NSLayoutConstraint!
    
    /// 开启按钮
    @IBOutlet weak var enableButton: UIButton!

    
    /// 需要配置的空调
    @IBOutlet weak var schedualHVACButton: UIButton!
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight + statusBarHeight
        
        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            return tabBarHeight
        }
        
        return navigationBarHeight
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        if UIDevice.is_iPad() {
            
            schedualHVACButton.titleLabel?.font =
                UIView.suitFontForPad()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            hvacButtonHeightConstraint.constant = navigationBarHeight
            
            flagViewWidthConstraint.constant = tabBarHeight
            
            flagViewHeightConstraint.constant = tabBarHeight
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


// MARK: - 点击事件
extension SHSchedualHVACCell {
    
    /// 开启计划
    @IBAction func enableButtonClick() {
        
        enableButton.isSelected = !enableButton.isSelected
        
        schedualHVAC?.schedualEnable =
            enableButton.isSelected
    }
}
