//
//  SHMediaSATChannelCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/28.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHMediaSATChannelCell: UICollectionViewCell {
    
    /// 频道
    var channel: SHMediaSATChannel? {
        
        didSet {
            
            iconView.image =
                UIImage(named: channel?.iconName ?? "mediaSATChannelDefault")
            
            nameLabel.text = channel?.channelName
        }
    }
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.image = UIImage(named: "mediaSATChannelDefault")
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }
}
