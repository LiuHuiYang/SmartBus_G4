//
//  SHAudioAlbumCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/16.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

@objcMembers class SHAudioAlbumCell: UITableViewCell {
    
    /// 专辑
    var album: SHAlbum? {
        
        didSet {
            
            albumNameLabel.text = album?.albumName ?? ""
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight + statusBarHeight)
        }
        
        return tabBarHeight
    }
    
    /// 专辑名称
    @IBOutlet weak var albumNameLabel: UILabel!
    
    /// 背景图片
    @IBOutlet weak var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        if UIDevice.is_iPad() {
            albumNameLabel.font = UIView.suitFontForPad()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let imageName = selected ? "cellbgforzonesonghight" : "cellbgforzonesongnone"
        
        iconView.image = UIImage(named: imageName)
    }

}
