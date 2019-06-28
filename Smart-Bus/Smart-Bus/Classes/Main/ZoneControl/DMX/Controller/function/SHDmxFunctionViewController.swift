//
//  SHDmxFunctionViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/5/10.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

class SHDmxFunctionViewController: SHViewController {
    
    /// 分组
    var dmxGroup: SHDmxGroup?
    
    /// 当前分组中的所有通道
    private lazy var groupChannels = [SHDmxChannel]()
    
    /// 场景颜色
    private lazy var sceneColors = [UIColor]()
    
    /// 所有的场景名称
    private lazy var scenes = [
        "Seven Color Cross Fade",
        "Red Gradual Change",
        "Green Gradual Change",
        "Blue Gradual Change",
        "White Fade Change",
        "Red And Blue",
        "Green And Red",
        "Green And Blue"
    ]
    
    /// 执行场景的序号(下标)
    private var executeIndex = 0
    
    /// 定时器
    private var timer: Timer?
    
    /// 输入值框
    var valueTextField: UITextField?
    
    /// 按钮高度
    @IBOutlet weak var baseViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    /// 显示当前的颜色
    @IBOutlet weak var showColorView: UIView!
    
    /// 关闭按钮
    @IBOutlet weak var turnOffButton: UIButton!
    
    /// 设定时间按钮
    @IBOutlet weak var timeButton: UIButton!
    
   
}


// MARK: - 点击事件
extension SHDmxFunctionViewController {
    
    /// 时间选择
    @IBAction func timeButtonClick() {
        
        let alertView =
            TYCustomAlertView(
                title: "Setting execution time",
                message: nil,
                isCustom: true
        )
        
        alertView?.addTextField(configurationHandler: { textField in
            
            textField?.becomeFirstResponder()
            textField?.keyboardType = .numberPad
            textField?.clearButtonMode = .whileEditing
            textField?.textAlignment = .center
            
            self.valueTextField = textField
        })
        
        let cancelAction =
            TYAlertAction(
                title: SHLanguageText.cancel,
                style: .cancel,
                handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let saveAction = TYAlertAction(title: SHLanguageText.save, style: .destructive) { (action) in
            
            if let time = self.valueTextField?.text,
                !time.isEmpty {
                
                self.timeButton.setTitle(
                    "\(time) Second",
                    for: .normal
                )
                
                self.startSendColors()
            }
        }
        
        alertView?.add(saveAction)
        
        let alertController =
            TYAlertController(
                alert: alertView,
                preferredStyle: .alert,
                transitionAnimation: .scaleFade
        )
        
        alertController?.alertViewOriginY =
            navigationBarHeight +
            (UIDevice.is_iPhoneX_More() ?
                defaultHeight :
                statusBarHeight
        )
        
        let rootViewController =
        UIApplication.shared.keyWindow?.rootViewController
        
        rootViewController?.present(
            alertController!,
            animated: true,
            completion: nil
        )
    }
    
    /// 关闭按钮点击
    @IBAction func turnOfButtonClick() {
        
        turnOffButton.isSelected =
            !turnOffButton.isSelected
        
        startSendColors()
    }
}

// MARK: - 颜色控制
extension SHDmxFunctionViewController {

    /// 发送颜色
    private func startSendColors() {
        
        if timer != nil {
            
            timer?.invalidate()
            timer = nil
            
            //  每次选择后，执行的颜色下标都是从0开始，不能累加
            executeIndex = 0
        }
        
        // 停止, 不再启动定时器
        if turnOffButton.isSelected == false {
            
            return
        }
        
        guard let timeString =
            timeButton.currentTitle?.components(
                separatedBy: " "
                ).first ,
        
        let time = Double(timeString) else {
                    
            return
        }
        
        let senceTimer =
            Timer(
                timeInterval: time,
                target: self,
                selector: #selector(changeColor),
                userInfo: nil,
                repeats: true
        )
    
        RunLoop.current.add(senceTimer, forMode: .common)
        
        timer = senceTimer
        
        timer?.fire()
        
        turnOffButton.isSelected = true
    }
    
    /// 改变颜色
    @objc private func changeColor() {
        
        executeIndex += 1
        
        executeIndex %= sceneColors.count
        
        let color = sceneColors[executeIndex]
        
        showColorView.backgroundColor = color
        
        // 发送每个通道的颜色
        var redColor: CGFloat = 0
        var greenColor: CGFloat = 0
        var blueClor: CGFloat = 0
        var whiteColor: CGFloat = 0

        color.getRed(&redColor,
                     green: &greenColor,
                     blue: &blueClor,
                     alpha: &whiteColor
        )

        let red =
            UInt8(redColor * CGFloat(lightMaxBrightness))
        
        let green =
             UInt8(greenColor * CGFloat(lightMaxBrightness))
        
        let blue =
             UInt8(blueClor * CGFloat(lightMaxBrightness))
        
        let white =
             UInt8(whiteColor * CGFloat(lightMaxBrightness))
        
        
        for channel in groupChannels {
            
            switch channel.channelType {
                
            case .red :
                sendDmxChannleData(channel, value: red)
                
            case .green :
                sendDmxChannleData(channel, value: green)
                
            case .blue :
                sendDmxChannleData(channel, value: blue)
                
            case .white :
                sendDmxChannleData(channel, value: white)
                
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


// MARK: - UIPickerViewDelegate
extension SHDmxFunctionViewController: UIPickerViewDelegate {
    
    /// 选择视图
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch row {
        
        case 0:
            sceneColors = [
                UIColor.red,
                UIColor(hex: 0xFFA500, alpha: 1.0),
                UIColor.yellow,
                UIColor.green,
                UIColor(hex: 0x007F00, alpha: 1.0),
                UIColor.blue,
                UIColor(hex: 0x8B00FF, alpha: 1.0)
            ]
            
        case 1:
            sceneColors = [
                UIColor.red,
                UIColor.white
            ]
            
        case 2:
            sceneColors = [
                UIColor.green,
                UIColor.white
            ]
            
        case 3:
            sceneColors = [
                UIColor.blue,
                UIColor.white
            ]
            
        case 4:
            sceneColors = [
                
                UIColor.white,
                UIColor(white: 0, alpha: 0)
            ]
            
        case 5:
            sceneColors = [
                UIColor.red,
                UIColor.blue
            ]
            
        case 6:
            sceneColors = [
                UIColor.green,
                UIColor.red
            ]
            
        case 7:
            sceneColors = [
                UIColor.green,
                UIColor.blue
            ]
        
        default:
            break
        }
        
        startSendColors()
    }
    
    /// 返回显示视图
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        for singleLine in pickerView.subviews {
            
            if singleLine.frame_height < 1 {
                
                singleLine.backgroundColor = UIColor(hexString: "0xFCFCFC", alpha: 0.6)
            }
        }
        
        let customView =
            SHDmxFunctionCustomView.loadFromNib()
        
        customView.sceneName = scenes[row]
        
        return customView
    }
    
    /// 返回行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return SHDmxFunctionCustomView.rowHeight
    }
    
}

// MARK: - UIPickerViewDataSource
extension SHDmxFunctionViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return scenes.count
    }
}

// MARK: - UI初始化
extension SHDmxFunctionViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pickerView.selectRow(0,
                             inComponent: 0,
                             animated: true
        )
        
        self.pickerView(pickerView,
                        didSelectRow: 0,
                        inComponent: 0
        )
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
        
        pickerView.reloadAllComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        turnOffButton.setTitle(SHLanguageText.off, for: .normal)
        
        turnOffButton.setTitle(SHLanguageText.on, for: .selected)
        
        turnOffButton.setRoundedRectangleBorder()
        timeButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            timeButton.titleLabel?.font = font
            turnOffButton.titleLabel?.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            baseViewHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
}
