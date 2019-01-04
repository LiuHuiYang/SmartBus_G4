//
//  SHZoneDevicesCell.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHZoneDevicesCell: UICollectionViewCell {
    
    /// HVAC
    var zoneHVAC: SHHVAC? {
        
        didSet {
         
            iconView.image = UIImage(named: "hvacShow")
            nameLabel.text = zoneHVAC?.acRemark
        }
    }
    
    /// zoneAudio
    var zoneAudio: SHAudio? {
        
        didSet {
            
            iconView.image = UIImage(named: "zoneAudioShow")
            nameLabel.text = zoneAudio?.audioName
        }
    }
    
    /// floorHeating
    var floorHeating: SHFloorHeating? {
        
        didSet {
            
            iconView.image = UIImage(named: "floorheatingShow")
            nameLabel.text = floorHeating?.floorHeatingRemark
        }
    }
    
    /// nineInOne
    var nineInOne: SHNineInOne? {
        
        didSet {
            
            iconView.image = UIImage(named: "nineinoneshow")
            nameLabel.text = nineInOne?.nineInOneName
        }
    }
    
    /// TV
    var zoneTV: SHMediaTV? {
        
        didSet {
            
            iconView.image = UIImage(named: "aMed_TV_normal")
            nameLabel.text = zoneTV?.remark
        }
    }
    
    /// DVD
    var zoneDVD: SHMediaDVD? {
        
        didSet {
            
            iconView.image = UIImage(named: "cMed_DVD_normal")
            nameLabel.text = zoneDVD?.remark
        }
    }
    
    /// 卫星电视
    var zoneSAT: SHMediaSAT? {
        
        didSet {
            
            iconView.image = UIImage(named: "eMed_SAT_normal")
            nameLabel.text = zoneSAT?.remark
        }
    }
    
    /// 苹果电视
    var zoneAppleTV: SHMediaAppleTV? {
        
        didSet {
            
            iconView.image = UIImage(named: "bMed_AppleTV_normal")
            nameLabel.text = zoneAppleTV?.remark
        }
    }
    
    /// 投影仪
    var zoneProjector: SHMediaProjector? {
        
        didSet {
            
            iconView.image = UIImage(named: "dMed_Projector_normal")
            nameLabel.text = zoneProjector?.remark
        }
    }
    
    /// 分组
    var dmxGroup: SHDmxGroup? {
        
        didSet {
            
            iconView.image = UIImage(named: "showDmx")
            nameLabel.text = dmxGroup?.groupName
        }
    }
    
    /// 图标
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }

}
