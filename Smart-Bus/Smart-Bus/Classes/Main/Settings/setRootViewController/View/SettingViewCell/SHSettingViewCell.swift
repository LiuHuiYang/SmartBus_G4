//
//  SHSettingViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/22.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHSettingViewCell: UITableViewCell {
    
    /// 显示名称
    var showText: String? {
        
        didSet {
            nameLabel.text = showText
        }
    }
    
    /// 显示图片
    var showImage: UIImage? {
        
        didSet {
            
             iconView.image = showImage
        }
    }
    
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight + tabBarHeight)
        }
        
        return navigationBarHeight
    }
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 背景视图
    @IBOutlet weak var iconViewBackgroundView: UIView!
    
    /// 高度约束
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!
    
    /// 宽度约束
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        iconViewBackgroundView.layer.cornerRadius = 8
        iconViewBackgroundView.clipsToBounds = true
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scale: CGFloat = 0.7
        
        iconViewWidthConstraint.constant = tabBarHeight * scale
        iconViewHeightConstraint.constant = tabBarHeight * scale
        
        if UIDevice.is_iPad() {
            
            iconViewWidthConstraint.constant =
                navigationBarHeight * scale
            
            iconViewHeightConstraint.constant =
                navigationBarHeight * scale
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
