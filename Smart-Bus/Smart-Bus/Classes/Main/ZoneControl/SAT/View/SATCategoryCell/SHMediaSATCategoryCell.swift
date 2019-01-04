//
//  SHMediaSATCategoryCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/27.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHMediaSATCategoryCell: UITableViewCell {
    
    
    /// 分类
    var category: SHMediaSATCategory? {
        
        didSet {
            
            nameLabel.text = category?.categoryName
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {

            return tabBarHeight + tabBarHeight
        }

        return navigationBarHeight
    }
    
    /// 背景图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none

        iconView.image = UIImage.resize("mediaMenubuttonbackground")

        if UIDevice.is_iPad() {

            nameLabel.font = UIView.suitFontForPad()
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        nameLabel.textColor = selected ? UIView.highlightedTextColor() :
            UIView.textWhiteColor()
    }

}
