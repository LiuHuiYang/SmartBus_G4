//
//  SHEditRecordShadeCell.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/25.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

@objc protocol SHEditRecordShadeStatusDelegate {
    
    /// 设置当前窗帘的目标状态
    ///
    /// - Parameters:
    ///   - shade: 窗帘
    ///   - status: 状态
    func edit(_ shade: SHShade?, currentStatus status: String?)
}

@objcMembers class SHEditRecordShadeCell: UITableViewCell {
    
    /// 代理
    var delegate: SHEditRecordShadeStatusDelegate?
    
    /// 当前的窗帘
    var shade: SHShade? {
        
        didSet {
            
            nameLabel.text = shade?.shadeName
        }
    }

    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return  navigationBarHeight + tabBarHeight
        }
        
        return navigationBarHeight
    }
    
    /// 高度约束
    @IBOutlet weak var statusButtonHeightConstraint: NSLayoutConstraint!
    
    /// 窗帘名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 设置按钮
    @IBOutlet weak var homeButton: SHMoodShadeStatusButton!
 
    
    /// 设置按钮点击
    @IBAction func homeButtonClick() {
        
        let alertView =
            TYCustomAlertView(title: "",
                              message: "",
                              isCustom: true
        )
        
        // 打开
        let openAction =
            TYAlertAction(title: SHLanguageText.shadeOpen,
                          style: .default) { (action) in
            
                            
            self.homeButton.setTitle(
                SHLanguageText.shadeOpen,
                for: .normal
            )
                            
            self.delegate?.edit(
                self.shade,
                currentStatus: SHLanguageText.shadeOpen
            )

        }
        alertView?.add(openAction)
        
        // 关闭
        let closeAction =
            TYAlertAction(title: SHLanguageText.shadeClose,
                          style: .default) { (action) in
            
            self.homeButton.setTitle(
                SHLanguageText.shadeClose,
                for: .normal
            )
                            
            self.delegate?.edit(
                self.shade,
                currentStatus: SHLanguageText.shadeClose
            )
        }
        alertView?.add(closeAction)
        
        // 忽略
        let ignoreAction =
            TYAlertAction(title: SHLanguageText.shadeIgnore,
                          style: .cancel) { (action) in
                            
            self.homeButton.setTitle(
                SHLanguageText.shadeIgnore,
                for: .normal
            )
                            
                self.delegate?.edit(
                self.shade,
                currentStatus: SHLanguageText.shadeIgnore
            )
        }
        alertView?.add(ignoreAction)
        
        let alertController =
            TYAlertController(alert: alertView!,
                              preferredStyle: .alert,
                              transitionAnimation: .scaleFade
        )
        
        UIApplication.shared.keyWindow?.rootViewController?.present(
            alertController!,
            animated: true,
            completion: nil
        )
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        homeButton.setTitle(
            SHLanguageText.shadeIgnore,
            for: .normal
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            homeButton.titleLabel?.font = font
            nameLabel.font = font
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            statusButtonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
