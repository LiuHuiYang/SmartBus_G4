//
//  SHSchedualAudioCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/1/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHSchedualAudioCell: UITableViewCell {

    /// 音乐
    var schedualAudio: SHAudio? {
        
        didSet {
            
            guard let audio = schedualAudio else {
                return
            }
            
            enableButton.isSelected = audio.schedualEnable
            
            let title =
            "\(audio.audioName) : \(audio.subnetID) - \(audio.deviceID)"
            
            schedualAudioButton.setTitle(title,
                                        for: .normal
            )
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight + statusBarHeight
            
        } else if UIDevice.is3_5inch() || UIDevice.is4_0inch() {
            
            return tabBarHeight
        }
        
        return navigationBarHeight
    }
    
    /// 小图片高度
    @IBOutlet weak var flagViewHeightConstraint: NSLayoutConstraint!
    
    /// 小图片宽度
    @IBOutlet weak var flagViewWidthConstraint: NSLayoutConstraint!
    
    /// 图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 开启按钮
    @IBOutlet weak var enableButton: UIButton!
    
    /// 需要配置的音乐
    @IBOutlet weak var schedualAudioButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        iconView.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            schedualAudioButton.titleLabel?.font =
                UIView.suitFontForPad()
        }
    }

   
    override func layoutSubviews() {

        super.layoutSubviews()

        if UIDevice.is_iPad() {

            flagViewWidthConstraint.constant = tabBarHeight
            flagViewHeightConstraint.constant = tabBarHeight
        }
    }

    
}

// MARK: - 点击事件
extension SHSchedualAudioCell {
    
    /// 开启计划
    @IBAction func enableButtonClick() {
        
        enableButton.isSelected = !enableButton.isSelected
        
        schedualAudio?.schedualEnable =
            enableButton.isSelected
    }
    
    /// 点击相关的空调
    @IBAction func schedualAudioButtonClick() {
        
        if let audio = schedualAudio {
            
            let schedualController =
                SHSchedualAudioViewController()
            
            schedualController.schedualAudio = audio
            
            let schedualNavigationController =
                SHNavigationController(
                    rootViewController: schedualController
            )
            
            let rootViewController =
                UIApplication.shared.keyWindow?.rootViewController
            
            rootViewController?.present(
                schedualNavigationController,
                animated: true,
                completion: nil
            )
        }
    }
}
