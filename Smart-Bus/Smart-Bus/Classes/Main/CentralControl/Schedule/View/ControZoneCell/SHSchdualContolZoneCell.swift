//
//  SHSchdualContolItemAndZoneCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHSchdualContolItemAndZoneCell: UITableViewCell {
    
    /// 区域
    @objc var currentZone: SHZone? {
        
        didSet {
            
            if currentZone != nil {
                
                nameLabel.text = currentZone!.zoneName
            }
        }
    }
    
    /// 控制名称
    var controlItemName: String = "" {
        
        didSet {
            
            nameLabel.text = controlItemName
        }
    }

    
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight + statusBarHeight
        }
        
        return tabBarHeight
    }
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        iconView.image = UIImage.resize("buttonbackground")
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
