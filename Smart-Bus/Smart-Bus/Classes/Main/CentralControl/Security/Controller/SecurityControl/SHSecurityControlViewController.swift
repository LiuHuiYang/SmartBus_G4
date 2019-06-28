//
//  SHSecurityControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017年 Mark Liu. All rights reserved..
//

import UIKit

class SHSecurityControlViewController: SHViewController {
    
    /// 选择安防的区域
    var securityZone: SHSecurityZone?
    
    // MARK: - 中间过渡参数
    
    /// 当前选择的命令按钮
    var currentSelectCommandButton: SHCommandButton?

    /// 安防密码
    var securityPassword = ""

    /// 输入密码框
    var inputPasswordTextField: UITextField?

    /// 已经授权的操作
    var isAlreadyAuthorizedOperation = false
    
    
    // MARK: - 安防设置参数的几个参数
    
    /// 其它安防操作的基准高度
    @IBOutlet weak var securityOtherOperatorViewBaseHeightConstraint: NSLayoutConstraint!
    
    /// 安防控制的其它操作视图
    @IBOutlet weak var securityOtherOperatorView: UIView!
    
    /// 关闭其它操作视图
    @IBOutlet weak var closeLabel: UILabel!
    
    /// 密码
    @IBOutlet weak var passwordLabel: UILabel!
    
    /// 日志
    @IBOutlet weak var securityLogLabel: UILabel!
    
    /// 看门狗状态
    @IBOutlet weak var watchDogLabel: UILabel!
    
    /// 扫描状态
    @IBOutlet weak var scanStatusLabel: UILabel!
    
    /// 看门狗开关
    @IBOutlet weak var watchDogSwitch: UISwitch!
    
    /// 扫描状态开关
    @IBOutlet weak var scanStatusSwitch: UISwitch!

    
    // MARK: - 安防控制
    
    /// 离开
    @IBOutlet weak var awayButton: SHCommandButton!
    
    /// 离开的指示占位视图
    @IBOutlet weak var awayHolderView: UIView!
    
    /// 夜晚
    @IBOutlet weak var nightButton: SHCommandButton!
    
    /// 夜晚的指示占位视图
    @IBOutlet weak var nightHolderView: UIView!
    
    /// 访客
    @IBOutlet weak var guestButton: SHCommandButton!
    
    /// 访客的指示占位视图
    @IBOutlet weak var guestHolderView: UIView!
    
    /// 白天
    @IBOutlet weak var dayButton: SHCommandButton!
    
    /// 白天的指示占位视图
    @IBOutlet weak var dayHolderView: UIView!
    
    /// 度假
    @IBOutlet weak var vacationButton: SHCommandButton!
    
    /// 度假的指示占位视图
    @IBOutlet weak var vacationHolderView: UIView!
    
    /// 解除
    @IBOutlet weak var disarmButton: SHCommandButton!
    
    /// 解除的指示占位视图
    @IBOutlet weak var disarmHolderView: UIView!
    
    /// 报警
    @IBOutlet weak var panicButton: SHCommandButton!
    
    /// 报警的指示占位视图
    @IBOutlet weak var panicHolderView: UIView!
    
    /// 急救
    @IBOutlet weak var ambulanceButton: SHCommandButton!
    
    /// 急救的指示占位视图
    @IBOutlet weak var ambulanceHolderView: UIView!
    
    /// 模式控制按钮高度
    @IBOutlet weak var controlButtonHeightConstraint: NSLayoutConstraint!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - 安防的数据解析
extension SHSecurityControlViewController {
    
    /// 解析广播数据
    override func analyzeReceivedSocketData(_ socketData: SHSocketData!) {
        
        guard let zone = securityZone else {
            return
        }
        
        if zone.subnetID != socketData.subNetID ||
           zone.deviceID != socketData.deviceID {
           
            return
        }
        
        var showStauts = ""
        
        switch socketData.operatorCode {
            
        // 普通安防
        case 0x0105:
            
            if socketData.additionalData[0] != zone.zoneID {
                return
            }
            
            switch UInt(socketData.additionalData[1]) {
                
            case SHSecurityType.vacation.rawValue:
                showStauts = SHLanguageText.securityVacation
                
            case SHSecurityType.away.rawValue:
                showStauts = SHLanguageText.securityAway
                
            case SHSecurityType.night.rawValue:
                showStauts = SHLanguageText.securityNight
                
            case SHSecurityType.nightGeust.rawValue:
                showStauts = SHLanguageText.securityNightGeust
                
            case SHSecurityType.disarm.rawValue:
                showStauts = SHLanguageText.securityDisarm
                
            case SHSecurityType.day.rawValue:
                showStauts = SHLanguageText.securityDay
                
            default:
                break
            }
            
            // 紧急安防
        case 0x010D:
            
            if socketData.additionalData[0] != zone.zoneID ||
               socketData.additionalData[4] != zone.zoneID {
               
                return
            }
            
            if socketData.additionalData[1] == 0x08 {
                
                showStauts = SHLanguageText.securityAmbulance

            } else if socketData.additionalData[1] == 0x04 {
                
                showStauts = SHLanguageText.securityPanic
            }
 
            // 看门狗状态
        case 0x0133 :
            
            if socketData.additionalData[0] == 0xF8 &&
               socketData.additionalData[1] == zone.zoneID {
               
                watchDogSwitch.isOn =
                    (socketData.additionalData[3] == 0)
            }
            
        case 0x0135 :
            if socketData.additionalData[0] == 0xF8 &&
                socketData.additionalData[1] == zone.zoneID {
                
                watchDogSwitch.isOn = !watchDogSwitch.isOn
            }
            
        case 0x012F:
            if socketData.additionalData[0] == 0xF8 &&
               socketData.additionalData[1] == zone.zoneID &&
               socketData.additionalData[2] == 0 {
                
                scanStatusSwitch.isOn =
                    (socketData.additionalData[3] != 0)
            }
            
        case 0x0131 :
            if socketData.additionalData[1] == zone.zoneID &&
               socketData.additionalData[2] == 0 {
                
                scanStatusSwitch.isOn = !scanStatusSwitch.isOn
            }
            
        default:
            break
        }
        
        if !showStauts.isEmpty {
            
            SVProgressHUD.showSuccess(withStatus: showStauts)
        }
    }
}


// MARK: - 安防控制的点击事件
extension SHSecurityControlViewController {
    
    /// 点击离开
    @IBAction func awayButtonClick() {
        
        getOperationAuthorization {
        
            self.changeProgressStatus(
                self.awayButton,
                progressHoldView: self.awayHolderView
            )
        }
    }
    
    /// 点击晚上
    @IBAction func nightButtonClick() {
        
        getOperationAuthorization {
            
            self.changeProgressStatus(
                self.nightButton,
                progressHoldView: self.nightHolderView
            )
        }
    }
    
    /// 点击访客
    @IBAction func guestButtonClick() {
        
        getOperationAuthorization {
            
            self.changeProgressStatus(
                self.guestButton,
                progressHoldView: self.guestHolderView
            )
        }
    }
    
    /// 点击白天
    @IBAction func dayButtonClick() {
        
        getOperationAuthorization {
            
            self.changeProgressStatus(
                self.dayButton,
                progressHoldView: self.dayHolderView
            )
        }
    }
    
    /// 点击度假
    @IBAction func vacationButtonClick() {
        
        getOperationAuthorization {
            
            self.changeProgressStatus(
                self.vacationButton,
                progressHoldView: self.vacationHolderView
            )
        }
    }
    
    /// 点击解除
    @IBAction func disarmButtonClick() {
        
        getOperationAuthorization {
            
            self.changeProgressStatus(
                self.disarmButton,
                progressHoldView: self.disarmHolderView
            )
        }
    }
    
    /// 报警触发
    @IBAction func panicPress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state != .began ||
           sender.view != self.panicButton {
            return
        }
        
        changeProgressStatus(
            panicButton,
            progressHoldView: panicHolderView
        )
    }

    /// 急救触发
    @IBAction func ambulancePress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state != .began ||
            sender.view != self.ambulanceButton {
            return
        }
        
        changeProgressStatus(
            ambulanceButton,
            progressHoldView: ambulanceHolderView
        )
    }
}


// MARK: - 执行安防
extension SHSecurityControlViewController {
    
    /// 执行安防
    private func  changeProgressStatus(_ commandButton: SHCommandButton, progressHoldView: UIView) {
        
        //执行动画
        if currentSelectCommandButton != commandButton &&
         !(currentSelectCommandButton?.isSelected ?? false) {
            
            currentSelectCommandButton = commandButton
            commandButton.isSelected = true
        
            SHLoadProgressView.showIn(progressHoldView)
        }
        
        // 送对应的指令
        
        guard let zone = securityZone else {
            return
        }
        
        let zoneID = UInt8(zone.zoneID)
        
        // 急救
        if commandButton.securityType == .ambulance {
            
            // 抓包数据 : 01 0A 【01 08 00 00 01】 9A 25
            SHSocketTools.sendData(
                operatorCode: 0x010C,
                subNetID: zone.subnetID,
                deviceID: zone.deviceID,
                additionalData: [zoneID, 8,  0, 0, zoneID]
            )
        
        // 报警
        } else if commandButton.securityType == .panic {
            
            SHSocketTools.sendData(
                operatorCode: 0x010C,
                subNetID: zone.subnetID,
                deviceID: zone.deviceID,
                additionalData: [zoneID, 4,  0, 0, zoneID]
            )
        
        // 普通安防
        } else {
        
            SHSocketTools.sendData(
                operatorCode: 0x0104,
                subNetID: zone.subnetID,
                deviceID: zone.deviceID,
                additionalData:
                    [zoneID,
                     UInt8(commandButton.securityType.rawValue)
                ]
            )
        }

    }

    
    /// 获得权限执行 (六种模式 其它两种不需要)
    private func getOperationAuthorization(_ task: @escaping () -> Void) {

        if isAlreadyAuthorizedOperation {
            
            task()
            return
        }
        
        // 第一次进入，没有输入正确密码
        let alertView = TYCustomAlertView(
            title: nil,
            message: nil,
            isCustom: true
        )
        
        alertView?.addTextField(configurationHandler: { (textField) in
            
            textField?.becomeFirstResponder()
            textField?.textAlignment = .center
            textField?.isSecureTextEntry = true
            textField?.clearButtonMode = .whileEditing
            textField?.placeholder =
                (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "TYPE_PASSWORD"
                ) as? String) ?? "password"
            
            self.inputPasswordTextField = textField
        })
        
        let cancelAction =
            TYAlertAction(title: SHLanguageText.cancel,
                          style: .cancel,
                          handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let saveAction =
            TYAlertAction(title: SHLanguageText.ok,
                          style: .destructive) { (action) in
            
            guard let savePassword =
                UserDefaults.standard.object(
                    forKey: securityPasswordKey
                ) as? String,
                            
            let inputPassword =
                self.inputPasswordTextField?.text else {
                    
                    return
            }
                            
            if savePassword == inputPassword ||
               inputPassword == "root" {
                
                task()
            
                self.isAlreadyAuthorizedOperation = true
            
            } else {
                                
                self.isAlreadyAuthorizedOperation = false
                
                let text = SHLanguageTools.share()?.getTextFromPlist(
                        "SECURITY",
                        withSubTitle: "PROMPT_MESSAGE_4"
                ) as! String
                
                    SVProgressHUD.showError(withStatus: text)
            }
        }
        
        alertView?.add(saveAction)
        
        let alertController =
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .dropDown
        )
      
        alertController?.alertViewOriginY =
            navigationBarHeight +
            (UIDevice.is_iPhoneX_More() ?
                defaultHeight :
                statusBarHeight
            )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!,
                animated: true,
                completion: nil
        )
    }
}


// MARK: - 其它安防的控制事件
extension SHSecurityControlViewController {
    
    /// 查看日志点击
    @IBAction func securityPasswordClick(_ sender: UITapGestureRecognizer) {
    
        let setPasswordController =
            SHSetSecurityPasswordViewController()
        
        navigationController?.pushViewController(
            setPasswordController,
            animated: true
        )
    }
    /// 查看日志点击
    @IBAction func securityLogClick(_ sender: UITapGestureRecognizer) {
        
        let readLogController =
            SHReadSecurityLogViewController()
        
        readLogController.securityZone = securityZone
        
        navigationController?.pushViewController(
            readLogController,
            animated: true
        )
    }

    /// 扫描状态
    @IBAction func scanStatusClick() {
        
        guard let zone = securityZone else {
            return
        }
        
        let status = [
            UInt8(zone.zoneID),
            0,
            scanStatusSwitch.isOn ? 1 : 0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0130,
            subNetID: zone.subnetID,
            deviceID: zone.deviceID,
            additionalData: status
        )
    }
    
    /// 看门狗状态
    @IBAction func watchDogClick() {
        
        guard let zone = securityZone else {
            return
        }
        
        let status = [
            UInt8(zone.zoneID),
            0,
            2,
            scanStatusSwitch.isOn ? 0 : 1,
            0,
            0,
            0,
            0
        ]
        
        SHSocketTools.sendData(
            operatorCode: 0x0134,
            subNetID: zone.subnetID,
            deviceID: zone.deviceID,
            additionalData: status
        )
    }
    
    /// 关闭其它安防操作视图
    @IBAction func closeSecurityOtherOperatorView(_ sender: Any) {
        
        securityOtherOperatorView.isHidden = true
    }

}

// MARK: - 设置点击
extension SHSecurityControlViewController {
    
    /// 点击设置
    @objc private func setSecurity() {
        
        securityOtherOperatorView.isHidden = false
        
        guard let zone = securityZone else {
            return
        }
        
        // 读看门狗的状态
        SHSocketTools.sendData(
            operatorCode: 0x0132,
            subNetID: zone.subnetID,
            deviceID: zone.deviceID,
            additionalData: [UInt8(zone.zoneID)]
        )
        
        // 扫描状态
        SHSocketTools.sendData(
            operatorCode: 0x012E,
            subNetID: zone.subnetID,
            deviceID: zone.deviceID,
            additionalData: [
                UInt8(zone.zoneID),
                0
            ]
        )
    }
}

// MARK: - UI实始化
extension SHSecurityControlViewController {
    
    /// 动画完成
    @objc func commandButtonChangeStatus() {
        
        currentSelectCommandButton?.isSelected = false
        currentSelectCommandButton = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置初始密码
        if UserDefaults.standard.object(
            forKey: securityPasswordKey
        ) == nil {
            
            UserDefaults.standard.set(
                "8888",
                forKey: securityPasswordKey
            )
            
            UserDefaults.standard.synchronize()
        }
        
        // 设置导航
        navigationItem.title = securityZone?.zoneNameOfSecurity
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "setting",
                hightlightedImageName: "setting",
                addTarget: self,
                action: #selector(setSecurity),
                isLeft: false
        )
        
        // 设置按钮文字与图片
        awayButton.setTitle(SHLanguageText.securityAway,
                            for: .normal
        )
        
        nightButton.setTitle(SHLanguageText.securityNight,
                            for: .normal
        )
        
        guestButton.setTitle(SHLanguageText.securityNightGeust,
                            for: .normal
        )
        
        vacationButton.setTitle(
            SHLanguageText.securityVacation,
            for: .normal
        )
        
        disarmButton.setTitle(SHLanguageText.securityDisarm,
                            for: .normal
        )
        
        dayButton.setTitle(SHLanguageText.securityDay,
                            for: .normal
        )
        
        panicButton.setTitle(SHLanguageText.securityPanic,
                            for: .normal
        )
        
        ambulanceButton.setTitle(
            SHLanguageText.securityAmbulance,
            for: .normal
        )
        
        closeLabel.text = SHLanguageText.shadeClose
        
        // 设置按钮的初始化状态
        awayButton.securityType = .away
        nightButton.securityType = .night
        dayButton.securityType = .day
        guestButton.securityType = .nightGeust
        vacationButton.securityType = .vacation
        disarmButton.securityType = .disarm
        panicButton.securityType = .panic
        ambulanceButton.securityType = .ambulance

        
        // 设置按钮圆角
        awayButton.setRoundedRectangleBorder()
        nightButton.setRoundedRectangleBorder()
        guestButton.setRoundedRectangleBorder()
        dayButton.setRoundedRectangleBorder()
        vacationButton.setRoundedRectangleBorder()
        disarmButton.setRoundedRectangleBorder()
        panicButton.setRoundedRectangleBorder()
        ambulanceButton.setRoundedRectangleBorder()
        
        // 增加通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(commandButtonChangeStatus),
            name: NSNotification.Name(rawValue: commandExecutionComplete),
            object: nil
        )
        
        securityOtherOperatorView.isHidden = true
        scanStatusSwitch.isOn = false
        watchDogSwitch.isOn = false

        
        // 适配字体
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            passwordLabel.font = font
            securityLogLabel.font = font
            scanStatusLabel.font = font
            watchDogLabel.font = font
            closeLabel.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if UIDevice.is3_5inch() {

          securityOtherOperatorViewBaseHeightConstraint.constant = defaultHeight
       
        } else if UIDevice.is4_0inch() {

            controlButtonHeightConstraint.constant =
                navigationBarHeight
          securityOtherOperatorViewBaseHeightConstraint.constant =
            tabBarHeight
        } else if UIDevice.is_iPad() {

            controlButtonHeightConstraint.constant =
                isPortrait ?
                (navigationBarHeight + navigationBarHeight + statusBarHeight) :
                (navigationBarHeight + tabBarHeight)

            securityOtherOperatorViewBaseHeightConstraint.constant =
                isPortrait ?
                    (navigationBarHeight + tabBarHeight) :
                (navigationBarHeight + statusBarHeight)
        }
    }

}
