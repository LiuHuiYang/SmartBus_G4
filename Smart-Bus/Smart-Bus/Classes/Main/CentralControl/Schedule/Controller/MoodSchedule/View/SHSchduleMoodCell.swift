//
//  SHSchduleMoodCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/4.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHSchduleMoodCell: UITableViewCell {

    /// 场景模型
    var mood: SHMood? {
        
        didSet {
            
            if mood != nil {
                
                enableButton.isSelected =
                    mood!.scheduleEnable
                
                nameLabel.text = mood!.moodName
                
                let iconName =
                    mood!.moodIconName ?? "mood_romantic"
                
                iconView.image =
                    UIImage.resize("\(iconName)_normal")
                
                iconView.highlightedImage =
                    UIImage.resize("\(iconName)_highlighted")
            }
        }
    }

    
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {

            return navigationBarHeight + statusBarHeight
            
        } else if UIDevice.is4_0inch() || UIDevice.is3_5inch() {

            return tabBarHeight
        }

        return navigationBarHeight
    }
    
    /// 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 选择标志
    @IBOutlet weak var flagView: UIImageView!
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 图片高度
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 图片宽度
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    /// 图片高度
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!
    
    /// 图片宽度
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!

    /// 选择标志
    @IBOutlet weak var enableButton: UIButton!
    
    /// 按钮点击
    @IBAction func enableButtonClick() {
        
        enableButton.isSelected =
            !enableButton.isSelected
        
        mood?.scheduleEnable =
            enableButton.isSelected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = UIColor.clear

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

            buttonWidthConstraint.constant = defaultHeight
            buttonHeightConstraint.constant = defaultHeight
            
        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {

            iconViewWidthConstraint.constant = defaultHeight
            iconViewHeightConstraint.constant = defaultHeight
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
}
