//
//  SHZoneTVSpareView.swift
//  Smart-Bus
//
//  Created by Apple on 2019/4/1.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHZoneTVSpareView: UIView, loadNibView {

    /// TV模型
    var mediaTV: SHMediaTV? {
        
        didSet {
            
            guard let buttons = listView.subviews as? [UIButton] else {
                return
            }
            
            for button in buttons{
                
                let key = "switchNameforSpare" + "\(button.tag)"
                let title = mediaTV?.value(forKey: key) as? String
                button.setTitle(title ?? "Spare_key",
                                for: .normal
                )
            }
        }
    }
    
    /// 视图列表
    @IBOutlet weak var listView: UIView!
    
    /// 按钮点击
    @objc private func numpadButtonClick(_ controlButton: UIButton?) {
        
        guard let button = controlButton,
            let nine = mediaTV else {
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
extension SHZoneTVSpareView {
    
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
            listView.addSubview(button!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var buttonHeight: CGFloat =
            UIDevice.is_iPad() ?
                (navigationBarHeight + statusBarHeight):
                navigationBarHeight
        
        if UIDevice.is3_5inch() {
            
            buttonHeight = tabBarHeight
        }
        
        let count = listView.subviews.count
        let totalCols = 3
        
        let realRows = CGFloat(count) / CGFloat(totalCols)
        
        let totalRows =
            Int(
                (realRows > CGFloat(Int(realRows))) ?
                    (realRows + 1) : realRows
        )
        
        let marignX: CGFloat = 15
        
        let marignY: CGFloat = (frame_height - buttonHeight * CGFloat(totalRows)) / CGFloat(totalRows + 1)
        
        let buttonWidth = (listView.frame_width - marignX * CGFloat(totalCols + 1)) / CGFloat(totalCols)
        
        for i in 0 ..< count {
            
            let button = listView.subviews[i]
            
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
