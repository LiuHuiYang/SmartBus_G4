//
//  SHZoneTemperatureViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/18.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHZoneTemperatureViewCell: UITableViewCell {
    
    var temperatureSensor: SHTemperatureSensor? {
        
        didSet {
            
            guard let tempSensor = temperatureSensor else {
                return
            }
            
            nameLabel.text = tempSensor.remark
         
            let cels = tempSensor.currentValue
            let fah = Int(CGFloat(cels) * 1.8 + 32)
            temperatureLabel.text = "\(cels) °C \n\(fah) °F"
        }
    }
    
    /// 图片的宽度
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet  weak var iconViewWidthConstraint: NSLayoutConstraint!
    
    /// 图标
    @IBOutlet  weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet  weak var nameLabel: UILabel!
    
    /// 温度值
    @IBOutlet  weak var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            nameLabel.font = font
            temperatureLabel.font = font
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            iconViewWidthConstraint.constant =
                navigationBarHeight * 2
            
            iconViewHeightConstraint.constant =
                navigationBarHeight * 2
        }
        
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 2 + statusBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }
}
