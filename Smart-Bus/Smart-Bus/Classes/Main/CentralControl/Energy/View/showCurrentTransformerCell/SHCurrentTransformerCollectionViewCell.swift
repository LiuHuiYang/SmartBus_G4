//
//  SHCurrentTransformerCollectionViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/11.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHCurrentTransformerCollectionViewCell: UICollectionViewCell {
    
    var currentTransformer: SHCurrentTransformer? {
        
        didSet {
            
            guard let name = currentTransformer?.remark else {
                
                return
            }
            
            nameLabel.text = name
        }
    }

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        if UIDevice.is4_0inch() || UIDevice.is3_5inch() {
            
            nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        } else if UIDevice.is_iPad() {
        
            nameLabel.font = UIView.suitFontForPad()
        }
    }

}
