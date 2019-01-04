//
//  SHAlbum.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/11/6.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHAlbum: NSObject {

    /// 子网ID
    var subNetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 音乐来源
    var sourceType: UInt8 = 0
    
    /// 分类编号
    var albumNumber: UInt8 = 0
    
    /// 分类名称
    var albumName: String = ""
    
    /// 当前专辑的所有音乐
    lazy var totalAlbumSongs: [SHSong] = [SHSong]()
    
    /// 当前选择的音乐
    var currentSelectSong: SHSong?

}
