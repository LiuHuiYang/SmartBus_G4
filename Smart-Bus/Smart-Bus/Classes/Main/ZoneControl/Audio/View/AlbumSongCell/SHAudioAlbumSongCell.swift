//
//  SHAudioAlbumSongCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/18.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

@objcMembers class SHAudioAlbumSongCell: UITableViewCell {
    
    /// 歌曲模型
    var song: SHSong? {
        
        didSet {
            songNameLabel.text = song?.songName ?? ""
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight + statusBarHeight)
        }
        
        return tabBarHeight
    }

    /// 选择图片
    @IBOutlet weak var checkImageView: UIImageView!
    
    /// 歌名
    @IBOutlet weak var songNameLabel: UILabel!
    
    /// 宽度约束
    @IBOutlet weak var showSongIconWidthConstraint: NSLayoutConstraint!
    
    /// 高度约束
    @IBOutlet weak var showSongIconHeightConstraint: NSLayoutConstraint!
    
    
    /// 播放选中的音乐
    @objc private func playSelectSong() {
        
        guard let audio = song else {
            return
        }
        
        SHAudioOperatorTools.playAudioSelectSong(
            subNetID: audio.subNetID,
            deviceID: audio.deviceID,
            sourceType: audio.sourceType,
            albumNumber: audio.albumNumber,
            songNumber: audio.songNumber,
            zoneFlag: 1
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        if UIDevice.is_iPad() {
            songNameLabel.font = UIView.suitFontForPad()
        }
        
        let tap =
            UITapGestureRecognizer(
                target: self,
                action: #selector(playSelectSong)
        )
        
        tap.numberOfTapsRequired = 2
        
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            showSongIconWidthConstraint.constant = defaultHeight
            showSongIconHeightConstraint.constant = defaultHeight
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        checkImageView.isHidden = !selected
    }

}
