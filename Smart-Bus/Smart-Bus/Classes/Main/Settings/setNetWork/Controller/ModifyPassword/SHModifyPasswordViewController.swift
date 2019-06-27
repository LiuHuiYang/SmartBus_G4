//
//  SHModifyPasswordViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/25.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit
import SAMKeychain

class SHModifyPasswordViewController: SHViewController {
    
    /// 选择服务器的名称
    private var serverName = defaultRemoteServerDoMainName
    
    /// 用来拼接的可变字符串
    var elementString: String = ""
    
    /// 控件的基础高度
    @IBOutlet weak var labelAndTexeFieldHeightConstraint: NSLayoutConstraint!
    
    /// 用户名标签
    @IBOutlet weak var userNameLabel: UILabel!
    
    /// 旧密码标签
    @IBOutlet weak var oldPasswordLabel: UILabel!
    
    /// 新密码标签
    @IBOutlet weak var modifyNewPasswordLabel: UILabel!
    
    /// 用户名
    @IBOutlet weak var userNameTextField: UITextField!
    
    /// 旧密码
    @IBOutlet weak var oldPasswordTextField: UITextField!
    
    /// 新密码
    @IBOutlet weak var modifyNewPasswordTextField: UITextField!
    
    /// 修改按钮
    @IBOutlet weak var modifyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Modify Password"
        
        let name =
            SHLanguageTools.share()?.getTextFromPlist(
                "RECORD",
                withSubTitle: "USER_NAME"
            ) as! String
        
        userNameLabel.text = name
        
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
        
        userNameTextField.text = UserDefaults.standard.object(forKey: loginAccout) as? String
        
        oldPasswordTextField.text =
            SAMKeychain.password(forService: loginServices,
                                 account: loginAccout
        )
        
        userNameTextField.becomeFirstResponder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            userNameLabel.font = font
            oldPasswordLabel.font = font
            modifyNewPasswordLabel.font = font
            
            userNameTextField.font = font
            oldPasswordTextField.font = font
            modifyNewPasswordTextField.font = font
            
            modifyButton.titleLabel?.font = font
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SHNetWorkTools.shareInstacne()?.operationQueue.cancelAllOperations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            labelAndTexeFieldHeightConstraint.constant = navigationBarHeight
        }
    }

    /// 点击修改
    @IBAction func modifyButtonClick() {
        
        guard let userName = userNameTextField.text,
            let oldPassword = oldPasswordTextField.text,
            let modifPassword = modifyNewPasswordTextField.text else {
                
                let msg =
                    SHLanguageTools.share()?.getTextFromPlist(
                        "SETTINGS",
                        withSubTitle: "PROMPT_MESSAGE_1"
                    ) as! String
                
                SVProgressHUD.showError(withStatus: msg)
                
                return
        }
        
        let title =
            SHLanguageTools.share()?.getTextFromPlist(
                "SECURITY",
                withSubTitle: "PROMPT_MESSAGE_6"
            ) as! String
        
        let alertView = TYCustomAlertView(title: title,
                                          message: nil,
                                          isCustom: true
        )
        
        let cancelAction = TYAlertAction(title: SHLanguageText.cancel,
                                         style: .cancel,
                                         handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let sureAction = TYAlertAction(title: SHLanguageText.ok, style: .destructive) { (action) in
            
            self.loadModifyPassword(userName: userName,
                               oldPassword: oldPassword,
                               newPassword: modifPassword
            )
        }
        
        alertView?.add(sureAction)
        
        let alertController =
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .scaleFade
        )
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController!, animated: true, completion: nil)
    }
}


// MARK: - 网络请求与解析
extension SHModifyPasswordViewController: XMLParserDelegate {
    
    /// 请求数据
    func loadModifyPassword(userName: String, oldPassword: String, newPassword: String) {
        
        // 注意: 公司的服务器返回的是 XML 百度语音返回的是 Json
        SHNetWorkTools.shareInstacne()?.responseSerializer =
            AFXMLParserResponseSerializer()
        
        
        //    http://smartbuscloud.com:8888/DDNSServerService.asmx/GetDeviceList?userName=Jasminko&password=123456
        
        SVProgressHUD.show(withStatus: "Requesting data")
        
        let urlString = "http://\(serverName):8888/DDNSServerService.asmx/ModifyPassword"
        
        let param: [String: String] = [
            "userName": userName,
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        SHNetWorkTools.shareInstacne()?.request(
            .POST,
            urlstring: urlString,
            parameters: param,
            finished: { (res, error) in
            
            if error != nil {
                
                SVProgressHUD.showError(withStatus: "request was aborted")
                return
            }
            
            self.view.endEditing(true)
            
            let parser: XMLParser = res as! XMLParser
            parser.delegate = self
            parser.parse()
        })
    }
    
    /// 1 打开XML文档，准备开始解析
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    /// 2 发现一个元素的开始标签
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // 清空接下来使用的全局拼接字符串, 不是nil，也不是NULL
        elementString = ""
    }
    
    /// 3 发现了节点的内容,就是读取元素的内容
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        elementString += string
    }
    
    /// 4 发现了结束的节点, 就是发现了一个元素的结束标签
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    
    }
    
    
    /// 5 文档解析完成
    func parserDidEndDocument(_ parser: XMLParser) {
        
        if elementString.isEqual("true") {
            
            SVProgressHUD.showSuccess(withStatus: "Password modification succeeded")
            
            if let name = userNameTextField.text,
                let password = modifyNewPasswordTextField.text {
                
                UserDefaults.standard.set(
                    name,
                    forKey: loginAccout
                )
                
                UserDefaults.standard.synchronize()
                
                SAMKeychain.setPassword(
                    password,
                    forService: loginServices,
                    account: loginAccout
                )
            }
        
        } else {
        
            SVProgressHUD.showError(withStatus: "Password modification failed")
        }
    }
}

// MARK: - UITextFieldDelegate
extension SHModifyPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            
            userNameTextField.resignFirstResponder()
            oldPasswordTextField.becomeFirstResponder()
            
        } else if textField == oldPasswordTextField {
            
            oldPasswordTextField.resignFirstResponder()
            modifyNewPasswordTextField.becomeFirstResponder()
        } else {
            
            modifyNewPasswordTextField.resignFirstResponder()
            modifyButtonClick()
        }
        
        return true
    }
    
}

