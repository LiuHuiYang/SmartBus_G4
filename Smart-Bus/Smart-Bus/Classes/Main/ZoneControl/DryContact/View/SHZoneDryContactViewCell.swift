//
//  SHZoneDryContactViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHZoneDryContactViewCell: UITableViewCell {
    
    /// 干节点
    var dryContact: SHDryContact? {
        
        didSet {
            
            guard let node = dryContact else {
                return
            }
            
            nameLabel.text = node.remark
            
            statusSwitch .setOn(node.status == .open, animated: false)
            
            switch node.type {
            case .invalid:
                break
                
            case .normalOpen:
                break
            
            case .normalClose:
                break
                
            default:
                break
            }
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 2 + statusBarHeight)
        }
        
        return (navigationBarHeight + statusBarHeight)
    }
    
    /// 高度
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!

    /// 宽度
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 节点状态
    @IBOutlet weak var statusSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        iconView.image = UIImage(named: "dryContactType")
        
        if UIDevice.is_iPad() {
            
            nameLabel.font = UIView.suitFontForPad()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            self.iconViewWidthConstraint.constant =
                navigationBarHeight * 2;
            
            self.iconViewHeightConstraint.constant =
                navigationBarHeight * 2;
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
