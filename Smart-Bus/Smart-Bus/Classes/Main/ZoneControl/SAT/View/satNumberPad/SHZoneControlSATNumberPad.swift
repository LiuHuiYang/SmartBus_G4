//
//  SHZoneControlSATNumberPad.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/8/8.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

class SHZoneControlSATNumberPad: UIView, loadNiBView {

    /// 卫星电视
    var mediaSAT: SHMediaSAT?

    /// 所有的按钮父视图
    @IBOutlet weak var buttonsView: UIView!
    
    /// 按钮点击
    @objc private func numpadButtonClick(_ controlButton: UIButton?) {
        
        guard let button = controlButton,
            let sat = mediaSAT else {
                return
        }
        
        SoundTools.share().playSound(withName: "click.wav")
        
        var controlType: UInt8 = 0
        
        if button.currentTitle == SHLanguageText.ok {
            
            controlType =
                UInt8(sat.universalSwitchIDforOK)
            
        } else {
            
            let text =
                "universalSwitchIDfor" +
                    (button.currentTitle ?? "")
            
            controlType =
                (sat.value(forKey: text) as? UInt8) ?? 0
            
        }
        
        SHSocketTools.sendData(
            operatorCode: 0xE01C,
            subNetID: sat.subnetID,
            deviceID: sat.deviceID,
            additionalData: [controlType, 0xFF]
        )
    }
}


// MARK: - UI
extension SHZoneControlSATNumberPad {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let textColor = UIView.textWhiteColor()
        let font =
            UIDevice.is_iPad() ?
                UIView.suitFontForPad() :
                UIFont.boldSystemFont(ofSize: 16)
        
        for i in 1 ..< 12  {
        
            let button =
                UIButton(title: "\(i)",
                    font: font,
                    normalTextColor: textColor,
                    highlightedTextColor: textColor,
                    imageName: nil,
                    backgroundImageName: "mediaMenubuttonbackground",
                    addTarget: self,
                    action: #selector(numpadButtonClick(_:))
            )
            
            button?.showsTouchWhenHighlighted = true
            
            if 10 == i {
                button?.setTitle(SHLanguageText.ok, for: .normal)
            }
            
            if 11 == i {
                
                button?.setTitle("0", for: .normal)
            }
            
            buttonsView.addSubview(button!)
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var buttonSize: CGFloat =
            UIDevice.is_iPad() ?
                (navigationBarHeight + statusBarHeight) :
        navigationBarHeight
        
        if UIDevice.is3_5inch() {
            
            buttonSize = tabBarHeight
        }
        
        let count = buttonsView.subviews.count
        let totalCols = 3
        
        let realRows = count / totalCols
        let totalRows = (count % totalCols == 0) ? realRows : realRows + 1
        
        let marignX: CGFloat =
            (buttonsView.frame_width - buttonSize * CGFloat(totalCols)) / CGFloat(totalCols + 1)
        
        let marignY: CGFloat = (frame_height - buttonSize * CGFloat(totalRows)) / CGFloat(totalRows + 1)
        
        for i in 0 ..< count {
            
            let button = buttonsView.subviews[i]
            
            let row: Int = i / totalCols
            let col: Int = i % totalCols
            
            button.frame =
                CGRect(
                    x: marignX + CGFloat(col) * (buttonSize + marignX),
                    y: marignY + CGFloat(row) * (buttonSize + marignY),
                    width: buttonSize,
                    height: buttonSize
            )
        }
    }
}
