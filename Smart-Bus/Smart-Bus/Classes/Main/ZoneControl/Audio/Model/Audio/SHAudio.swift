//
//  SHAudio.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/16.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

@objcMembers class SHAudio: NSObject {
    
    /// 区域标示
    var zoneFlag: UInt8 = 1 // 默认使用1，这个参数暂时没有用

    // MARK: - ==== schedual中的增加属性
    
    /// 计划启用
    var schedualEnable = false
    
    /// 计划声音
    var schedualVolumeRatio: UInt8 = 0
    
    /// 计划来源
    var schedualSourceType: SHAudioSourceType = .SDCARD
    /// 计划状态
    var schedualPlayStatus: UInt8 = 0
    
    /// 计划播放的专辑号码
    var schedualPlayAlbumNumber: UInt8 = 0
    
    /// 计划播放的歌曲号码
    var schedualPlaySongNumber: UInt = 0
    
    /// 计划专辑(中间参数)
    var schedualAlbum: SHAlbum?
    
    // MARK: - ====== 读取相关的专辑数控制相关属性 ======   存储于内存中
    
    /// 当前选中的音乐来源(SD卡，FTP, RADIO，AUDIOIN)
    var sourceType: SHAudioSourceType = .unKnow
    
    /// 音乐设备所有的专辑 (这是从 albumNameList 中解析出来的模型数组)
    lazy var allAlbums: [SHAlbum] = [SHAlbum]()
    
    /// 当前选择的专辑
    var currentSelectAlbum: SHAlbum?
    
    /// 当前播放模式控制
    var playMode: SHAudioPlayModeType = .notRepeated

    // MARK: - ====== 录制音乐相关的状态(录制Mood使用)  ==== 控制音乐设备

    /// 录制声音大小
    var recoredVolume: UInt8 = 0
    
    /// 录制播放状态
    var recordPlayStatus: UInt8 = 0
    
    /// 录制专辑号
    var recordAlubmNumber: UInt8 = 0
    
    /// 录制歌曲号
    var recordSongNumber: UInt8 = 0
    
    /// 录制音乐来源
    var recordSource: UInt8 = 0
    
    /// 录制成功的标示
    var recordSuccess = false

    // MARK： - ====== 设备记号 ======   需要存储于数据库
    
    /// 区域ID
    var id: UInt = 0
    
    /// 区域ID
    var zoneID: UInt = 0
    
    ///  子网ID
    var subnetID: UInt8 = 0
    
    ///  设备ID
    var deviceID: UInt8 = 0
    
    /// 音乐设备名称
    var audioName = "Audio"
    
    ///  具有SDCard选项
    var haveSdCard: UInt8 = 0
    
    ///  具有ftp选项
    var haveFtp: UInt8 = 0
    
    ///  具有收音机选项
    var haveRadio: UInt8 = 0
    
    ///  具有audioin音乐选项
    var haveAudioIn: UInt8 = 0
    
    ///  具有havePhone音乐选项
    var havePhone: UInt8 = 0
    
    ///  具有U盘音乐选项
    var haveUdisk: UInt8 = 0
    
    ///  具有蓝牙音乐选项
    var haveBluetooth: UInt8 = 0
 
    ///  当前是否为miniZaudio
    var isMiniZAudio: UInt8 = 0
    
    override init() {
        super.init()
    }

    init(dictionary: [String: Any]) {
        super.init()
        
        setValuesForKeys(dictionary)
        
        if audioName == "audio" || audioName == "(null)" {
            
            if let zone = SHSQLiteManager.shared.getZone(zoneID: zoneID) {
                
                audioName = zone.zoneName ?? "Audio"
            }
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
       
        if key == "ID" {
            
            id = value as? UInt ?? 0
        
        }
    }
}
