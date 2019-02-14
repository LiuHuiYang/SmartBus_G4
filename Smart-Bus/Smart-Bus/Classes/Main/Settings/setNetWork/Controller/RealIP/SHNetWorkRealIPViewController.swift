//
//  SHNetWorkRealIPViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/15.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHNetWorkRealIPViewController: SHViewController {
    
    /// 高度约束
    @IBOutlet weak var switchViewHeightConstraint: NSLayoutConstraint!
    
    /// 设备IP的确定高度
    @IBOutlet weak var deviceIPViewHeightConstraint: NSLayoutConstraint!
    
    
    /// 头部显示的标题栏
    @IBOutlet weak var ipAddressSettingShowLabel: UILabel!
    
    /// 当前IP提示信息
    @IBOutlet weak var currentIPShowLabel: UILabel!
    
    
    /// 设置IP的开关
    @IBOutlet weak var realIPSwitch: UISwitch!
    
    /// 当前设备的网络IP
    @IBOutlet weak var currentDeviceIPLabel: UILabel!
    
    /// 右边保存发送数据IP地址
    @IBOutlet weak var rightSendDataRalIPLabel: UILabel!
    
    /// 左边提示发送信息的Label
    @IBOutlet weak var leftSendDataRalIPLabel: UILabel!
    
    /// 地址输入框
    @IBOutlet weak var ipAddressTextField: UITextField!
    
    /// 显示真实的IP界面
    @IBOutlet weak var realIPView: UIView!
    
    @IBAction func realIPSwitchClick() {
        
        realIPView.isHidden = !realIPSwitch.isOn
        
        let ipAddress = UserDefaults.standard.object(forKey: socketRealIP) as? String
        
        if realIPSwitch.isOn {
            
            rightSendDataRalIPLabel.text = ipAddress
            leftSendDataRalIPLabel.isHidden = (ipAddress == nil)
       
        } else {
            
            rightSendDataRalIPLabel.text = ""
            
            if self.ipAddressTextField.isFirstResponder {
                
                ipAddressTextField.resignFirstResponder()
            }
        }
        
        // 保存IP
        if let realIP = rightSendDataRalIPLabel.text {
            
            UserDefaults.standard.set(realIP, forKey: socketRealIP)
            UserDefaults.standard.synchronize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let title =
            SHLanguageTools.share()?.getTextFromPlist(
                "SETTINGS",
                withSubTitle: "NETWORK_SETTINGS"
        ) as! String
        
        navigationItem.title = title
        
       
        let realIP =  UserDefaults.standard.object(forKey: socketRealIP) as? String
       
        realIPSwitch.setOn(realIP?.isEmpty == false,
                           animated: false
        )
        
        getCurrentDeviceIPAddress()
        
        realIPSwitchClick()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            ipAddressSettingShowLabel.font = font
            currentIPShowLabel.font = font
            currentDeviceIPLabel.font = font
            ipAddressTextField.font = font
            leftSendDataRalIPLabel.font = font
            rightSendDataRalIPLabel.font = font
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            switchViewHeightConstraint.constant = navigationBarHeight
            deviceIPViewHeightConstraint.constant = navigationBarHeight
        }
    }
    
    /// 获得IP
    func getCurrentDeviceIPAddress() {
        
        let localWifi = SHSocketTools.localControlWifi()
        
        if localWifi.isEmpty {
            return
        }
     
        currentIPShowLabel.text = localWifi
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            
            let ipAddress = UIDevice.getIPAddress(true)
            
            if !((ipAddress?.isEqual(self.currentDeviceIPLabel.text))!) {
                
                self.currentIPShowLabel.text = ipAddress
            }
        }
    }
    
    deinit {
        AFNetworkReachabilityManager.shared().stopMonitoring()
    }
}


// MARK: - UITextFieldDelegate
extension SHNetWorkRealIPViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == ipAddressTextField {
            
            // 1.直接判断是不是一个有效的IP
            if UIDevice.isValidatIP(textField.text) {
                
                // 1.1 如果是直接显示
                rightSendDataRalIPLabel.text = textField.text
            
            } else { // 1.2 可能是其它内容 + 不合法的IP
            
                // 域名是否有效
                if UIDevice.isIllegalDomainNameOrIPAddress(textField.text) {
                    
                    SVProgressHUD.showError(
                        withStatus: "Illegal IP address or domain name"
                    )
                    
                    return false
                }
                
                // 当成域名进行解析
                let ipAddress = UIDevice.getIPAddress(byHostName: textField.text)
                
                rightSendDataRalIPLabel.text = ipAddress
            }
            
            leftSendDataRalIPLabel.isHidden =
                (rightSendDataRalIPLabel.text == nil)
            
            SVProgressHUD.showSuccess(withStatus: "Success")
            
            UserDefaults.standard.set(rightSendDataRalIPLabel.text,
                                      forKey: socketRealIP
            )
            
            UserDefaults.standard.synchronize()
            
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}
