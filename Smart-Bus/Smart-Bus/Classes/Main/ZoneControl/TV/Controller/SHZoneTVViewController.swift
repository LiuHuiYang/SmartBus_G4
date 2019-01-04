//
//  SHZoneTVViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/30.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneTVViewController: SHViewController {

    /// TV
    var zoneTV: SHMediaTV?
    
    /// 控制面板
    var zoneControlTVView: SHZoneControlTVView?
    
    /// 数字键盘
    var controlNumberPad: SHZoneControlTVNumberPad?
    
    /// 顶部分组的视图高度
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    /// 控制按钮
    @IBOutlet weak var controlButton: UIButton!
    
    /// 数字按钮
    @IBOutlet weak var numberButton: UIButton!
    
    /// 控制视图
    @IBOutlet weak var controlView: UIView!
    
    /// 控制按钮点击
    @IBAction func controlButtonClick() {
   
        controlButton.isSelected = true
        numberButton.isSelected = false
        
        if zoneControlTVView?.window == nil {
            
            zoneControlTVView = SHZoneControlTVView.loadFromNib()
            controlView.addSubview(zoneControlTVView!)
            zoneControlTVView?.frame = controlView.bounds
        }
        
        zoneControlTVView?.mediaTV = zoneTV
        
        controlNumberPad?.isHidden = true
        zoneControlTVView?.isHidden = false
    }
    
    /// 数字按钮点击
    @IBAction func numberButtonClick() {
    
        controlButton.isSelected = false
        numberButton.isSelected = true
        
        if controlNumberPad?.window == nil {
            
            controlNumberPad = SHZoneControlTVNumberPad.loadFromNib()
            controlView.addSubview(controlNumberPad!)
            controlNumberPad?.frame = controlView.bounds
        }
        
        controlNumberPad?.mediaTV = zoneTV
        
        controlNumberPad?.isHidden = false
        zoneControlTVView?.isHidden = true
    }
}



// MARK: - UI
extension SHZoneTVViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = zoneTV?.remark
        
        controlButton.setTitle(
            SHLanguageText.control,
            for: .normal
        )
        
        controlButton.setTitleColor(
            UIView.highlightedTextColor(),
            for: .selected
        )
        
        numberButton.setTitle(
            SHLanguageText.numberPad,
            for: .normal
        )
        
        numberButton.setTitleColor(
            UIView.highlightedTextColor(),
            for: .selected
        )
        
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            controlButton.titleLabel?.font = font
            numberButton.titleLabel?.font = font
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controlButtonClick()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        zoneControlTVView?.frame = controlView.bounds
        controlNumberPad?.frame = controlView.bounds
        
        if UIDevice.is3_5inch() {
            
            topViewHeightConstraint.constant = defaultHeight
            
        } else if UIDevice.is_iPad() {
            
            topViewHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
        }
    }
}
