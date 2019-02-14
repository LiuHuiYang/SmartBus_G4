//
//  SHAudioVolumeView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/12/28.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 声音控制与显示
@objcMembers class SHAudioVolumeView: UIView, loadNibView {
    
    /// 音乐设备
    var audio: SHAudio?
    
    /// 音量大小
    var volume: UInt8 = 0 {
        
        didSet {
            
            volumeSlider.value = Float(volume);
        }
    }
    
    /// 低音大小 (-7 ~ 7)
    var bass: Int8 = 0 {
        
        didSet {
            
            bassSlider.value = Float(bass);
        }
    }
    
    /// 高音大小 (-7 ~ 7)
    var treble: Int8 = 0 {
        
        didSet {
            
            trebleSlider.value = Float(treble);
        }
    }

    /// 声音提示文字
    @IBOutlet weak var volLabel: UILabel!
    
    /// 高音提示文字
    @IBOutlet weak var trebleLabel: UILabel!
    
    /// 低音提示文字
    @IBOutlet weak var bassLabel: UILabel!
    
    /// 声音滑动器
    @IBOutlet weak var volumeSlider: UISlider!
    
    /// 高音滑动器
    @IBOutlet weak var trebleSlider: UISlider!
    
    /// 低音滑动器
    @IBOutlet weak var bassSlider: UISlider!
    
    /// 滑动声音(只显示UI)
    @IBAction func volumeChange() {
        
    }
    
    /// 控制声音 (发送控制数据)
    @IBAction func controlAudioVolume() {
        
        guard let currentAudio = audio else {
            return
        }
    
        // 实际控制的声音
        let voiceValue =
            UInt8( volumeSlider.maximumValue -
                    volumeSlider.value
        )
        
        SHAudioOperatorTools.changeAudioVolume(
            subNetID: currentAudio.subnetID,
            deviceID: currentAudio.deviceID,
            volume: voiceValue,
            zoneFlag: currentAudio.zoneFlag
        )
    }
    
    
    /// 高音变化
    @IBAction func trebleChange() {
        
        guard let currentAudio = audio else {
            return
        }
        
        let count = Int8(trebleSlider.value) - treble
        
        let changeType: SHAudioVolumeControlChangeType =
            (count >= 0) ? .increase : .decrese
        
        for _ in 0 ..< abs(count) {
            
            SHAudioOperatorTools.changeAudioTreble(
                subNetID: currentAudio.subnetID,
                deviceID: currentAudio.deviceID,
                changeType: changeType,
                zoneFlag: currentAudio.zoneFlag
            )
        }
    }
    
    /// 高音变化
    @IBAction func bassChange() {
        
        guard let currentAudio = audio else {
            return
        }
        
        let count = Int8(bassSlider.value) - bass
        
        let changeType: SHAudioVolumeControlChangeType =
            (count >= 0) ? .increase : .decrese
        
        for _ in 0 ..< abs(count) {
            
            SHAudioOperatorTools.changeAudioBass(
                subNetID: currentAudio.subnetID,
                deviceID: currentAudio.deviceID,
                changeType: changeType,
                zoneFlag: currentAudio.zoneFlag
            )
        }
    }
}

// MARK: - 实列化
extension SHAudioVolumeView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = statusBarHeight
        clipsToBounds = true
        
        let tintColor = UIView.highlightedTextColor()
        volumeSlider.minimumTrackTintColor = tintColor
        trebleSlider.minimumTrackTintColor = tintColor
        bassSlider.minimumTrackTintColor = tintColor
        
//        volumeSlider.backgroundColor =
//            UIColor(white: 55.0/255.0, alpha: 1.0)
        
        volumeSlider.minimumValue =
            Float(0 - audioMaxTrebleBass)
        
        volumeSlider.maximumValue =
            Float(audioMaxTrebleBass)
        
        volumeSlider.minimumValue =
            Float(0 - audioMaxTrebleBass)
        
        volumeSlider.maximumValue =
            Float(audioMaxTrebleBass)
        
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue =
            Float(SHAUDIO_MAX_VOLUME)
        
        let thumbImage = UIImage.getClearColorImage(CGSize(width: 7, height: 12))
        
        volumeSlider.setThumbImage(thumbImage,
                                       for: .normal
        )
        
        volumeSlider.setThumbImage(thumbImage,
                                       for: .highlighted
        )
        
        trebleSlider.setThumbImage(thumbImage,
                                   for: .normal
        )
        
        trebleSlider.setThumbImage(thumbImage,
                                   for: .highlighted
        )
        
        bassSlider.setThumbImage(thumbImage,
                                   for: .normal
        )
        
        bassSlider.setThumbImage(thumbImage,
                                   for: .highlighted
        )
        
        let transform =
            CGAffineTransform(scaleX: 1.0, y: 5.0);
        
        volumeSlider.transform = transform
        trebleSlider.transform = transform
        bassSlider.transform = transform
        
        if UIDevice.is_iPad() {
            
            let transformPad =
                CGAffineTransform(scaleX: 1.0, y: 15.0)
            
            volumeSlider.transform = transformPad
            trebleSlider.transform = transformPad
            bassSlider.transform = transformPad
            
            let font = UIView.suitFontForPad()
            
            volLabel.font = font
            trebleLabel.font = font
            bassLabel.font = font
        }
    }
    
    // 由于外界OC类会调用，所有单独提供一个类方法
    static func volumeView() -> SHAudioVolumeView {
        
        return Bundle.main.loadNibNamed(
            "\(self)",
            owner: nil,
            options: nil
        )?.first as! SHAudioVolumeView
    }
}
