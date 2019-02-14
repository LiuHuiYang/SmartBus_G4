//
//  SHSchedualFloorHeatingCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/10.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHSchedualFloorHeatingCell: UITableViewCell {
    
    /// 计划模型
    var schedual: SHSchedual?
    
    /// 地热
    var schedualFloorHeating: SHFloorHeating? {
        
        didSet {
            
            guard let floorHeating = schedualFloorHeating else {
                return
            }
            
            enableButton.isSelected = floorHeating.schedualEnable
            
            let title =
            "\(floorHeating.floorHeatingRemark) : \(floorHeating.subnetID) - \(floorHeating.deviceID) - \(floorHeating.channelNo)"
            
            schedualFloorHeatingButton.setTitle(title,
                                                for: .normal
            )
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight + statusBarHeight
            
        } else if UIDevice.is4_0inch() {
            
            return tabBarHeight
        }
        
        return navigationBarHeight
    }
    
    /// 按钮的高度
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 标示的宽度
    @IBOutlet weak var flagViewWidthConstraint: NSLayoutConstraint!
    
    /// 标示的高度
    @IBOutlet weak var flagViewHeightConstraint: NSLayoutConstraint!
    
    /// 开启按钮
    @IBOutlet weak var enableButton: UIButton!
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 需要配置的空调
    @IBOutlet weak var schedualFloorHeatingButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        iconView.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            schedualFloorHeatingButton.titleLabel?.font =
                UIView.suitFontForPad()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            buttonHeightConstraint.constant = navigationBarHeight
            
            flagViewWidthConstraint.constant = tabBarHeight
            
            flagViewHeightConstraint.constant = tabBarHeight
        }
    }
    
}

// MARK: - 点击事件
extension SHSchedualFloorHeatingCell {
    
    /// 开启计划
    @IBAction func enableButtonClick() {
        
        enableButton.isSelected = !enableButton.isSelected
        
        schedualFloorHeating?.schedualEnable =
            enableButton.isSelected
    }
    
    /// 点击相关的空调
    @IBAction func schedualFloorHeatingButtonClick() {
        
        if let floorHeating = schedualFloorHeating {
            
            let schedualController =
                SHSchedualFloorHeatingController()
            
            schedualController.schedualFloorHeating =
                floorHeating
            
            schedualController.schedual = schedual
            
            let schedualNavigationController =
                SHNavigationController(
                    rootViewController: schedualController
            )
            
            let rootViewController =
                UIApplication.shared.keyWindow?.rootViewController
            
            rootViewController?.present(
                schedualNavigationController,
                animated: true,
                completion: nil
            )
        }
    }
}

