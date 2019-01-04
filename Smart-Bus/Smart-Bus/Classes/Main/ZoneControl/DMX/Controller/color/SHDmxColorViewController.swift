//
//  SHDmxColorViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/9.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHDmxColorViewController: SHViewController {

    /// 当前的dmx分组
    var dmxGroup: SHDmxGroup?
    
    /// 所有的通道
    private lazy var groupChannels = [SHDmxChannel]()
    
    // 四个属性
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var alpha: UInt8 = 0
    
    /// 取色计
    private lazy var colorView: SHColorWheelView = {
        
        let view = SHColorWheelView()
        
        view.delegate = self
        
        return view
    }()
    
    /// 占位视图
    @IBOutlet weak var showColorView: UIView!

    /// 确定按钮
    @IBOutlet weak var sureButton: UIButton!
    
    /// 按钮高度
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 底部约束
    @IBOutlet weak var bottomMarignConstraint: NSLayoutConstraint!

    /// 完成
    @IBAction func sureButtonClick() {
    
        for dmxChannel in groupChannels {
            
            switch dmxChannel.channelType {
                
            case .red:
                sendDmxChannelData(dmxChannel: dmxChannel,
                                   value: red
                )
                
            case .green:
                sendDmxChannelData(dmxChannel: dmxChannel,
                                   value: green
                )
                
            case .blue:
                sendDmxChannelData(dmxChannel: dmxChannel,
                                   value: blue
                )
                
            case .white:
                sendDmxChannelData(dmxChannel: dmxChannel,
                                   value: alpha
                )
                
            case .none:
                break
            }
        }
    }

    /// 发送数据
    private func sendDmxChannelData(dmxChannel: SHDmxChannel,
                                    value: UInt8 = 0) {
        
        let dmxData = [
            dmxChannel.channelNo,
            value,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0031,
            subNetID: dmxChannel.subnetID,
            deviceID: dmxChannel.deviceID,
            additionalData: dmxData,
            isDMX: true
        )
    }
}


// MARK: - SHColorWheelViewDelegate
extension SHDmxColorViewController: SHColorWheelViewDelegate {
    
    /// 实现这个代理是为了方便发送数据
    func setZonesColorData(_ colorData: Data?, recognizer: UIGestureRecognizer?) {
        
        if colorData == nil ||
            recognizer == nil {
            
            return
        }
        
        let colors = [UInt8](colorData!)
        
        red   = colors[0]
        green = colors[1]
        blue  = colors[2]
        alpha = colors[3]
        
        let color =
            UIColor(red: CGFloat(red)/255.0,
                    green: CGFloat(green)/255.0,
                    blue: CGFloat(blue)/255.0,
                    alpha: CGFloat(alpha)/255.0
        )
        
        showColorView.backgroundColor = color
    }
}


// MARK: - UI初始化
extension SHDmxColorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(colorView)
        
        sureButton.setTitle(SHLanguageText.ok, for: .normal)
        sureButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            sureButton.titleLabel?.font = UIView.suitFontForPad()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let group = dmxGroup,
            let channels = SHSQLManager.share()?.getDmxGroupChannels(group) as? [SHDmxChannel] else {
                
                return
        }
        
        groupChannels = channels
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // 这个方法在重布局时调用，不显示(iPad, iPhone正常.)
        colorView.setNeedsDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let scale: CGFloat = isPortrait ? 0.7 : 0.5
        
        let colorWidth =
            min(view.frame_width, view.frame_height) * scale
        
        colorView.frame =
            CGRect(x: (view.frame_width - colorWidth) * 0.5,
                   y: statusBarHeight,
                   width: colorWidth,
                   height: colorWidth
        )
        
        // 在重绘制图片 -- 触发系统重新绘制 drawRect
        //        colorView.setNeedsDisplay(colorView.bounds)
        
        bottomMarignConstraint.constant = navigationBarHeight
        
        if UIDevice.is_iPad() {
            
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        
        } else if UIDevice.is_iPhoneX_More() {
        
             bottomMarignConstraint.constant = tabBarHeight_iPhoneX_more + statusBarHeight
        }
    }
}
