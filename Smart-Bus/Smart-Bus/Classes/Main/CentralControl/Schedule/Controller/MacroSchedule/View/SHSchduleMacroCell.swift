//
//  SHSchduleMacroCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/22.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHSchduleMacroCell: UITableViewCell {

    /// 宏命令模型
    var macro: SHMacro? {
        
        didSet {
            
            let iconName =
                macro?.macroIconName ?? "Romatic"
            
            nameLabel.text = macro?.macroName
            
            iconView.image = UIImage(named: iconName + "_normal")
        }
    }

    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {

            return tabBarHeight + tabBarHeight
            
        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {

            return tabBarHeight
        }

        return navigationBarHeight
    }
    
    /// 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 选择标志
    @IBOutlet weak var selectFlagView: UIImageView!
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 图片高度
    @IBOutlet weak var flagViewHeightConstraint: NSLayoutConstraint!
    
    /// 图片宽度
    @IBOutlet weak var flagViewWidthConstraint: NSLayoutConstraint!
    
    /// 图片高度
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!
    
    /// 图片宽度
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
 
}


// MARK: - UI初始化
extension SHSchduleMacroCell {
    
    
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
                navigationBarHeight
            
            iconViewHeightConstraint.constant =
                navigationBarHeight

            flagViewHeightConstraint.constant = defaultHeight
            flagViewWidthConstraint.constant = defaultHeight
        
        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {

            iconViewWidthConstraint.constant = defaultHeight
            iconViewHeightConstraint.constant = defaultHeight
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectFlagView.isHidden = !selected

    }
}
