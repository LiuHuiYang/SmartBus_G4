//
//  SHScheduleSectionHeader.swift
//  Smart-Bus
//
//  Created by Apple on 2019/2/21.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHScheduleSectionHeader: UIView, loadNibView {

    /// 展开
    var isUnfold: Bool = false
    
    /// 分组名称
    var sectionZone: SHZone? {
        
        didSet {
    
            sectionLabel.text = sectionZone?.zoneName
        }
    }
    
    
    
    /// 高度
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return tabBarHeight
        }
        
        return defaultHeight
    }
    
    
    /// 分组标签
    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 增加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerClick))
        
        addGestureRecognizer(tap)
        
        if UIDevice.is_iPad() {
            
            sectionLabel.font = UIView.suitFontForPad()
        }
    }

}

extension SHScheduleSectionHeader {
    
    /// 点击打开与关闭
    @objc private func headerClick() {
        
        print("点击分组")
    }
}
