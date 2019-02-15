//
//  SHScheduleControlItemView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/2/15.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit
 
/// 计划的控制项目
protocol SHScheduleControlItemViewDelegate {
    
    /// 选择不同的类型
    func schedueleControlItemChoice(
        _ controlType: SHSchdualControlItemType
    )
}
 

class SHScheduleControlItemView: UIView {
    
    /// 计划
    var schedule: SHSchedual?
    
    /// 代理
    var delegate: SHScheduleControlItemViewDelegate?
    
    /// 不同的控制类型 (注意与类型枚举类型匹配)
    private lazy var controlItems: [String] = [
        "Macro",
        "Mood",
        "Light",
        "HVAC",
        "Music",
        "Shade",
        "Floor heating"
    ]

    /// 滚动视图
    private lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScheduleControlItemView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 点击的回调
extension SHScheduleControlItemView {
    
    /// 选项点击
    @objc private func scheduleControlItemClick(button: UIButton) {
        
        guard let value = SHSchdualControlItemType(rawValue: UInt(button.tag)) else {
            
            return
        }
        
        delegate?.schedueleControlItemChoice(value)
    }
}


// MARK: - 创建与布局
extension SHScheduleControlItemView {
    
    /// 创建schedule 配置选项
    private func setupScheduleControlItemView() {
        
        addSubview(scrollView)
        
        let font =
            UIDevice.is_iPad() ? UIView.suitFontForPad():
                UIFont.boldSystemFont(ofSize: 16)
        
        let normalColor = UIView.textWhiteColor()
        let highlightedColor = UIView.highlightedTextColor()
        
        for i in 0 ..< controlItems.count {
            
            let button =
                UIButton(title: controlItems[i],
                         font: font,
                         normalTextColor: normalColor,
                         highlightedTextColor: highlightedColor,
                         imageName: nil,
                         backgroundImageName: nil,
                         addTarget: self,
                         action: #selector(scheduleControlItemClick(button:))
            )
            
            button?.tag = i + 1 // 从1开始
            
            button?.setRoundedRectangleBorder()
            
            scrollView.addSubview(button!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        let buttonMaignX = statusBarHeight
        let buttonMaignY = buttonMaignX
        
        let totoalCols =
            UIDevice.is_iPhone() ? 2 : 4
        
        let buttonWidth =
            (frame_width - CGFloat(totoalCols - 1) * buttonMaignX) / CGFloat(totoalCols)
        
        let buttonHeight =
            UIDevice.is_iPad() ? (navigationBarHeight + statusBarHeight) : tabBarHeight
        
        let count = scrollView.subviews.count
        
        for i in 0 ..< count {
            
            let row = CGFloat(i / totoalCols)
            let col = CGFloat(i % totoalCols)
            
            let channelButton = scrollView.subviews[i]
            
            channelButton.frame =
                CGRect(
                    x: col * (buttonWidth + buttonMaignX),
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
    
}
