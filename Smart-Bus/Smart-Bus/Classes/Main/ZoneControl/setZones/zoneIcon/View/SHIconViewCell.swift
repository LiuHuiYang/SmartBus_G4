//
//  SHIconViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/12.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHIconViewCell: UICollectionViewCell {
    
    var zoneImage: UIImage? {
        
        didSet {
        
            iconView.image = zoneImage
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
    }

}
