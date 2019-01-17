//
//  SHSceneControlViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHSceneControlViewCell: UITableViewCell {
    
    /// 场景控制
    var scene: SHScene? {
        
        didSet {
            
            nameLabel.text = scene?.remark
        }
    }
    
    /// 行高
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return navigationBarHeight * 2 + statusBarHeight
        }
        
        return navigationBarHeight + statusBarHeight
    }
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 开始执行按钮
    @IBOutlet weak var runButton: UIButton!
    
    /// 停止执行按钮
    @IBOutlet weak var stopButton: UIButton!
    
    /// 图片的宽度
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    
    /// 图片的高度
    @IBOutlet weak var iconViewHeightConstraint: NSLayoutConstraint!
    
    /// 初始化
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.red
        selectionStyle = .none
        
        runButton.setTitle(SHLanguageText.on,
                           for: .normal
        )
        
        stopButton.setTitle(SHLanguageText.off,
                            for: .normal
        )
        
        runButton.setRoundedRectangleBorder()
        stopButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            nameLabel.font = font
            runButton.titleLabel?.font = font
            stopButton.titleLabel?.font = font
        }
    }
    
    /// 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            iconViewWidthConstraint.constant = navigationBarHeight * 2
            
            iconViewHeightConstraint.constant =
                navigationBarHeight * 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// 开始执行场景 
    @IBAction func runButtonClick() {
        
         executeScene(isStop: false)
    }
    
    /// 停止执行场景
    @IBAction func stopButtonClick() {
    
        executeScene(isStop: true)
    }
    
    
    /// 执行scene
    ///
    /// - Parameter isStop: 是否停止执行
    private func executeScene(isStop: Bool = false) {
        
        guard let sceneControl = scene else {
            return
        }
        
        SHSocketTools.sendData(
            operatorCode: 0x0002,
            subNetID: sceneControl.subnetID,
            deviceID: sceneControl.deviceID,
            additionalData:
                [sceneControl.areaNo,
                 isStop ? 0 : sceneControl.sceneNo]
        )
    }
}



