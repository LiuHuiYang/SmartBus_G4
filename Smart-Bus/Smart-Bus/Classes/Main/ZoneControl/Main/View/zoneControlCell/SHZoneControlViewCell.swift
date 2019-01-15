//
//  SHZoneControlViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/5.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHZoneControlViewCell: UICollectionViewCell {
    
    /// 地区分组
    var region: SHRegion? {
        
        didSet {
             
            nameLabel.text = region?.regionName
            
            guard let area = region,
            
            let iconData =
                SHSQLManager.share()?.getIcon(
                    area.regionIconName
                )?.iconData,

            let image = UIImage(data: iconData) else {

                iconView.image = UIImage(named: "HOME_STATUS_highlighted")
                
                return
            }

            iconView.image = image
        }
    }
    
    /// 区域
    var currentZone: SHZone? {
        
        didSet {
            
            guard let zone = currentZone else {
                return
            }
            
            nameLabel.text = zone.zoneName
            
            guard let icon = SHSQLManager.share()?.getIcon(zone.zoneIconName) else {
                return
            }
             
            guard let image = (icon.iconData == nil) ? UIImage(named: zone.zoneIconName ?? "") : UIImage(data: icon.iconData!) else {
                iconView.image =
                    UIImage(named: "Demokit")
                return
            }
            
            iconView.image = image
//            iconView.highlightedImage = UIImage(named: "\(currentZone.zoneIconName)_highlighted") ?? image
            
        }
    }
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
        
    }
}
