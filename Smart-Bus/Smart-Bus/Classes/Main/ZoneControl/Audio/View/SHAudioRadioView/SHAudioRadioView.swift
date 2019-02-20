//
//  SHAudioRadioView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/12/28.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit


@objcMembers class SHAudioRadioView: UIView {
    
    /// 音乐设备
    var audio: SHAudio?

    private lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    
    // MARK: - 创建
    
    /// 收音机按钮点击
    @objc private func radioChannelButtonClick(button: UIButton) {
        
        guard let currentAudio = audio else {
            return
        }
 
        SHAudioOperatorTools.changeRadio(
            subNetID: currentAudio.subnetID,
            deviceID: currentAudio.deviceID,
            channelNumber: UInt8(button.tag)
        )
    }
    
    /// 设置收音机界面
    private func setupRadioButtonView() {
        
        addSubview(scrollView)
        
        let count = 25
        
        let font =
            UIDevice.is_iPad() ? UIView.suitFontForPad():
            UIFont.systemFont(ofSize: 16)
        
        let normalColor = UIView.textWhiteColor()
        let highlightedColor = UIView.highlightedTextColor()
        
        for i in 0 ..< count {
            
            let button =
                UIButton(title: "Channel-\(i + 1)",
                    font: font,
                    normalTextColor: normalColor,
                    highlightedTextColor: highlightedColor,
                    imageName: nil,
                    backgroundImageName: "radioChannelButton",
                    addTarget: self,
                    action: #selector(radioChannelButtonClick(button:))
            )
            
            button?.tag = i + 1 // 从1开始
            
            scrollView.addSubview(button!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        let buttonMaignX = statusBarHeight;
        let buttonMaignY = buttonMaignX;
       
        let totoalCols =
            UIDevice.is_iPhone() ? 2 : 4
        
        let buttonWidth =
            (frame_width - CGFloat(totoalCols + 1) * buttonMaignX) / CGFloat(totoalCols);
        
        let buttonHeight =
            UIDevice.is_iPad() ? (navigationBarHeight + statusBarHeight) : tabBarHeight;
        
        let count = scrollView.subviews.count
        
        for i in 0 ..< count {
            
            let row = CGFloat(i / totoalCols);
            let col = CGFloat(i % totoalCols);
            
            let channelButton = scrollView.subviews[i];
            
            channelButton.frame =
                CGRect(
                    x: buttonMaignX + col * (buttonWidth + buttonMaignX),
                    
                    y: buttonMaignY + (buttonMaignY + buttonHeight) * row,
                    
                    width: buttonWidth,
                    height: buttonHeight
            )
            
        }
     
        // 设置滚动范围
        let row =
            CGFloat((count % totoalCols + count) / totoalCols)
        
        let scrollHeight =
            (buttonMaignY + buttonHeight) * (row + 1)
        
        scrollView.contentSize =
            CGSize(width: 0, height: scrollHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRadioButtonView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}




