//
//  SHZoneNineInOneNumberPadView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneNineInOneNumberPadView: UIView, loadNiBView {

    /// 9in1模型
    var nineInOne: SHNineInOne?

    /// 所有的按钮父视图
    @IBOutlet weak var buttonsView: UIView!
    
    
    /// 按钮点击
    @objc private func numpadButtonClick(_ controlButton: UIButton?) {
        
        guard let button = controlButton,
            let nine = nineInOne else {
                return
        }
        
        SoundTools.share().playSound(withName: "click.wav")
        
        var controlType: UInt8 = 0;
       
        
        if button.currentTitle == "*" {
            
            controlType = UInt8(nine.switchIDforNumberAsterisk)
            
        } else if button.currentTitle == "#" {
            
            controlType = UInt8(nine.switchIDforNumberPound)
            
        } else {
            
            let text =
                "switchIDforNumber" +
                    (button.currentTitle ?? "")
       
            controlType =
                (nine.value(forKey: text) as? UInt8) ?? 0
            
        }
    
        SHSocketTools.sendData(
            operatorCode: 0xE01C,
            subNetID: nine.subnetID,
            deviceID: nine.deviceID,
            additionalData: [controlType, 0xFF]
        )
    }
}



// MARK: - UI
extension SHZoneNineInOneNumberPadView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let font =
            UIDevice.is_iPad() ? UIView.suitFontForPad() :
                UIFont.boldSystemFont(ofSize: 14)
        
        let textColor = UIView.textWhiteColor()
        
        // 创建11个按钮
        for i in 1 ... 12 {
            
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
                button?.setTitle("*", for: .normal)
            
            } else if 11 == i {
                
                button?.setTitle("0", for: .normal)
            
            } else if 12 == i {
                
                button?.setTitle("#", for: .normal)
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
        
        let realRows = CGFloat(count) / CGFloat(totalCols)
        
        let totalRows =
            Int(
                (realRows > CGFloat(Int(realRows))) ?
                    (realRows + 1) : realRows
        )
        
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
