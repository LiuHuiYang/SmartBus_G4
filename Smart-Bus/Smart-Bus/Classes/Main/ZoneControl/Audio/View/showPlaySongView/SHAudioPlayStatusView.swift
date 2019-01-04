//
//  SHAudioPlayStatusView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/10.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHAudioPlayStatusView: UIView, loadNiBView {

    /// 隐藏显示
    var hiddenPlayInfo = false
    
    /// 正播放的歌曲
    var playSong: SHPlayingSong? {
        
        didSet {
            
            guard let song = playSong else {
                return
            }
            
            if song.albumName.count == 0 ||
                song.songName.count == 0 {
                return
            }
            
            albumNameLabel.text =
                "\(song.albumSerialNumber)\t\(song.albumName)"
            
            let isPlay =
                song.playStatus == SHAudioBoardCastPlayStatus.play
            
            songNameLabel.text =
                "\(song.songSerialNumber)\t\(song.songName)\t\(isPlay ? "▶︎" : "◼︎")"
            
            songNameLabel.textColor =
                isPlay ? UIColor.yellow : UIView.textWhiteColor()
            
            timeLabel.text =
                "\(song.aleardyPlayTime)/\(song.totalTime)"
            
            let playTimeArray =
                song.aleardyPlayTime.components(
                    separatedBy: ":"
            )
            
            let min = UInt8(playTimeArray.first ?? "0") ?? 0
            let sec = UInt8(playTimeArray.last ?? "0") ?? 0
            
            showSeconds = UInt16(min * 60 + sec)
            
            timer?.invalidate()
            timer = nil
            
            if isPlay {
                
                let playTimer =
                    Timer(timeInterval: 1.0,
                          target: self,
                          selector: #selector(changePlayTime),
                          userInfo: nil,
                          repeats: true
                )
                
                RunLoop.current.add(playTimer,
                                    forMode: .common
                )
                
                timer = playTimer
            }
        }
    }
    
    /// 定时器
    weak var timer: Timer?
    
    /// 显示秒数
    var showSeconds: UInt16 = 0
 
    /// 专辑标签
    @IBOutlet weak var albumNameLabel: UILabel!
    
    /// 歌曲名标签
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 歌曲名标签
    @IBOutlet weak var songNameLabel: UILabel!
  
    /// 设置播放时间
    @objc private func changePlayTime() {
        
        showSeconds += 1
        
        let min = showSeconds / 60
        let sec = showSeconds % 60
        
        let showTime = String(format: "%02d:%02d", min, sec)
        
        playSong?.aleardyPlayTime = showTime
        
        timeLabel.text =
            "\(showTime)/\(playSong?.totalTime ?? "00:00")"
        
        if playSong?.totalTime == showTime {
            
            timer?.invalidate()
            timer = nil
        }
    }
}

/// 创建
extension SHAudioPlayStatusView {
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        timer?.invalidate()
        timer = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        albumNameLabel.textColor = UIColor.yellow
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            albumNameLabel.font = font
            timeLabel.font = font
            songNameLabel.font = font
        }
    }
    
    /// 构造
    static func showAudioPlayStatusView() -> SHAudioPlayStatusView {
        
        return Bundle.main.loadNibNamed(
            "\(self)",
            owner: nil,
            options: nil
        )?.first as! SHAudioPlayStatusView
    }
}

