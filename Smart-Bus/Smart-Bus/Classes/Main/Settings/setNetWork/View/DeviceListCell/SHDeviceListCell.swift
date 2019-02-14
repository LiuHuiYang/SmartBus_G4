//
//  SHDeviceListCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/25.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHDeviceListCell: UITableViewCell {
    
    /// RSIP
    var deviceList: SHDeviceList? {
        
        didSet {
            
            macLabel.text = "MacAddress: \(deviceList?.macAddress ?? "")"
            aliasLabel.text = "Alias: " + (deviceList?.alias ?? "")
        }
    }
    
    
    /// RSIP 网卡地址
    @IBOutlet weak var macLabel: UILabel!
    
    
    /// RSIP 别名
    @IBOutlet weak var aliasLabel: UILabel!
    
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 2 + statusBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            macLabel.font = font
            aliasLabel.font = font
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
