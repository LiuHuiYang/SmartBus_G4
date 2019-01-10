//
//  SHSchduleShadeCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/5.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 窗帘代理
protocol SHEditRecordShadeStatusDelegate {
    
    func edit(shade: SHShade, status: String)
}

class SHSchduleShadeCell: UITableViewCell {
    
    /// 窗帘
    var shade: SHShade? {
        
        didSet {
            
            guard let curtain = shade else {
                return
            }
            
            nameLabel.text = curtain.shadeName
            
            switch curtain.currentStatus {
                
            case .unKnow:
                homeButton.setTitle(
                    SHLanguageText.shadeIgnore,
                    for: .normal
                )
                
            case .open:
                homeButton.setTitle(
                    SHLanguageText.shadeOpen,
                    for: .normal
                )
                
            case .close:
                homeButton.setTitle(
                    SHLanguageText.shadeClose,
                    for: .normal
                )
                
            default:
                break
            }
        }
    }
    
    
    /// 代理
    var delegate: SHEditRecordShadeStatusDelegate?
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight + statusBarHeight
            
        } else if UIDevice.is4_0inch() || UIDevice.is3_5inch() {
            
            return tabBarHeight
        }
        
        return navigationBarHeight
    }
    
    /// 窗帘名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 设置按钮
    @IBOutlet weak var homeButton: SHMoodShadeStatusButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            nameLabel.font = font
            homeButton.titleLabel?.font = font
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    /// 设置按钮点击
    @IBAction func homeButtonClick() {
        
        guard let curtain = shade else {
            return
        }
        
        let alertView =
            TYCustomAlertView(title: nil,
                              message: nil,
                              isCustom: true
        )
        
        // 打开
        let openAction =
            TYAlertAction(
                title: SHLanguageText.shadeOpen,
                style: .default) {
                    (action) in
                    
                    
                    self.homeButton.setTitle(
                        SHLanguageText.shadeOpen,
                        for: .normal
                    )
                    
                    self.delegate?.edit(
                        shade: curtain,
                        status: SHLanguageText.shadeOpen
                    )
                    
        }
        
        alertView?.add(openAction)
        
        // 关闭
        let closeAction =
            TYAlertAction(
                title: SHLanguageText.shadeClose,
                style: .default) {
                    (action) in
                    
                    
                    self.homeButton.setTitle(
                        SHLanguageText.shadeClose,
                        for: .normal
                    )
                    
                    self.delegate?.edit(
                        shade: curtain,
                        status: SHLanguageText.shadeClose
                    )
                    
        }
        
        alertView?.add(closeAction)
        
        // 忽略
        let ignoreAction =
            TYAlertAction(
                title: SHLanguageText.shadeIgnore,
                style: .default) {
                    (action) in
                    
                    
                    self.homeButton.setTitle(
                        SHLanguageText.shadeIgnore,
                        for: .normal
                    )
                    
                    self.delegate?.edit(
                        shade: curtain,
                        status: SHLanguageText.shadeIgnore
                    )
                    
        }
        
        alertView?.add(ignoreAction)
        
        let alertController =
            TYAlertController(
                alert: alertView,
                preferredStyle: .alert,
                transitionAnimation: .dropDown
        )
        
        alertController?.backgoundTapDismissEnable = true
        
    UIApplication.shared.keyWindow?.rootViewController?.present(
            alertController!,
            animated: true,
            completion: nil
        )
    }
}
