//
//  SHDmxPictureViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHDmxPictureViewController: SHViewController {

    /// 当前的dmx分组
    var dmxGroup: SHDmxGroup?
    
    // 四个颜色通道
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var alpha: UInt8 = 0
 
    /// 所有的dmx通道
    private lazy var groupChannels = [SHDmxChannel]()

    /// 选择照片按钮
    @IBOutlet weak var photoButton: UIButton!
    
    /// 选择相机按钮
    @IBOutlet weak var camereButton: UIButton!
    
    /// 获取到的图片
    @IBOutlet weak var iconView: UIImageView!
    
    /// 选择的颜色显示
    @IBOutlet weak var showColorView: UIView!
    
    /// 发送按钮
    @IBOutlet weak var sureButton: UIButton!
    
    /// 按钮高度
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 底部约束
    @IBOutlet weak var bottomMarignConstraint: NSLayoutConstraint!
 
}


// MARK: - 点击事件 -> 控制颜色通道
extension SHDmxPictureViewController {
    
    /// 发送按钮点击
    @IBAction func sureButtonClick() {
        
        for channel in groupChannels {
            
            switch channel.channelType {
                
            case .red :
                sendDmxChannleData(channel, value: red)
                
            case .green :
                sendDmxChannleData(channel, value: green)
                
            case .blue :
                sendDmxChannleData(channel, value: blue)
                
            case .white :
                sendDmxChannleData(channel, value: alpha)
            
            case .none:
                break
            }
        }
    }

    
    /// 发送控制颜色通道的的值
    ///
    /// - Parameters:
    ///   - channel: 颜色通道
    ///   - value: 值
    private func sendDmxChannleData(
        _ channel: SHDmxChannel,
        value: UInt8) {
        
        let dmxData = [
            channel.channelNo,
            value,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0031,
            subNetID: channel.subnetID,
            deviceID: channel.deviceID,
            additionalData: dmxData,
            isDMX: true
        )
    }
}


// MARK: - 选择照片的代理
extension SHDmxPictureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
         dismiss(animated: true, completion: nil)
        
       guard let image =
        info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
        
        let icon = UIImage.fixOrientation(image),
        
        let sourceImage = UIImage.fixOrientation(icon) else {
            
            return
        }
        
        if picker.sourceType == .camera {
            
            UIImageWriteToSavedPhotosAlbum(
                sourceImage, self, nil, nil
            )
        }
        
        iconView.image = sourceImage
        
        getImageColor()
    }
}

// MARK: - 点击事件
extension SHDmxPictureViewController {
    
    /// 照片
    @IBAction func photoButtonClick() {
        
        if UIImagePickerController.isSourceTypeAvailable(
            .photoLibrary ) == false {
            
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    /// 相机
    @IBAction func cameraButtonClick() {
        
        if UIImagePickerController.isSourceTypeAvailable(
            .camera ) == false {
            
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
}


// MARK: - UI初始化
extension SHDmxPictureViewController {
    
    /// 获得图片的颜色
    private func getImageColor() {
        
        for subView in showColorView.subviews {
            
            subView.removeFromSuperview()
        }
        
        guard let colors =
            UIImageView.mainColours(in: iconView.image)
                as? [UIColor] else {
                    
            return
        }
        
        let cout = colors.count
        
        for i in 0 ..< cout {
        
            let button = UIButton()
            
            button.backgroundColor = colors[i]
            button.tag = i
            showColorView.addSubview(button)
            
            button.addTarget(
                self,
                action: #selector(showSelectColor(_:)),
                for: .touchUpInside
            )
        }

        layoutColorButton()
    }
    
    /// 显示选择的颜色
    @objc private func showSelectColor(_ button: UIButton?) {
        
        guard let color = button?.backgroundColor else {
            
            return
        }
        
        sureButton.backgroundColor = color
        
        var redColor: CGFloat = 0.0
        var greenColor: CGFloat = 0.0
        var blueColor: CGFloat = 0.0
        var alphaValue: CGFloat = 0.0
        
        color.getRed(&redColor,
                     green: &greenColor,
                     blue: &blueColor,
                     alpha: &alphaValue
        )
        
        red = UInt8(redColor * CGFloat(lightMaxBrightness))
        
        green =
            UInt8(greenColor * CGFloat(lightMaxBrightness))
        
        blue =
            UInt8(blueColor * CGFloat(lightMaxBrightness))
        
        alpha =
            UInt8(alphaValue * CGFloat(lightMaxBrightness))

    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let group = dmxGroup else {
            
            return
        }
        groupChannels =
            SHSQLiteManager.shared.getDmxGroupChannels(group)
        
        if groupChannels.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoButton.imageView?.contentMode =
            .scaleAspectFit
        camereButton.imageView?.contentMode =
            .scaleAspectFit
        
//        iconView.contentMode = .scaleAspectFit

        sureButton.setTitle(SHLanguageText.ok,
                            for: .normal
        )
        
        sureButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            sureButton.titleLabel?.font =
                UIView.suitFontForPad()
        }
    }
}

// MARK: - 布局
extension SHDmxPictureViewController {
    
    /// 布局颜色按钮
    private func layoutColorButton() {
        
        let count = showColorView.subviews.count
        
        if count == 0 {
            return
        }
        
        let buttonWidth =
            showColorView.frame_width / CGFloat(count)
        
        let buttonHeight = showColorView.frame_height
        
        for button in showColorView.subviews {
            
            button.frame =
                CGRect(x: CGFloat(button.tag) * buttonWidth,
                       y: 0,
                       width: buttonWidth,
                       height: buttonHeight
            )
        }
    }
    
    /// 布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutColorButton()
        
        bottomMarignConstraint.constant =
            UIDevice.is_iPhoneX_More() ?
            (tabBarHeight_iPhoneX_more + statusBarHeight) :
            navigationBarHeight
        
        if UIDevice.is_iPad() {
            
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
}
