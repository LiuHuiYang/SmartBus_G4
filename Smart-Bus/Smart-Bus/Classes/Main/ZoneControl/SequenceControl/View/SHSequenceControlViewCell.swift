//
//  SHSequenceControlViewCell.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHSequenceControlViewCell: UITableViewCell {

    /// 序列控制
    var sequence: SHSequence? {
        
        didSet {
            
            nameLabel.text = sequence?.remark
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
        
        backgroundColor = UIColor.clear
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
        
        executeSequence(isStop: false)
    }
    
    /// 停止执行场景
    @IBAction func stopButtonClick() {
        
        executeSequence(isStop: true)
    }
    
    
    /// 执行scene
    ///
    /// - Parameter isStop: 是否停止执行
    private func executeSequence(isStop: Bool = false) {
        
        guard let sequenceControl = sequence else {
            return
        }
        
        SHSocketTools.sendData(
            operatorCode: 0x001A,
            subNetID: sequenceControl.subnetID,
            deviceID: sequenceControl.deviceID,
            additionalData:
                [sequenceControl.areaNo,
                 isStop ? 0 : sequenceControl.sequenceNo
            ]
        )
    }
    
}
