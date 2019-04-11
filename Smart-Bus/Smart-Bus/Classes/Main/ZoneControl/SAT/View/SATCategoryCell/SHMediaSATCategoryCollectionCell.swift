//
//  SHMediaSATCategoryCollectionCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/27.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHMediaSATCategoryCollectionCell: UICollectionViewCell {

    /// 分类
    var category: SHMediaSATCategory? {
        
        didSet {
            
            nameLabel.text = category?.categoryName
        }
    }
    
    
    /// 背景图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.image = UIImage.resize("mediaMenubuttonbackground")
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }
     
//    override func select(_ sender: Any?) {
//
//        super.select(sender)
//
//        print("这里会有吗")
//        nameLabel.textColor = isSelected ? UIView.highlightedTextColor() :
//            UIView.textWhiteColor()
//    }
 
}
