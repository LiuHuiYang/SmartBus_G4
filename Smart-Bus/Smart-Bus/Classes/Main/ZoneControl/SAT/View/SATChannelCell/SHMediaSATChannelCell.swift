//
//  SHMediaSATChannelCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/28.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHMediaSATChannelCell: UICollectionViewCell {
    
    /// 卫星电视
    var mediaSAT: SHMediaSAT?
    
    /// 频道
    var channel: SHMediaSATChannel? {
        
        didSet {
            
//            iconView.image =
//                UIImage(named: channel?.iconName ?? "mediaSATChannelDefault")
            
            channelButton.setTitle(
                channel?.channelName,
                for: .normal
            )
        }
    }
    
    
    /// channelButton
    @IBOutlet weak var channelButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            
            channelButton.titleLabel?.font =
                UIView.suitFontForPad()
        }
        
    }
    
    
    /// 频道按钮点击
    @IBAction func channelButtonClick() {
        
        guard let sat = mediaSAT,
            let controlChannel = channel,
            controlChannel.channelNo != 0 else {
                return
        }
        
        SoundTools.share().playSound(withName: "click.wav")
        
        // 获得延时
        let time = UserDefaults.standard.integer(
            forKey: delayIRTimekey
        )
        
        let dalayIrTime = TimeInterval(time)/1000.0
        
        let string: NSString =
            "\(controlChannel.channelNo)" as NSString
        
        let count = string.length
        
        for i in 0 ..< count {
            
            DispatchQueue.global().asyncAfter(deadline: .now() + dalayIrTime) {
                
                let single = string.substring(
                    with: NSRange(location: i, length: 1)
                )
                
                // 取出对应的操作码
                let text =
                    "universalSwitchIDfor" + single
                
                let controlType =
                    (sat.value(forKey: text) as? UInt8) ?? 0
                
                SHSocketTools.sendData(
                    operatorCode: 0xE01C,
                    subNetID: sat.subnetID,
                    deviceID: sat.deviceID,
                    additionalData: [controlType, 0xFF]
                )
            }
        }
    }
}
 
