//
//  SHSecurityZoneViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/12.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHSecurityZoneViewCell: UICollectionViewCell {
    
    var securityZone: SHSecurityZone? {
        
        didSet {
            
            nameLabel.text = securityZone?.zoneNameOfSecurity
        }
    }
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        
        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            nameLabel.font = UIFont.systemFont(ofSize: 16.0)
        }
    }

}
