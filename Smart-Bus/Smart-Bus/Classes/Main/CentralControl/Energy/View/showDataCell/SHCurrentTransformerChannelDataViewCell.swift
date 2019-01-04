//
//  SHCurrentTransformerChannelDataViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2018/11/14.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHCurrentTransformerChannelDataViewCell: UITableViewCell {
    
    
    /// 通道
    var channel: SHCurrentTransformerChannel? {
        
        didSet {
            
            nameLabel.text = channel?.name
            currentSizeLabel.text = "\(channel?.current ?? 0) mA"
            let str = String(format: "%4.2g", (channel?.power ?? 0.0))
            powerSizeLabel.text = "\(str) kW"
        }
    }
    
    /// 通道名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 电流大小
    @IBOutlet weak var currentSizeLabel: UILabel!
    
    /// 功率大小
    @IBOutlet weak var powerSizeLabel: UILabel!
    
    static var rowheight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 1 + statusBarHeight)
        }
        
        return (navigationBarHeight + 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            nameLabel.font = font
            currentSizeLabel.font = font
            powerSizeLabel.font = font
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
