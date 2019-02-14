//
//  SHDeviceArgsViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/19.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHDeviceArgsViewCell: UITableViewCell {
    
    /// 参数
    var argsName: String? {
        
        didSet {
            
            guard let name = argsName else {
                return
            }
            
            argsNameLabel.text = name
        }
    }
    
    /// 值
    var argValueText: String? {
        
        didSet {
            
            guard let value = argValueText else {
                return
            }
            
            argsValueLabel.text = value
        }
    }
    
    /// 参数名称
    @IBOutlet weak var argsNameLabel: UILabel!
    
    /// 参数值
    @IBOutlet weak var argsValueLabel: UILabel!

    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 2 + statusBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            argsNameLabel.font = font
            argsValueLabel.font = font
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
