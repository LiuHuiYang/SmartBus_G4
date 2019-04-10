//
//  SHZoneSATViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/30.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneSATViewController: SHViewController {

    /// 卫星电视
    var zoneSAT: SHMediaSAT?
    
    /// 控制面板
    var zoneControlSATView: SHZoneControlSATView?

    /// 数字键盘
    var controlNumberPad: SHZoneControlSATNumberPad?

    /// 通道
    var controlChannel: SHZoneControlSATChannel?

    /// 头部高度约束
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    /// 控制显示面板
    @IBOutlet weak var controlView: UIView!
    
    /// 控制按钮
    @IBOutlet weak var controlButton: UIButton!
    
    /// 频道按钮
    @IBOutlet weak var channelButton: UIButton!
    
    /// 数字按钮
    @IBOutlet weak var numberButton: UIButton!

    
    /// 数字按钮
    @IBAction func numberButtonClick() {
    
        controlButton.isSelected = false
        channelButton.isSelected = false
        numberButton.isSelected = true
        
        if controlNumberPad?.window == nil {
            
            controlNumberPad =
                SHZoneControlSATNumberPad.loadFromNib()
            
            controlView.addSubview(controlNumberPad!)
            
            controlNumberPad?.frame = controlView.bounds
        }
        
        controlNumberPad?.mediaSAT = zoneSAT
        
        controlNumberPad?.isHidden = false
        zoneControlSATView?.isHidden = true
        controlChannel?.isHidden = true
        
        navigationItem.rightBarButtonItem?.customView?.isHidden
            = true
    }
   
    /// 通道按钮点击
    @IBAction func channelButtonClick() {
        
        controlButton.isSelected = false
        channelButton.isSelected = true
        numberButton.isSelected = false
        
        if controlChannel?.window == nil {
            
            controlChannel =
                SHZoneControlSATChannel.loadFromNib()
            
            controlView.addSubview(controlChannel!)
            
            controlChannel?.frame = controlView.bounds
        }
        
        controlChannel?.mediaSAT = zoneSAT
        
        controlNumberPad?.isHidden = true
        zoneControlSATView?.isHidden = true
        controlChannel?.isHidden = false
        
        navigationItem.rightBarButtonItem?.customView?.isHidden
            = false
    }
    
    /// 控制按钮点击
    @IBAction func controlButtonClick() {
        
        controlButton.isSelected = true
        channelButton.isSelected = false
        numberButton.isSelected = false
        
        if zoneControlSATView?.window == nil {
            
            zoneControlSATView =
                SHZoneControlSATView.loadFromNib()
            
            controlView.addSubview(zoneControlSATView!)
            
            zoneControlSATView?.frame = controlView.bounds
        }
        
        zoneControlSATView?.mediaSAT = zoneSAT
        
        controlNumberPad?.isHidden = true
        zoneControlSATView?.isHidden = false
        controlChannel?.isHidden = true
        navigationItem.rightBarButtonItem?.customView?.isHidden
            = true
    }
    
    
    /// 电视频道设置
    @objc private func channelSetting() {
        
        let viewController =
            SHMediaSATChannelSettingViewController()
     
        viewController.mediaSAT = zoneSAT;
        
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
}


// MARK: - UI初始化
extension SHZoneSATViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = zoneSAT?.remark
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(imageName: "setting",
                            hightlightedImageName: "setting",
                            addTarget: self,
                            action: #selector(channelSetting),
                            isLeft: false
        )
        
        let selectColor = UIView.highlightedTextColor()
        
        controlButton.setTitle(SHLanguageText.control,
                               for: .normal
        )
        
        controlButton.setTitleColor(selectColor,
                                    for: .selected
        )
        
        channelButton.setTitle(SHLanguageText.channel,
                               for: .normal
        )
        
        channelButton.setTitleColor(selectColor,
                                    for: .selected
        )
        
        numberButton.setTitle(SHLanguageText.numberPad,
                              for: .normal
        )
        
        numberButton.setTitleColor(selectColor,
                                   for: .selected
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            controlButton.titleLabel?.font = font
            channelButton.titleLabel?.font = font
            numberButton.titleLabel?.font = font
        }
        
        controlButtonClick()
    }
    
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        zoneControlSATView?.frame = controlView!.bounds
        controlNumberPad?.frame = controlView!.bounds
        controlChannel?.frame = controlView!.bounds
        
        if UIDevice.is_iPad() {
            
            topViewHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
        
    }
}
