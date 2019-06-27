//
//  SHAuthorizationViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/10.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 允许修改区域设备是否允许的key
private let authorChangeDeviceisAllow: String = "SHAuthorChangeDeviceisAllow"

/// 启与关闭修改设备配置的密码的key
private let authorChangeDevicePasswordKey: String = "SHAuthorChangeDevicePasswordKey"

class SHAuthorizationViewController: SHViewController {
    
    /// 显示文字
    @IBOutlet weak var noteLabel: UILabel!
    
    /// 开启开关
    @IBOutlet weak var turnOnSwitch: UISwitch!
    
    // ========= 密码区域  ========
    
    /// 旧密码标签
    @IBOutlet weak var oldPasswordLabel: UILabel!
    
    /// 新密码标签
    @IBOutlet weak var modifyNewPasswordLabel: UILabel!
    
    /// 旧密码
    @IBOutlet weak var oldPasswordTextField: UITextField!
    
    /// 新密码
    @IBOutlet weak var modifyNewPasswordTextField: UITextField!
    
    /// 修改按钮
    @IBOutlet weak var modifyButton: UIButton!
    
    /// 默认密码提示
    @IBOutlet weak var defaultPasswordLabel: UILabel!
    
    
    /// 重设置密码标题
    @IBOutlet weak var passwordLabel: UILabel!
    
    /// 重设密码开关
    @IBOutlet weak var passwordSwitch: UISwitch!
    
    /// 密码编辑框
    @IBOutlet weak var passwordView: UIView!
    
    /// 分组视图高度
    @IBOutlet weak var groupViewHeightConstraint: NSLayoutConstraint!
    
    /// 密码控件中的子控件基准高度
    @IBOutlet weak var passwordViewSubViewHeightConstraint: NSLayoutConstraint!
    
    /// 密码输出显示框
    fileprivate var valueTextField: UITextField?
    
    /// 确定修改密码
    @IBAction func modifyButtonClick() {
        
        // 判断是否有值为空
        guard let _ = oldPasswordTextField.text,
            let _ = modifyNewPasswordTextField.text
        else {
            
            let errorMsg =
                (SHLanguageTools.share()?.getTextFromPlist(
                    "SETTINGS",
                    withSubTitle: "PROMPT_MESSAGE_1")
                ) as! String
            
            SVProgressHUD.showError(withStatus: errorMsg)
            
            return
        }
        
        // 判断旧密码是否正确
        
        let savePassword = UserDefaults.standard.object(forKey: authorChangeDevicePasswordKey) as! String
        
        if !savePassword.isEqual(oldPasswordTextField.text) {
            
            let errorMsg = (SHLanguageTools.share()?.getTextFromPlist(
                    "SECURITY",
                    withSubTitle: "PROMPT_MESSAGE_4")
            ) as! String
            
            SVProgressHUD.showError(withStatus: errorMsg)
            
            return
        }
        
        // 确定是否修改
        
        let title = (SHLanguageTools.share()?.getTextFromPlist(
                "SECURITY",
                withSubTitle: "PROMPT_MESSAGE_6")
            ) as! String
        
        let alertView = TYCustomAlertView(title: title,
                                          message: nil,
                                          isCustom: true
        )
      
        
        let cancelAction = TYAlertAction(title: SHLanguageText.no, style: .cancel, handler: nil)
        
        let sureAction = TYAlertAction(title: SHLanguageText.yes, style: .destructive) { (action) in
            
            let password = self.modifyNewPasswordTextField.text
            
            UserDefaults.standard.set(password,
                                      forKey: authorChangeDevicePasswordKey)
            
            UserDefaults.standard.synchronize()
            
            SVProgressHUD.showSuccess(withStatus: "Password modification succeeded")
            
        }
        
        alertView?.add(cancelAction)
        alertView?.add(sureAction)
        
        let alertContrller: TYAlertController =
            TYAlertController(alert: alertView!,
                              preferredStyle: .alert,
                              transitionAnimation: .scaleFade
        )
        
        alertContrller.backgoundTapDismissEnable = true
        
        present(alertContrller, animated: true, completion: nil)
    }
    
    /// 重设置密码点击
    @IBAction func passwordSwitchClick() {
        passwordView.isHidden = !passwordSwitch.isOn;
    }
    
    /// statusButtonClick
    @IBAction func statusButtonClick() {
        
        let targetStatus = !turnOnSwitch.isOn
        
        let title = (SHLanguageTools.share()?.getTextFromPlist(
            "SECURITY",
            withSubTitle: "TYPE_PASSWORD")
            ) as! String
        
        let alertView =
            TYCustomAlertView(title: title,
                              message: nil,
                              isCustom: true
        )
        
        alertView?.addTextField(configurationHandler: { (textField) -> Void in
            
            textField?.becomeFirstResponder()
            textField?.clearButtonMode = .whileEditing
            textField?.textAlignment = .center
            textField?.isSecureTextEntry = true
            
            self.valueTextField = textField
        })
        
        let cancelAction =
            TYAlertAction(title: SHLanguageText.cancel,
                          style: .cancel,
                          handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let saveAction =
            TYAlertAction(title: SHLanguageText.ok, style: .destructive) { (action) in
                
             let savePassword = UserDefaults.standard.object(forKey: authorChangeDevicePasswordKey) as! String
                                        
            let res = self.valueTextField?.text ?? ""
                                        
                                        if res.isEqual("root") ||
                                            res.isEqual(savePassword){
                                            
                                            self.turnOnSwitch.setOn(targetStatus, animated: true)
                                            
                                            UserDefaults.standard.set(targetStatus, forKey: authorChangeDeviceisAllow)
                                            
                                            UserDefaults.standard.synchronize()
                                            
                                            
                                        } else {
                                           
                                            let errorMsg = SHLanguageTools.share()?.getTextFromPlist("SECURITY", withSubTitle: "PROMPT_MESSAGE_4") as! String
                                            SVProgressHUD.showError(withStatus: errorMsg)
                                        }
                
        }
        
        alertView?.add(saveAction)
        
        let alertController: TYAlertController =
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .scaleFade
        )
        
        if UIDevice.is4_0inch() || UIDevice.is3_5inch() {
            
            alertController.alertViewOriginY =
                navigationBarHeight + statusBarHeight
        }
        
        present(alertController,
                animated: true,
                completion: nil
        )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Modify Permissions"
        
        // 设置默认值
        let defaultPassword = UserDefaults.standard.object(forKey: authorChangeDevicePasswordKey) as? String ?? ""
        
        if defaultPassword.isEmpty {
            
            UserDefaults.standard.set("8888", forKey: authorChangeDevicePasswordKey)
        }
        
        turnOnSwitch.setOn(UserDefaults.standard.bool(forKey: authorChangeDeviceisAllow), animated: false)
        
        // 密码编辑框默认关闭
        passwordSwitch.setOn(false, animated: false)
        
        oldPasswordLabel.text = (SHLanguageTools.share()?.getTextFromPlist("SECURITY", withSubTitle: "OLD_PASSWORD") as! String)
        
        modifyNewPasswordLabel.text = (SHLanguageTools.share()?.getTextFromPlist("SECURITY", withSubTitle: "NEW_PASSWORD") as! String)
        
        modifyButton.setTitle(
            SHLanguageText.ok,
            for: .normal
        )
        
        modifyButton.setRoundedRectangleBorder()
        
        let showTitle = SHLanguageTools.share()?.getTextFromPlist("SECURITY", withSubTitle: "PROMPT_MESSAGE_3_0") as! String
        
        defaultPasswordLabel.text = "\(showTitle) 8888"
        
        passwordSwitchClick()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            noteLabel.font = font
            passwordLabel.font = font
            oldPasswordLabel.font = font
            modifyNewPasswordLabel.font = font
            defaultPasswordLabel.font = font
            modifyButton.titleLabel?.font = font
            oldPasswordTextField.font = font
            modifyNewPasswordTextField.font = font
            
            
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            groupViewHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
            
            passwordViewSubViewHeightConstraint.constant = navigationBarHeight
            
        }
    }
  

}


extension SHAuthorizationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == oldPasswordTextField {
            
            oldPasswordTextField.resignFirstResponder()
            modifyNewPasswordTextField.becomeFirstResponder()
        
        } else {
            
            view.endEditing(true)
            modifyButtonClick()
        }
        
        return true
    }
}


// MARK: - 能否操作
extension SHAuthorizationViewController {
    
    @objc class func isOperatorDisable() -> Bool {
        
        let isAouthChange = UserDefaults.standard.bool(forKey: authorChangeDeviceisAllow)
        
        if isAouthChange {
            
            return false
        }
        
        SVProgressHUD.showError(withStatus: "Sorry, you have no operation permissions！")
    
        return true
    }
}
