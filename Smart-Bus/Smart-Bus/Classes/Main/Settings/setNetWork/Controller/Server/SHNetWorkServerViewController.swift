//
//  SHNetWorkServerViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/25.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit
import SAMKeychain


class SHNetWorkServerViewController: SHViewController {
    
    /// 选择的设备列表
    private var selectedRSIP: SHDeviceList?
    
    /// 选择服务器的名称
    private var serverName: String = defaultRemoteServerDoMainName
    
    /// 服务器域名输入框
    private var serverTextField: UITextField?
    
    // MARK: - 解析 XML 用的属性
    
    /// 所有的设备列表
    var deviceLists: [SHDeviceList]?
    
    /// 当前的设备序列
    var currentDeviceList: SHDeviceList?
    
    /// 当前选中的行
    var currentRow: Int = 0
    
    /// 用来拼接的可变字符串
    var elementString: String = ""
    
    // MARK: - 约束条件
    
    /// 标题高度
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    /// 登录的高度
    @IBOutlet weak var loginViewHeightConstraint: NSLayoutConstraint!
    
    /// 名称的约束
    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabelWidthConstraint: NSLayoutConstraint!
    
    /// 操作按钮的高度
    @IBOutlet weak var buttonsViewHeightConstraint: NSLayoutConstraint!
    
    /// 登录按钮的高度
    @IBOutlet weak var loginButtonHeightConstraint: NSLayoutConstraint!
    
   @IBOutlet weak var setWifiViewHeightConstraint: NSLayoutConstraint!
    
    /// 显示当前LAN的宽度
    @IBOutlet weak var currentLANShowLabelWidthConstraint: NSLayoutConstraint!
    
    /// server标题
    @IBOutlet weak var serverLabel: UILabel!
    
    /// 不启用网络功能
    @IBOutlet weak var locallabel: UILabel!
    
    /// 开关
    @IBOutlet weak var isLocalOrNetSwitch: UISwitch!
    
    /// 网络占位视图
    @IBOutlet weak var netView: UIView!
    
    // 用户名和密码
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    /// 5个按钮 -- 为了拉伸图片
    
    /// 登录
    @IBOutlet weak var loginButton: UIButton!
    
    /// 退出
    @IBOutlet weak var logoutButton: UIButton!
    
    /// 更新
    @IBOutlet weak var advancedButton: UIButton!
    
    /// 记住wifi
    @IBOutlet weak var rememberWifiButton: UIButton!
    
    /// 选择远程ip
    @IBOutlet weak var selectIPButton: UIButton!
    
    /// 输入的用户名称
    @IBOutlet weak var userNameTextField: UITextField!
    
    /// 输入的密码
    @IBOutlet weak var passwordTextField: UITextField!
    
    /// 选择RSIP的Label
    @IBOutlet weak var selectRSIPLabel: UILabel!
    
    /// 当前记录的LAN提示文字
    @IBOutlet weak var rememberLANShowLabel: UILabel!
    
    /// 当前网络的提示文字
    @IBOutlet weak var currentLANLabel: UILabel!
    
    /// 最下面的描述文字
    @IBOutlet weak var notesLabel: UILabel!
    
    /// 记住的wifi
    @IBOutlet weak var savedWifiNameLabel: UILabel!
    
    /// 当前的wifi名称
    @IBOutlet weak var wifiNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let title =
            SHLanguageTools.share()?.getTextFromPlist(
                "SETTINGS",
                withSubTitle: "NETWORK_SETTINGS"
            ) as! String
        
        navigationItem.title = title
        
        locallabel.text =
            "Direct Fast Link Mode: \nThis App will operate only in Local Area environmet."
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "setting",
                hightlightedImageName: "setting",
                addTarget: self,
                action: #selector(changeServerDomainName),
                isLeft: false
        )
        
        
        isLocalOrNetSwitch .setOn(
            UserDefaults.standard.bool(forKey: remoteControlKey),
            animated: false
        )
        
        let name =
            SHLanguageTools.share()?.getTextFromPlist(
                "SETTINGS",
                withSubTitle: "USER_NAME"
            ) as! String
        
        let password =
            SHLanguageTools.share()?.getTextFromPlist(
                "SETTINGS",
                withSubTitle: "PASSWORD"
            ) as! String
        
        userNameLabel.text = name
        passwordLabel.text = password
        
        loginButton.setRoundedRectangleBorder()
        logoutButton.setRoundedRectangleBorder()
        advancedButton.setRoundedRectangleBorder()
        selectIPButton.setRoundedRectangleBorder()
        rememberWifiButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            serverLabel.font = font
            locallabel.font = font
            
            userNameLabel.font = font
            passwordLabel.font = font
            
            userNameTextField.font = font
            passwordTextField.font = font
            
            loginButton.titleLabel?.font = font
            logoutButton.titleLabel?.font = font
            advancedButton.titleLabel?.font = font
            
            selectRSIPLabel.font = font
            selectIPButton.titleLabel?.font = font
            rememberLANShowLabel.font = font
            
            currentLANLabel.font = font
            savedWifiNameLabel.font = font
            wifiNameLabel.font = font
            notesLabel.font = font
            
            rememberWifiButton.titleLabel?.font = font
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedRSIP = SHDeviceList.selectedRemoteDevice()
        
        serverName =
            selectedRSIP?.serverName ??
            defaultRemoteServerDoMainName
        
        selectIPButton .setTitle(
            selectedRSIP?.macAddress,
            for: .normal
        )

        isLocalOrNetSwitchClick()

        setWifiName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    SHNetWorkTools.shareInstacne()?.operationQueue.cancelAllOperations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            headerViewHeightConstraint.constant = navigationBarHeight;
            
            loginViewHeightConstraint.constant = navigationBarHeight * 2 + tabBarHeight;
            
            nameLabelHeightConstraint.constant = navigationBarHeight;
            nameLabelWidthConstraint.constant = navigationBarHeight * 3;
            
            buttonsViewHeightConstraint.constant = navigationBarHeight + statusBarHeight;
            
            loginButtonHeightConstraint.constant = navigationBarHeight;
            
            setWifiViewHeightConstraint.constant = navigationBarHeight * 5;
            
            currentLANShowLabelWidthConstraint.constant = navigationBarHeight * 3;
            
            setWifiViewHeightConstraint.constant = navigationBarHeight * 3;
        }
        
    }
 
    /// 设置wifi
    private func setWifiName() {
        
        savedWifiNameLabel.text = SHSocketTools.localControlWifi()
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            
            guard let wifi = UIDevice.getWifiName(),
                let showWifi = self.wifiNameLabel.text else {
                    
                    return
            }
            
            if !(wifi.isEqual(showWifi)) {
                
                self.wifiNameLabel.text = wifi
            }
            
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
        AFNetworkReachabilityManager.shared().stopMonitoring()
    }

    // MARK: - 点击事件
    
    /// 开启远程
    @IBAction func isLocalOrNetSwitchClick() {
        
        netView.isHidden = !isLocalOrNetSwitch.isOn
        
        locallabel.isHidden = isLocalOrNetSwitch.isOn
        
        if isLocalOrNetSwitch.isOn {
            
            userNameTextField.text = UserDefaults.standard.object(forKey: loginAccout) as? String ?? ""
            
            passwordTextField.text =
                SAMKeychain.password(forService: loginServices,
                                     account: loginAccout
            )
            
            if userNameTextField.text!.isEmpty {
                
                passwordTextField.text = ""
            }
            
            UserDefaults.standard.set(
                true,
                forKey: remoteControlKey
            )
            
            UserDefaults.standard.synchronize()
            
        } else {
            
            UserDefaults.standard.set(
                false,
                forKey: remoteControlKey
            )
            
            UserDefaults.standard.synchronize()
        }
    }
    
    /// 登录按钮点击
    @IBAction func loginButtonClick() {
        
        guard let userName = userNameTextField.text,
              let password = passwordTextField.text else {
                
            let msg =
                SHLanguageTools.share()?.getTextFromPlist(
                    "SETTINGS",
                    withSubTitle: "PROMPT_MESSAGE_1"
                ) as! String
            
            SVProgressHUD.showError(withStatus: msg)
            
            return
        }
        
        loadAllDeviceList(userName, password);
    }
    
    /// 选择IP
    @IBAction func selectIPButtonClick() {
        
        let selectIPViewController =
            UIStoryboard(
                name: "SHSelectIPViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "SHSelectIPViewController"
        )
         
        navigationController?.pushViewController(
            selectIPViewController,
            animated: true
        )
    }
    
    
    /// 退出
    @IBAction func logoutButtonClick() {
    SHNetWorkTools.shareInstacne()?.operationQueue.cancelAllOperations()
        
        UserDefaults.standard.removeObject(forKey: loginAccout)
        UserDefaults.standard.synchronize()
        
        SAMKeychain.deletePassword(
            forService: loginServices,
            account: loginAccout
        )
        
        userNameTextField.text = nil
        passwordTextField.text = nil
        
        SVProgressHUD.showSuccess(withStatus: "Logout success")
    }
    
    
    /// 更新参数
    @IBAction func advancedButtoClick() {
        
        guard let userName = userNameTextField.text,
            let password = passwordTextField.text else {
                
                let msg =
                    SHLanguageTools.share()?.getTextFromPlist(
                        "SETTINGS",
                        withSubTitle: "PROMPT_MESSAGE_1"
                        ) as! String
                
                SVProgressHUD.showError(withStatus: msg)
                
                return
        }
        
        let urlString = "http://\(serverName):8888/DDNSServerService.asmx/GetDeviceList"
        
        let param: [String: String] = [
            "userName": userName,
            "password": password
        ]
        
        SHNetWorkTools.shareInstacne()?.request(
            .POST,
            urlstring: urlString,
            parameters: param,
            finished: { (res, error) in
            
            if error != nil {
                
                SVProgressHUD.showError(withStatus: "Request failed")
                return
            }
            
            let advanceController = SHAdvanceViewController()
            
            self.navigationController?.pushViewController(
                advanceController,
                animated: true
            )
        })
    }
    
    /// 记住wifi
    @IBAction func rememberWifiButtonClick() {
        
        let wifi = self.wifiNameLabel.text ?? ""
        
        if wifi.isEmpty {
            
            SVProgressHUD.showError(withStatus: "No wifi")
            return
        }
        
        savedWifiNameLabel.text = wifi
        
        if SHSocketTools.saveLocalSendDataWifi(wifi) {
            
            SVProgressHUD.showSuccess(withStatus: "save wifi succes")
        } 
    }
}


// MARK: - 指定专用的服务器名称
extension SHNetWorkServerViewController {
    
    /// 修改服务器名称
    @objc func changeServerDomainName() {
        
        let alertView =
            TYCustomAlertView(
                title: "Server domain name",
                message: "",
                isCustom: true
        )
        
        alertView?.addTextField(configurationHandler: { (textField) in
            
            textField?.borderStyle = .none
            textField?.clearButtonMode = .whileEditing
            textField?.keyboardType = .URL
            textField?.autocapitalizationType = .none
            textField?.textAlignment = .center
            textField?.font =
                UIDevice.is_iPad() ?
                UIView.suitFontForPad() :
                UIFont.systemFont(ofSize: 16)
                
            textField?.placeholder = self.serverName
            
            self.serverTextField = textField
        })
        
        let cancelAction =
            TYAlertAction(
                title: SHLanguageText.cancel,
                style: .cancel,
                handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let sureAction =
            TYAlertAction(
            title: SHLanguageText.save,
            style: .destructive) { (action) in
                
                guard let newServerName = self.serverTextField?.text?.lowercased(),
                    
                    let rsip = self.selectedRSIP,
                  UIDevice.isIllegalDomainNameOrIPAddress(newServerName) == false else {
                    
                    SVProgressHUD.showError(
                        withStatus: "Illegal domain name"
                    )
                    
                    return
                }
                
                self.serverName = newServerName
                
                // FIXME: - 更新服务器记号
                rsip.serverName = newServerName
                
                // 更新选择中的RSIP
                _ = SHDeviceList.saveSelectedRemoteDevice(rsip)
                
                // 更新所有存储的RSIP
                
                let rsips = SHDeviceList.allRemoteDevices()
                
                if rsips.isEmpty {
                    
                    return
                }
                
                for index in 0 ..< rsips.count {
                    
                    let device = rsips[index]
                    device.serverName = newServerName
                }
                
                _ = SHDeviceList.saveAllRemoteDevices(rsips)
        }
        
        alertView?.add(sureAction)
        
        
        let alertController =
            TYAlertController(
                alert: alertView!,
                preferredStyle: .alert,
                transitionAnimation: .scaleFade
        )
        
        alertController?.alertViewOriginY =
            navigationBarHeight + (
                UIDevice.is_iPhoneX_More() ?
                    defaultHeight :
                    statusBarHeight
        )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!, animated: true, completion: nil)
    }
}

// MARK: - 网络请求与解析
extension SHNetWorkServerViewController: XMLParserDelegate {
    
    /// 请求数据
    func loadAllDeviceList(_ name: String, _ passWord: String) {
        
        // 注意: 公司的服务器返回的是 XML
        SHNetWorkTools.shareInstacne()?.responseSerializer =
            AFXMLParserResponseSerializer()
        
        //    http://www.smartbuscloud.com:8888/DDNSServerService.asmx/GetDeviceList?userName=Jasminko&password=123456
        
        
        SVProgressHUD.show(withStatus: "Requesting data")
        
        let urlString = "http:\(serverName):8888/DDNSServerService.asmx/GetDeviceList"
        
        let param: [String: String] = [
            "userName": name,
            "password": passWord
        ]
        
        SHNetWorkTools.shareInstacne()?.request(
            .POST,
            urlstring: urlString,
            parameters: param,
            finished: { (res, error) in
            
            if error != nil {
                
                SVProgressHUD.showError(
                    withStatus: "request was aborted"
                )
                
                return
            }
            
            UserDefaults.standard.set(
                name,
                forKey: loginAccout
            )
                
            UserDefaults.standard.synchronize()
            
            SAMKeychain.setPassword(passWord,
                                    forService: loginServices,
                                    account: loginAccout
            )
            
            self.view.endEditing(true)
            
            let parser: XMLParser = res as! XMLParser
            parser.delegate = self
            parser.parse()
        })
    }
    
    /// 1 打开XML文档，准备开始解析
    func parserDidStartDocument(_ parser: XMLParser) {
        
        deviceLists = [SHDeviceList]()
    }
    
    /// 2 发现一个元素的开始标签
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
     
        if elementName.isEqual("DeviceList") {
            
            currentDeviceList = SHDeviceList()
        }
        
        // 清空接下来使用的全局拼接字符串, 不是nil，也不是NULL
        elementString = ""
    }
    
    /// 3 发现了节点的内容,就是读取元素的内容
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        elementString += string
    }
    
    /// 4 发现了结束的节点, 就是发现了一个元素的结束标签
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName.isEqual("DeviceList") {
            
            deviceLists?.append(currentDeviceList!)
        
        } else if elementName.isEqual("MACAddress") {
            
            currentDeviceList?.macAddress = elementString
        
        } else if elementName.isEqual("Alias") {
            
            currentDeviceList?.alias = elementString
            currentDeviceList?.serverName = serverName
        }
    }
    
    
    /// 5 文档解析完成
    func parserDidEndDocument(_ parser: XMLParser) {
        
        if deviceLists?.count == 0 {
            
            SVProgressHUD.showError(
                withStatus: "Request failed"
            )
            
            return;
        }
        
        if SHDeviceList.saveAllRemoteDevices(deviceLists!) {
        
            SVProgressHUD.showSuccess(
                withStatus: "Request success"
            )
        
            selectIPButtonClick()
        }
    }
}

// MARK: - UITextFieldDelegate
extension SHNetWorkServerViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            
            userNameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        
        } else if textField == passwordTextField {
            
            passwordTextField.resignFirstResponder()
            loginButtonClick()
        }
        
        return true
    }
   
}
