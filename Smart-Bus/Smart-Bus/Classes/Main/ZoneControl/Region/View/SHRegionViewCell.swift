//
//  SHRegionViewCell.swift
//  Smart-Bus
//
//  Created by Apple on 2019/2/27.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHRegionViewCell: UITableViewCell {
    
    /// 地区分组
    var region: SHRegion? {
        
        didSet {
            
            nameLabel.text = region?.regionName
            
            guard let area = region,
                let icon = SHSQLiteManager.shared.getIcon(
                    area.regionIconName
                ) else {
                
                return
            }
            
            iconView.image =
                icon.iconData == nil ?
                    UIImage(named: area.regionIconName) :
                    UIImage(data: icon.iconData!)
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight + navigationBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }

    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 高度约束
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!
    
    /// 宽度约束
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            iconViewWidthConstraint.constant =
                tabBarHeight + tabBarHeight
            
            iconViewHeightConstraint.constant =
                tabBarHeight + tabBarHeight
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
