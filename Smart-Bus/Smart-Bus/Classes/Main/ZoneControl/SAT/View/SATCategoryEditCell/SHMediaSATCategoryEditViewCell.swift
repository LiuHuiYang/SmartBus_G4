//
//  SHMediaSATCategoryEditViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/29.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标示
let mediaSatCategoryEditCellReuseIdentifier =  "SHMediaSATCategoryEditViewCell"

@objcMembers class SHMediaSATCategoryEditViewCell: UITableViewCell {
    
    /// 频道
    var channel: SHMediaSATChannel? {
        
        didSet {
            
            textLabel?.text =
                "\(channel!.categoryID) - " +
                "\(channel!.channelID) - " +
                (channel!.channelName ?? "")
        }
    }
    
    /// 分类
    var category: SHMediaSATCategory? {
        
        didSet {
            
           textLabel?.text =
               "\(category!.categoryID) - " +
                (category!.categoryName ?? "")
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight + statusBarHeight)
        }
        
        return tabBarHeight
    }
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        textLabel?.textColor = UIColor.white
        textLabel?.font = UIFont.systemFont(ofSize: 16)

        if UIDevice.is_iPad() {

            self.textLabel?.font = UIView.suitFontForPad()
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

