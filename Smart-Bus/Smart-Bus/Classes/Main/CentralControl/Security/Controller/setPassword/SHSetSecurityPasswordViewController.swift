//
//  SHSetSecurityPasswordViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/26.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHSetSecurityPasswordViewController: SHViewController {
    
    
    /// 基准高度约束
    @IBOutlet weak var baseViewHeightConstraint: NSLayoutConstraint!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        let title =
            SHLanguageTools.share()?.getTextFromPlist(
                "SETTINGS",
                withSubTitle: "PASSWORD"
            ) as! String
        
        navigationItem.title = title
        
        let oldPassword =
            SHLanguageTools.share()?.getTextFromPlist(
                "SECURITY",
                withSubTitle: "OLD_PASSWORD"
            ) as! String
        
        oldPasswordLabel.text = oldPassword
        
        let newPassword =
            SHLanguageTools.share()?.getTextFromPlist(
                "SECURITY",
                withSubTitle: "NEW_PASSWORD"
            ) as! String
        
        modifyNewPasswordLabel.text = newPassword
    
        modifyButton.setTitle(SHLanguageText.ok, for: .normal)
        
        modifyButton.setRoundedRectangleBorder()
        
        let defaultTest =
            SHLanguageTools.share()?.getTextFromPlist(
                "SECURITY",
                withSubTitle: "PROMPT_MESSAGE_3_0"
            ) as! String
        
        defaultPasswordLabel.text = defaultTest
        
        let savePassword =
            UserDefaults.standard.object(
                forKey: securityPasswordKey
        ) as? String ?? ""
        
        oldPasswordTextField.text = savePassword
        
        oldPasswordTextField.becomeFirstResponder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            oldPasswordLabel.font = font
            oldPasswordTextField.font = font
            modifyNewPasswordLabel.font = font
            modifyNewPasswordTextField.font = font
            modifyButton.titleLabel?.font = font
            defaultPasswordLabel.font = font
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            baseViewHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
        }
        
    }
    
    /// 修改密码
    @IBAction func modifyButtonClick() {
        
        // 判断是否有值
        let isNullMsg =
            SHLanguageTools.share()?.getTextFromPlist(
                "SETTINGS",
                withSubTitle: "PROMPT_MESSAGE_1"
            ) as! String
        
        guard let old = oldPasswordTextField.text,
            let new = modifyNewPasswordTextField.text else {
                
            SVProgressHUD.showError(withStatus: isNullMsg)
            return
        }
        
        if old.isEmpty || new.isEmpty {
             SVProgressHUD.showError(withStatus: isNullMsg)
            return
        }
        
        // 确认是否修改
        
        let changeString =
            SHLanguageTools.share()?.getTextFromPlist(
                "SECURITY",
                withSubTitle: "PROMPT_MESSAGE_6"
            ) as! String
        
        let alertView = TYCustomAlertView(title: changeString,
                                          message: nil,
                                          isCustom: true
        )
        
        let cancelAction = TYAlertAction(title: SHLanguageText.no,
                                         style: .cancel,
                                         handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let sureAction = TYAlertAction(title: SHLanguageText.yes, style: .destructive) { (action) in
            
            self.view.endEditing(true)
            
            UserDefaults.standard.set(new,
                                      forKey: securityPasswordKey
            )
            
            UserDefaults.standard.synchronize()
            
            SVProgressHUD.showSuccess(
                withStatus: "Password modification succeeded"
            )
        }
        
        alertView?.add(sureAction)
        
        let alertController =
            TYAlertController(alert: alertView!,
                              preferredStyle: .alert,
                              transitionAnimation: .dropDown
        )
        
        UIApplication.shared.keyWindow?.rootViewController?.present(
            alertController!,
            animated: true,
            completion: nil
        )
    }
}


// MARK: - UITextFieldDelegate
extension SHSetSecurityPasswordViewController: UITextFieldDelegate {
    
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

