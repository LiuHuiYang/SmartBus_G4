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
    
    /// 当前cell的选择状态
    var selectedStatus: Bool = false {
        
        didSet {
            
            print("当前的状态: \(selectedStatus)")
            
            nameLabel.textColor = selectedStatus ? UIView.highlightedTextColor() :
                UIView.textWhiteColor()
         
            setNeedsDisplay()
        }
    }
    
    /// 背景图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.image = UIImage.resize("mediabackground")
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }
    
}
