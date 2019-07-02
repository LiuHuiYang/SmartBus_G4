//
//  SHCentralClimateCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/13.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHCentralClimateCell: UIView, loadNibView {
    
    var centralHVAC: SHCentralHVAC? {
        
        didSet {
            
            zoneLabel.text = centralHVAC?.floorName
            
            // 这两句话是为了匹配 iPAD
            frame_width = superview?.frame_width ?? UIView.frame_screenWidth();
            
            frame_height = SHCentralLightCell.rowHeight
        }
    }
 
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is3_5inch() {
            
            return navigationBarHeight
            
        } else if UIDevice.is_iPad() {
            
            return (navigationBarHeight + tabBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 描述文字
    @IBOutlet weak var zoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            zoneLabel.font = UIView.suitLargerFontForPad()
        }
    }
}
