//
//  SHSceneControlViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHSceneControlViewCell: UITableViewCell {
    
    /// 场景控制
    var sceneControl: SHSceneControl?
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight * 2 + statusBarHeight
        }
        
        return navigationBarHeight + statusBarHeight
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.red
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
