//
//  SHLanguageViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/10.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHLanguageViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var language: String? {
        
        didSet {
            
            nameLabel.text = (language ?? "")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class func rowHeightForLanguageViewCell() -> CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight + tabBarHeight
        }
        
        return navigationBarHeight
    }
}
