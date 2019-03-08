//
//  SHAudioOperatorTools.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/19.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 高音与低音的最大值
let audioMaxTrebleBass = 7

// MARK: - 音乐的来源用于请求数据

// MARK: - 接收音乐数据状态标记

/// 读取音乐数据标记状态(方便解析状态)
@objc enum SHAudioReceivedStatusType: UInt8 {
    
    case readDeviceStatus  // 0读取当前音乐设备的状态
    case readTotalPackages // 1读取当前音乐设备的总包数量
    case readAlbumList     // 2读取当前音乐设备中的所有专辑
    case readSongPackages  // 3读取每个专辑中的歌曲的包数量
    case readSongList      // 4读取每个专辑中的每个包中的音乐数据
    case updateList        // 5 更新列表
    case NoUse             // 6播放队列使用的 后续再改
    case out               // 7
}

// MARK: - 音乐播放控制

/// 音乐设备控制的方式
@objc enum SHAudioControlType: UInt8 {
    
    case musicSource        = 1   // 切换来源
    case playModeChanging   = 2   // 播放模式
    case albmOrRadioControl = 3   // 切换专辑或收音机
    case playControl        = 4   // 播放
    case volumeControl      = 5   // 改变声音
    case playSpecifySong    = 6    // 指定音乐播放
}

/// 控制专辑或者是收音机 3 SHAudioControlTypeAlbmOrRadioControl
@objc enum SHAudioAlbumOrRadioControlType: UInt8 {
    
    case previousAlbum             = 1 // 上一个专辑
    case nextAlbum                 = 2 // 下一个专辑
    case specifyAlbumNumber        = 3 // 指定专辑号
    case previousRadioChannel      = 4 // 上一个频道
    case nextRadioChannel          = 5 // 下一个频道
    case specifyRadioChannelNumber = 6 // 指定频道号码
}

///  音乐播放方式  ===== 4 SHAudioControlTypePlayControl
@objc enum SHAudioPlayControlType: UInt8 {
    
    case previousSong = 1 // 上一首
    case nextSong     = 2 // 下一首
    case play         = 3 // 播放
    case stop         = 4 // 停止
}


// MARK: - 声音控制

/// 声音控制方式 0x192E指令不使用
@objc enum SHAudioVolumeControlType: UInt8 {
    
    case volControl = 1 // 直接给定值
    case treble     = 2 // 高音
    case bass       = 3  // 低音
}

/// 具体控制值
@objc enum SHAudioVolumeControlChangeType: UInt8 {
    case decrese  = 1 // 减小
    case increase = 2 // 增大
    case volValue = 3 // 指定值
}

// MARK: - 模式

/// 乐播放模式
@objc enum SHAudioPlayModeType: UInt8 {
    
    case notRepeated    = 1  // 单曲播放
    case repeatOneSong  = 2  // 单曲循环
    case repeatOneAlbum = 3  // 顺序播放
    case repeatAllAlbum = 4   // 循环播放
}

// MARK: - 音乐广播播放状态

/// 音乐广播状态
@objc enum SHAudioBoardCastPlayStatus: UInt8 {
    
    case unKnow = 0 // 未知
    case stop   = 1 // 停止
    case play   = 2 // 播放
    case pause  = 3 // 暂停
}


// MARK: - 操作音乐数据的方式

/// 操作音乐数据的方式
@objc enum SHAudioSetDataOperatorType: UInt8 {
    
    case clearSdCardData    = 1
    case clearFtpServerdata = 2
    case updateFTP          = 3
}

// MARK: - 更新音乐设备中的FTP数据状态

/// 更新音乐设备中的FTP数据状态
@objc enum SHAudioUpdateFtpServerDataStatus: UInt8 {
    
    case none
    case updating
    case finished
}

// MARK: - 沙盒音乐缓存文件类型定义

/// 沙盒中的音乐文件分类类型定义
@objc enum SHAudioSourceFileType: UInt8 {
    
    case directory
    case album
    case songs
    case queueSongs
}

/// 音乐的操作工具类
@objcMembers class SHAudioOperatorTools: NSObject {

}
