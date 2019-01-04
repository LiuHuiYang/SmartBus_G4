//
//  SHCurrentPlaySong.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/10.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHPlayingSong: NSObject {
    
    static let shared = SHPlayingSong()

    /// 音乐来源
    var sourceType: UInt8 = 0
    
    /// 播放状态
    var playStatus: SHAudioBoardCastPlayStatus = .unKnow
    
    /// 歌曲序列号码
    var songSerialNumber: String = ""
   
    /// 专辑充列号码
    var albumSerialNumber: String = ""
    
    /// 歌曲名称
    var songName: String = ""
    
    /// 专辑名称
    var albumName: String = ""
    
    /// 总时间
    var totalTime: String = ""
    
    /// 已播放时间
    var aleardyPlayTime: String = ""
}
