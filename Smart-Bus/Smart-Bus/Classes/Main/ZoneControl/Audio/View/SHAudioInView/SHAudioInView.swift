//
//  SHAudioInView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/12/28.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHAudioInView: UIView, loadNibView {

    /// 音乐设备
    var audio: SHAudio? {
        
        didSet {
            
            // 如果果miniAudio暂时使用一张图片在中间
            if audio?.isMiniZAudio != 0 {
                
                iconView.image =
                    UIImage(named: "miniZAudio_normal")
                
                isHidden = false
            }
        }
    }
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!

}


// MARK: - 创建
extension SHAudioInView {
    
    // 由于外界OC类会调用，所有单独提供一个类方法
    static func audioInView() -> SHAudioInView {
        
        return Bundle.main.loadNibNamed(
                "\(self)",
                owner: nil,
                options: nil
            )?.first as! SHAudioInView
    }
}
