//
//  SHCentralControlViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/9.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHCentralControlViewCell: UICollectionViewCell {
    
    var iconName: String = "" {
        
        didSet {
            
            iconView.image = UIImage(named: "\(iconName)_normal")
            iconView.highlightedImage =
                UIImage(named: "\(iconName)_highlighted")

            let title = SHLanguageTools.share()?.getTextFromPlist(
                "MAIN_PAGE",
                withSubTitle: iconName
            ) as? String
            
            nameLabel.text = title ?? iconName.capitalized
            
        }
    }
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }

}
