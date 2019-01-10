//
//  SHZoneNineInOneSparePadView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/12/21.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

class SHZoneNineInOneSparePadView: UIView, loadNibView {

    /// 9in1模型
    var nineInOne: SHNineInOne? {
        
        didSet {
            
            guard let buttons = buttonsView.subviews as? [UIButton] else {
                return
            }
            
            for button in buttons{
                
                let key = "switchNameforSpare" + "\(button.tag)"
                let title = nineInOne?.value(forKey: key) as? String
                button.setTitle(title ?? "Spare_key",
                                for: .normal
                )
            }
        }
    }
    
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
     
        let text =
            "switchIDforSpare" + "\(button.tag)"
        
        controlType =
            (nine.value(forKey: text) as? UInt8) ?? 0
    
        SHSocketTools.sendData(
            operatorCode: 0xE01C,
            subNetID: nine.subnetID,
            deviceID: nine.deviceID,
            additionalData: [controlType, 0xFF]
        )
    }
}


// MARK: - UI
extension SHZoneNineInOneSparePadView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let font =
            UIDevice.is_iPad() ? UIView.suitFontForPad() :
                UIFont.boldSystemFont(ofSize: 14)
        
        let textColor = UIView.textWhiteColor()
        
        // 创建11个按钮
        for i in 1 ... 12 {
            
            let button =
                UIButton(title: "Spare_\(i)",
                    font: font,
                    normalTextColor: textColor,
                    highlightedTextColor: textColor,
                    imageName: nil,
                    backgroundImageName: "operatorButtonBackground",
                    addTarget: self,
                    action: #selector(numpadButtonClick(_:))
            )
            
            button?.tag = i
            button?.titleLabel?.textAlignment = .center
            button?.titleLabel?.numberOfLines = 0
            button?.titleLabel?.lineBreakMode = .byTruncatingMiddle
            button?.showsTouchWhenHighlighted = true
            buttonsView.addSubview(button!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var buttonHeight: CGFloat =
            UIDevice.is_iPad() ?
                (navigationBarHeight + statusBarHeight) :
        navigationBarHeight
        
        if UIDevice.is3_5inch() {
            
            buttonHeight = tabBarHeight
        }
        
        let count = buttonsView.subviews.count
        let totalCols = 3
        
        let realRows = CGFloat(count) / CGFloat(totalCols)
        
        let totalRows =
            Int(
                (realRows > CGFloat(Int(realRows))) ?
                    (realRows + 1) : realRows
        )
        
        let marignX: CGFloat = 15
        
        let marignY: CGFloat = (frame_height - buttonHeight * CGFloat(totalRows)) / CGFloat(totalRows + 1)
        
        let buttonWidth = (buttonsView.frame_width - marignX * CGFloat(totalCols + 1)) / CGFloat(totalCols)
        
        for i in 0 ..< count {
            
            let button = buttonsView.subviews[i]
            
            let row: Int = i / totalCols
            let col: Int = i % totalCols
            
            button.frame =
                CGRect(
                    x: marignX + CGFloat(col) * (buttonWidth + marignX),
                    y: marignY + CGFloat(row) * (buttonHeight + marignY),
                    width: buttonWidth,
                    height: buttonHeight
            )
        }
    }
}
