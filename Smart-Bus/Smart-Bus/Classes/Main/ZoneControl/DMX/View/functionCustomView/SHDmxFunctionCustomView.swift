//
//  SHDmxFunctionCustomView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/10.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHDmxFunctionCustomView: UIView, loadNibView {
    
    var sceneName: String? {
        
        didSet {
            
            nameLabel.text = sceneName
            
            // 这两句话是为了匹配 iPAD
            frame_width = superview?.frame_width ?? UIView.frame_screenWidth();
            frame_height = SHCentralLightCell.rowHeight
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
       if UIDevice.is_iPad() {
            
            return navigationBarHeight + tabBarHeight
        }
        
        return navigationBarHeight + statusBarHeight
    }
    
    /// 描述文字
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //    self.iconView.image = [UIImage resizeImage:@"pickerViewbackground"];
        
        if UIDevice.is_iPad() {
            nameLabel.font = UIView.suitLargerFontForPad()
        }
    }

}
