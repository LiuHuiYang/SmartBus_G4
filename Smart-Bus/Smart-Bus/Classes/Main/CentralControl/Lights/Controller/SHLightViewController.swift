//
//  SHLightViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/11/26.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

enum SHLightBrightness: UInt8 {
    case allClose           = 0
    case twentyFivePercent  = 25
    case fiftyFercent       = 50
    case seventyFivePercent = 75
    case allOpen            = 100
}

@objcMembers class SHLightViewController: SHViewController {
    
    /// 所有的灯光
    private lazy var allLights =
        SHSQLiteManager.shared.getCentralLights()
    
    /// 选中的灯光区域
    var selectCentrallightArea: SHCentralLight?
    
    /// 所有的灯光指令
    private lazy var allLightCommands = [SHCentralLightCommand]()
    
    /// 当前亮度
    private var currentBrightness: SHLightBrightness = .allClose
    
    /// 当前选择执行的命令按钮
    private var currentSelectCommandButton: UIButton?
    
    /// 命令按钮的高度约束
    @IBOutlet weak var commandButtonHeightConstraint: NSLayoutConstraint!
    
    /// 25%
    @IBOutlet weak var twentyFivePercentButton: UIButton!
    
    /// 25%进度条的背景
    @IBOutlet weak var twentyFivePercentProgressView: UIView!
    
    /// 50%
    @IBOutlet weak var fiftyFercentButton: UIButton!
    
    /// 50%进度条的背景
    @IBOutlet weak var fiftyFercentProgressView: UIView!
    
    /// 75%
    @IBOutlet weak var seventyFivePercentButton: UIButton!
    
    /// 75%进度条的背景
    @IBOutlet weak var seventyFivePercentProgressView: UIView!
    
    /// 全开
    @IBOutlet weak var allOpenButton: UIButton!
    
    /// 全开的进度条背景
    @IBOutlet weak var allOpenProgressView: UIView!
    
    /// 全关
    @IBOutlet weak var allCloseButton: UIButton!
    
    /// 全关的进度条背景
    @IBOutlet weak var allCloseProgressView: UIView!
    
    /// 显示区域区域
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title =
            (SHLanguageTools.share()?.getTextFromPlist(
                "CENTRAL_LIGHTS",
                withSubTitle: "TITLE_NAME")
            ) as! String
        
        navigationItem.title = title
        
        let open =
            (SHLanguageTools.share()?.getTextFromPlist(
                "CENTRAL_LIGHTS",
                withSubTitle: "ALL_LIGHT_ON")
            ) as! String
        
        allOpenButton.setTitle(open, for: .normal)
        
        let close =
            (SHLanguageTools.share()?.getTextFromPlist(
                "CENTRAL_LIGHTS",
                withSubTitle: "ALL_LIGHT_OFF")
                ) as! String
        
        allCloseButton.setTitle(close, for: .normal)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(commandButtonChangeStatus),
            name: NSNotification.Name(rawValue: commandExecutionComplete),
            object: nil
        )
        
        twentyFivePercentButton.setRoundedRectangleBorder()
        fiftyFercentButton.setRoundedRectangleBorder()
        seventyFivePercentButton.setRoundedRectangleBorder()
        allOpenButton.setRoundedRectangleBorder()
        twentyFivePercentButton.setRoundedRectangleBorder()
        allCloseButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            twentyFivePercentButton.titleLabel?.font = font
            fiftyFercentButton.titleLabel!.font = font
            seventyFivePercentButton.titleLabel?.font = font
            allOpenButton.titleLabel!.font = font
            allCloseButton.titleLabel!.font = font
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickerView.reloadAllComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
        pickerView(pickerView, didSelectRow: 0, inComponent: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is3_5inch() {
            
            commandButtonHeightConstraint.constant = tabBarHeight
        
        } else if UIDevice.is_iPad() {
        
            commandButtonHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
        }
    }
    
    @objc private func commandButtonChangeStatus() {
        
        currentSelectCommandButton?.isSelected = false
        currentSelectCommandButton = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - 点击事件
    
    /// 25%
    @IBAction func twentyFivePercentButtonClick() {
        
        currentBrightness = .twentyFivePercent
        
        changeProgressStatus(
            commandButton: twentyFivePercentButton,
            progressHoldView: twentyFivePercentProgressView
        )
    }
    
    /// 50%
    @IBAction func FiftyFercentButtonClick() {
        
        currentBrightness = .fiftyFercent
        
        changeProgressStatus(
            commandButton: fiftyFercentButton,
            progressHoldView: fiftyFercentProgressView
        )
    }
    
    /// 75%
    @IBAction func seventyFivePercentButtonClick() {
        
        currentBrightness = .seventyFivePercent
        
        changeProgressStatus(
            commandButton: seventyFivePercentButton,
            progressHoldView: seventyFivePercentProgressView
        )
    }
    
    /// 全关
    @IBAction func allOpenButtonClick() {
        
        currentBrightness = .allOpen
        
        changeProgressStatus(
            commandButton: allOpenButton,
            progressHoldView: allOpenProgressView
        )
    }
    
    /// 全关
    @IBAction func allCloseButtonClick() {
        
        currentBrightness = .allClose
        
        changeProgressStatus(
            commandButton: allCloseButton,
            progressHoldView: allCloseProgressView
        )
    }
}


// MARK: - 执行命令
extension SHLightViewController {
    
    /// 更新进度信息
    func changeProgressStatus(commandButton: UIButton, progressHoldView: UIView) {
        
        if allLightCommands.count == 0 {
            
            let foorName = selectCentrallightArea?.floorName ?? ""
            
            SVProgressHUD.showInfo(withStatus: "\(foorName) \(SHLanguageText.noData)")
            
            return
        }
        
        if currentSelectCommandButton == nil ||
           currentSelectCommandButton != commandButton {
            
            currentSelectCommandButton = commandButton
            commandButton.isSelected = true
            
            SHLoadProgressView.showIn(progressHoldView)
        }
        
        performSelector(inBackground: #selector(execute(commands:)), with: allLightCommands)
    }
    
    /// 执行指令
    @objc func execute(commands: [SHCentralLightCommand]) {
        
        for command in commands {
            
            let operatorCode = SHSocketTools.getOperatorCode(command.commandTypeID)
            
            let sendData:[UInt8] = [
                UInt8(command.parameter1),
                UInt8(currentBrightness.rawValue),
                UInt8(command.parameter2 >> 8),
                UInt8(command.parameter2 & 0xFF)
            ]
            
            SHSocketTools.sendData(
                operatorCode: operatorCode,
                subNetID: command.subnetID,
                deviceID: command.deviceID,
                additionalData: sendData
            )
            
            Thread.sleep(forTimeInterval: (TimeInterval(command.delayMillisecondAfterSend)/1000))
        }
    }
}


// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension SHLightViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let light = allLights[row]
        
        selectCentrallightArea = light
        
        allLightCommands =
            SHSQLiteManager.shared.getCentralLightCommands(
                light
        )
        
        if allLightCommands.isEmpty {
             
            let alertView =
                TYCustomAlertView(title: SHLanguageText.noData,
                                  message: nil,
                                  isCustom: true
            )
            
            let sureAction = TYAlertAction(title: SHLanguageText.ok,
                                           style: .default,
                                           handler: nil
            )
            
            alertView?.add(sureAction)
            
            let alertController =
                TYAlertController(alert: alertView!,
                                  preferredStyle: .alert,
                                  transitionAnimation: .fade
            )
            
            alertController?.backgoundTapDismissEnable = true
            
            present(alertController!, animated: true, completion: nil)
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        for singleLine in pickerView.subviews {
            
            if singleLine.frame_height < 1 {
                
                singleLine.backgroundColor = UIColor(hexString: "0xFCFCFC", alpha: 0.6)
            }
        }
        
        let cell = SHCentralLightCell.loadFromNib()
        
        cell.centralLight = allLights[row]
        
        return cell
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return SHCentralLightCell.rowHeight
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return allLights.count
    }
}
