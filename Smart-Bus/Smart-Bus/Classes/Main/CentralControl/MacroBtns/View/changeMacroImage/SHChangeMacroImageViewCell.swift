//
//  SHChangeMacroImageViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/12.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHChangeMacroImageViewCell: UITableViewCell {
    
    var marcroImageName: String? {
        
        didSet {
            
            iconView.image = UIImage.resize(marcroImageName!)
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class func rowHeightForChangeMacroImageViewCell() -> CGFloat {
        
        return navigationBarHeight
    }
}
