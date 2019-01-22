//
//  SHZoneShadeViewCell.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/31.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

class SHZoneShadeViewCell: UITableViewCell {
    
    /// 窗帘
    var shade: SHShade? {
        
        didSet {
            
            nameLabel.text = shade?.shadeName
            
            stopButton.isHidden = (shade?.hasStop == 0)
            
            let open = (shade?.remarkForOpen ?? "").isEmpty ? openButton.currentTitle : shade?.remarkForOpen
            
            let close = (shade?.remarkForClose ?? "").isEmpty ?  closeButton.currentTitle : shade?.remarkForClose
            
            let stop = (shade?.remarkForStop ?? "").isEmpty ? stopButton.currentTitle : shade?.remarkForStop
            
            openButton.setTitle(open, for: .normal)
            closeButton.setTitle(close, for: .normal)
            stopButton.setTitle(stop, for: .normal)
        }
    }
    
    static var rowHeight: CGFloat {
        
        if UIDevice.is_iPad() {
            
            return (navigationBarHeight * 3 + tabBarHeight)
        }
        
        return (navigationBarHeight * 2 + statusBarHeight)
    }
    
    /// 顶部开始约束
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    /// 窗帘图标的高度
    @IBOutlet weak var shadeIconViewHeightConstraint: NSLayoutConstraint!
    
    /// 操作按钮的高度
    @IBOutlet weak var operatorButtonHeightConstraint: NSLayoutConstraint!
    
    /// 图标按钮
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    /// 按下动作
    @IBAction func openButtonTouchDown() {
    
        guard let curtain = shade else {
            SVProgressHUD.showError(withStatus: SHLanguageText.noData)
            return
        }
        
        if curtain.controlType == .pushOnReleaseOff {
            
            let G4Curtain = [
                curtain.openChannel,
                curtain.openingRatio,
                UInt8(curtain.reserved1 >> 8),
                UInt8(curtain.reserved1 & 0xFF)
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: G4Curtain
            )
            
            SVProgressHUD.showSuccess(withStatus: "\(SHLanguageText.shadeExecuted) \(openButton.currentTitle ?? "")")
        }
    }
    
    /// 打开
    @IBAction func openButtonClick() {

        guard let curtain = shade else {
            SVProgressHUD.showError(withStatus: SHLanguageText.noData)
            return
        }
        
        switch curtain.controlType {
        
        case .defaultControl:
            
            let G4Curtain = [
                curtain.openChannel,
                curtain.openingRatio,
                UInt8(curtain.reserved1 >> 8),
                UInt8(curtain.reserved1 & 0xFF)
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: G4Curtain
            )
            
            SHSocketTools.sendData(
                operatorCode: 0xE3E0,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData:
                    [curtain.openChannel, curtain.openingRatio]
            )
            
            break
           
        case .universalSwitch:
           
            SHSocketTools.sendData(
                operatorCode: 0xE01C,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: [UInt8(curtain.switchIDforOpen),
                                 UInt8(curtain.switchIDStatusforOpen)]
            )
            
        case .pushOnReleaseOff:
            
            let G4Curtain = [
                curtain.openChannel,
                0,
                UInt8(curtain.reserved1 >> 8),
                UInt8(curtain.reserved1 & 0xFF)
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: G4Curtain
            )
            
            SVProgressHUD.showSuccess(withStatus: SHLanguageText.shadeStop)
            return
            
        default:
            break
        }
        
        curtain.currentStatus = .open
        
        SVProgressHUD.showSuccess(withStatus: "\(SHLanguageText.shadeExecuted) \(openButton.currentTitle ?? "")")
    }
    
    /// 关闭按钮按下
    @IBAction func closeButtonTouchDown() {
    
        guard let curtain = shade else {
            SVProgressHUD.showError(withStatus: SHLanguageText.noData)
            return
        }
        
        if curtain.controlType == .pushOnReleaseOff {
            
            let G4Curtain = [
                curtain.closeChannel,
                curtain.closingRatio,
                UInt8(curtain.reserved1 >> 8),
                UInt8(curtain.reserved1 & 0xFF)
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: G4Curtain
            )
            
             SVProgressHUD.showSuccess(withStatus: "\(SHLanguageText.shadeExecuted) \(closeButton.currentTitle ?? "")")
        }
    }
    
    /// 关闭
    @IBAction func closeButtonClick() {

        guard let curtain = shade else {
            SVProgressHUD.showError(withStatus: SHLanguageText.noData)
            return
        }
        
        switch curtain.controlType{
        case .defaultControl:
            
            let G4Curtain = [
                curtain.closeChannel,
                curtain.closingRatio,
                UInt8(curtain.reserved1 >> 8),
                UInt8(curtain.reserved1 & 0xFF)
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: G4Curtain
            )
            
            SHSocketTools.sendData(
                operatorCode: 0xE3E0,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: [curtain.closeChannel,
                                 curtain.closingRatio]
            )
            
            break
            
        case .universalSwitch:
            
            SHSocketTools.sendData(
                operatorCode: 0xE01C,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData:
                [UInt8(curtain.switchIDforClose),
                 UInt8(curtain.switchIDStatusforClose)
                    ]
            )
            
        case .pushOnReleaseOff:
            
            let G4Curtain = [
                curtain.closeChannel,
                0,
                UInt8(curtain.reserved1 >> 8),
                UInt8(curtain.reserved1 & 0xFF)
            ]
            
            SHSocketTools.sendData(
                operatorCode: 0x0031,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: G4Curtain
            )
            
            SVProgressHUD.showSuccess(withStatus: "\(SHLanguageText.shadeStop)")
            
            return
        
        default:
            break
        }
        
        curtain.currentStatus = .close
        
        SVProgressHUD.showSuccess(withStatus: "\(SHLanguageText.shadeExecuted) \(closeButton.currentTitle ?? "")")
       
    }
    
    /// 停止
    @IBAction func stopButtonClick() {

        guard let curtain = shade else {
            
            SVProgressHUD.showError(withStatus: SHLanguageText.noData)
            return
        }
        
        if curtain.hasStop == 0 {
            return
        }
        
        switch curtain.controlType {
        
        case .defaultControl:
        
            //  G4 == 三路 独立的窗帘停止通道
            if curtain.stopChannel != 0 {
                
                let G4Curtain = [
                    curtain.stopChannel,
                    curtain.stoppingRatio,
                    UInt8(curtain.reserved1 >> 8),
                    UInt8(curtain.reserved1 & 0xFF)
                ]
                
                SHSocketTools.sendData(
                    operatorCode: 0x0031,
                    subNetID: curtain.subnetID,
                    deviceID: curtain.deviceID,
                    additionalData: G4Curtain
                )
            
            } else {
            
                let channel =
                (shade?.currentStatus == .open) ? curtain.openChannel : curtain.closeChannel
                
                let G4Curtain = [
                    channel,
                    0,
                    UInt8(curtain.reserved1 >> 8),
                    UInt8(curtain.reserved1 & 0xFF)
                ]
                
                SHSocketTools.sendData(
                    operatorCode: 0x0031,
                    subNetID: curtain.subnetID,
                    deviceID: curtain.deviceID,
                    additionalData: G4Curtain
                )
                
                SHSocketTools.sendData(
                    operatorCode: 0xE3E0,
                    subNetID: curtain.subnetID,
                    deviceID: curtain.deviceID,
                    additionalData: [channel, 0]
                )
            }
            
            
        case .universalSwitch:
            
            SHSocketTools.sendData(
                operatorCode: 0xE01C,
                subNetID: curtain.subnetID,
                deviceID: curtain.deviceID,
                additionalData: [UInt8(curtain.switchIDforStop),
                                 UInt8(curtain.switchIDStatusforStop)
                                ]
            )
            
        case .pushOnReleaseOff:
            return
            
        default:
            break
        }
        
        SVProgressHUD.showSuccess(withStatus: "\(SHLanguageText.shadeExecuted) \(stopButton.currentTitle ?? "")")
    }
}


// MARK: - UI
extension SHZoneShadeViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        openButton.setRoundedRectangleBorder()
        stopButton.setRoundedRectangleBorder()
        closeButton.setRoundedRectangleBorder()
        
        openButton.setTitle(
            SHLanguageText.shadeOpen,
            for: .normal
        )
        
        stopButton.setTitle(
            SHLanguageText.shadeStop,
            for: .normal
        )
        
        closeButton.setTitle(
            SHLanguageText.shadeClose,
            for: .normal
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            openButton.titleLabel?.font = font
            closeButton.titleLabel?.font = font
            stopButton.titleLabel?.font = font
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.is_iPad() {
            
            topConstraint.constant =
                (tabBarHeight - statusBarHeight)
            
            shadeIconViewHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
            
            operatorButtonHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
        }
    }
}
