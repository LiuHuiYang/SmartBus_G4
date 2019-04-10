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
            
            iconView.image =
                UIImage(named: channel?.iconName ?? "mediaSATChannelDefault")
            
            nameLabel.text = channel?.channelName
        }
    }
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.image = UIImage(named: "mediaSATChannelDefault")
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendChannelData))
        
        addGestureRecognizer(tap)
    }
}


// MARK: - 发送控制数据
extension SHMediaSATChannelCell {
    
    @objc private func sendChannelData() {
        
        guard let sat = mediaSAT,
              let controlChannel = channel,
         controlChannel.channelNo != 0 else {
            return
        }
        
        // 获得延时
        let time = UserDefaults.standard.integer(
            forKey: delayIRTimekey
        )
        
        let dalayIrTime = TimeInterval(time)/1000.0
        
        let string: NSString =
            "\(controlChannel.channelNo)" as NSString
         
        let count = string.length
 
        for i in 0 ..< count {
            
            
            let single = string.substring(
                with: NSRange(location: i, length: 1)
            )
            
            // 取出对应的操作码
            let text =
                "universalSwitchIDfor" + single
            
            let controlType =
                (sat.value(forKey: text) as? UInt8) ?? 0
            
            print("准备发送的指令是 \(text) - \(controlType)")
       
            SHSocketTools.sendData(
                operatorCode: 0xE01C,
                subNetID: sat.subnetID,
                deviceID: sat.deviceID,
                additionalData: [controlType, 0xFF]
            )
            
            Thread.sleep(forTimeInterval: dalayIrTime)
        }
    }
}
