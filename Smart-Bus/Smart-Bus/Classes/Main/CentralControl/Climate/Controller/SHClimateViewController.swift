//
//  SHClimateViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/11/26.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHClimateViewController: SHViewController {

    /// 选中的区域空调
    var selectCentralHVAC: SHCentralHVAC?
    
    /// 所有的空调
    private lazy var allHVACs: [SHCentralHVAC] =
        SHSQLiteManager.shared.getCentralClimates()
    
    /// 区域空调对应的指令
    private var hvacCommands = [SHCentralHVACCommand]()
    
    /// 当前选择的命令按钮
    private var currentSelectCommandButton: SHCommandButton?
    
    /// 空调模式
    private var hvacMode: UInt8 = 0
    
    /// 空调值
    private var hvacValue: UInt8 = 0
    
    /// 命令按钮的高度
    @IBOutlet weak var commandButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    
    /// 区域选择列表
    @IBOutlet weak var zonePickerView: UIPickerView!
    
    /// 全开 按钮
    @IBOutlet weak var allOnButton: SHCommandButton!
    
    /// 全开背景视图
    @IBOutlet weak var allOnProgressbackView: UIView!
    
    /// 全关 按钮
    @IBOutlet weak var allOffButton: SHCommandButton!
    
    /// 全关 背景视图
    @IBOutlet weak var allOffProgressbackView: UIView!
    
    /// 凉快 按钮
    @IBOutlet weak var coolButton: SHCommandButton!
    
    /// 凉快 背景视图
    @IBOutlet weak var coolProgressbackView: UIView!
    
    /// 制冷 按钮
    @IBOutlet weak var coldButton: SHCommandButton!
    
    /// 制冷 背景视图
    @IBOutlet weak var coldProgressbackView: UIView!
    
    /// 暖和 按钮
    @IBOutlet weak var warmButton: SHCommandButton!
    
    /// 暖和 背景视图
    @IBOutlet weak var warmProgressbackView: UIView!
    
    /// 制热 按钮
    @IBOutlet weak var hotButton: SHCommandButton!
    
    /// 制热 背景视图
    @IBOutlet weak var hotProgressbackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title =
            (SHLanguageTools.share()?.getTextFromPlist(
                "CLIMATE",
                withSubTitle: "TITLE_NAME")
                ) as! String
        
        navigationItem.title = title
        
        let on =
            (SHLanguageTools.share()?.getTextFromPlist(
                "CLIMATE",
                withSubTitle: "ALL_AC_ON")
            ) as! String
        
        allOnButton.setTitle(on, for: .normal)
        
        let off =
            (SHLanguageTools.share()?.getTextFromPlist(
                "CLIMATE",
                withSubTitle: "ALL_AC_OFF")
            ) as! String
        
        allOffButton.setTitle(off, for: .normal)
        
       
        let modes =
            SHLanguageTools.share()?.getTextFromPlist(
                "CLIMATE",
                withSubTitle: "ALL_AC_MODE"
            ) as! [String]
    
        coldButton.setTitle(modes[0], for: .normal)
        coolButton.setTitle(modes[1], for: .normal)
        hotButton.setTitle( modes[2], for: .normal)
        warmButton.setTitle(modes[3], for: .normal)
        
        allOnButton.setRoundedRectangleBorder()
        allOffButton.setRoundedRectangleBorder()
        coolButton.setRoundedRectangleBorder()
        coldButton.setRoundedRectangleBorder()
        warmButton.setRoundedRectangleBorder()
        hotButton.setRoundedRectangleBorder()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(commandButtonChangeStatus),
            name: NSNotification.Name(rawValue: commandExecutionComplete),
            object: nil
        )
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            allOnButton.titleLabel?.font = font
            allOffButton.titleLabel!.font = font
            coldButton.titleLabel?.font = font
            coolButton.titleLabel!.font = font
            warmButton.titleLabel!.font = font
            hotButton.titleLabel!.font = font
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        zonePickerView.selectRow(0, inComponent: 0, animated: true)
        
        pickerView(zonePickerView, didSelectRow: 0, inComponent: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is3_5inch() {
            
            commandButtonHeightConstraint.constant = defaultHeight
        
        } else if UIDevice.is4_0inch() {
        
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
    
    /// 全开
    @IBAction func allOnClick() {
        
        hvacMode = SHAirConditioningControlType.onAndOff.rawValue
        hvacValue = SHAirConditioningSwitchType.on.rawValue
        
        changeProgressStatus(commandButton: allOnButton,
                             progressHoldView: allOnProgressbackView
        )
    }
    
    /// 全开
    @IBAction func allOffClick() {
        
        hvacMode = SHAirConditioningControlType.onAndOff.rawValue
        hvacValue = SHAirConditioningSwitchType.off.rawValue
        
        changeProgressStatus(commandButton: allOffButton,
                             progressHoldView: allOffProgressbackView
        )
    }
    
    /// 凉快
    @IBAction func coolClick() {
        
        hvacMode = SHAirConditioningControlType.acModeSet.rawValue
        hvacValue = SHAirConditioningModeType.fan.rawValue
        
        changeProgressStatus(commandButton: coolButton,
                             progressHoldView: coolProgressbackView
        )
    }
    
    /// 制冷
    @IBAction func coldClick() {
        
        hvacMode = SHAirConditioningControlType.acModeSet.rawValue
        hvacValue = SHAirConditioningModeType.cool.rawValue
        
        changeProgressStatus(commandButton: coldButton,
                             progressHoldView: coldProgressbackView
        )
    }
    
    /// 制热
    @IBAction func hotClick() {
        
        
        if selectCentralHVAC?.isHaveHot == false {
            
            SVProgressHUD.showInfo(withStatus: "No heating function")
            
            return
        }
        
        hvacMode = SHAirConditioningControlType.acModeSet.rawValue
        hvacValue = SHAirConditioningModeType.heat.rawValue
        
        changeProgressStatus(commandButton: hotButton,
                             progressHoldView: hotProgressbackView
        )
    }

}

// MARK: - 执行命令
extension SHClimateViewController {
    
    /// 更新进度信息
    private func changeProgressStatus(commandButton: SHCommandButton, progressHoldView: UIView) {
        
        if hvacCommands.count == 0 {
      
            let foorName = selectCentralHVAC?.floorName ?? ""
            
            SVProgressHUD.showInfo(withStatus: "\(foorName) \(SHLanguageText.noData)")
            
            return
        }
        
        if currentSelectCommandButton == nil ||
           currentSelectCommandButton != commandButton {
            
            currentSelectCommandButton = commandButton
            commandButton.isSelected = true
            
            SHLoadProgressView.showIn(progressHoldView)
        }
        
        performSelector(inBackground: #selector(execute(commands:)), with: hvacCommands)
    }
    
    /// 执行指令
    @objc private func execute(commands: [SHCentralHVACCommand]) {
        
        for command in commands {
            
            let operatorCode: UInt16 = 0xE3D8
            
            let sendData:[UInt8] = [
               hvacMode,
               hvacValue
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
extension SHClimateViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let hvac = allHVACs[row]
        
        selectCentralHVAC = hvac
        
        hvacCommands = SHSQLiteManager.shared.getCentralClimateCommands(hvac)
        
        if allHVACs.count == 0 {
        
            let alertView = TYCustomAlertView(title: SHLanguageText.noData,
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
        
        let cell = SHCentralClimateCell.loadFromNib()
        
        cell.centralHVAC = allHVACs[row]
        
        return cell
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return SHCentralClimateCell.rowHeight
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return allHVACs.count
    }
}
