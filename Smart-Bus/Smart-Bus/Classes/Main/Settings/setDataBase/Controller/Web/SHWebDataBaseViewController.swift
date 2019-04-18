//
//  SHWebDataBaseViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/11/23.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit
import GCDWebServer

class SHWebDataBaseViewController: SHViewController {
    
    /// 网络服务器
    lazy var webServer: GCDWebUploader = {
        
        let server =
            GCDWebUploader(uploadDirectory: FileTools.documentPath())
        server.delegate = self
        server.allowHiddenItems = true
        return server
    }()
    
    /// 文件列表
    lazy var fileLists  = [String]()
    
    /// 标题高度约束
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!
    
    /// 提示开关文字
    @IBOutlet weak var openCloseServiceLabel: UILabel!
    
    /// url提示文字
    @IBOutlet weak var urlShowLabel: UILabel!
    
    /// url的地址
    @IBOutlet weak var urlLabel: UILabel!
    
    /// 开启功能开关
    @IBOutlet weak var openSwitch: UISwitch!
    
    /// 操作列表
    @IBOutlet weak var operatorLabel: UILabel!
    
    /// 开关点击
    @IBAction func openSwitchClick() {
        
        // 由于启动时会依据是否为最新版本来判断 是否需要判断数据为为新的还是旧的
        // 所以清空沙盒中的版本记录, App重新启动时会重新执行一次
        UserDefaults.standard.set("", forKey: sandboxVersionKey)
        UserDefaults.standard.synchronize()
        
        // 检查网络环境
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            
            switch status {
                
            case .unknown, .notReachable:
                SVProgressHUD.showError(withStatus: "NetWork Not Reachable")
                
            case .reachableViaWiFi, .reachableViaWWAN:
                
                if self.openSwitch.isOn {
                    if self.webServer.start() {
                        
                        self.urlLabel.text = self.webServer.serverURL?.absoluteString
                    }
                } else {
                    
                    self.urlLabel.text = nil
                    self.webServer.stop()
                    self.openSwitch.isOn = false
                }
                
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        operatorLabel.text = "  1.Open a PC, and make it and this phone in the same network.\n\n  2. Open the browser on the PC.\n\n  3. Input the URL of this phone into the browser.\n\n  4. Find the file \"SMART-BUS.sqlite\", You can download it and upload it by browser,make sure the name is \"SMART-BUS.sqlite\".\n\n  5. Restart this app when database been changed."
        
        loadFileList()
        
        openSwitch.setOn(false, animated: false)
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            openCloseServiceLabel.font = font
            urlLabel.font = font
            urlShowLabel.font = font
            operatorLabel.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            titleViewHeightConstraint.constant = navigationBarHeight
        }
    }
    
    /// 退出界面
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if openSwitch.isOn {
            urlLabel.text = nil
            openSwitch.isOn = false
            webServer.stop()
        }
    }
}


// MARK: - 文件的上传下载
extension SHWebDataBaseViewController {
     
    /// 加载所有的文件列表
    private func loadFileList() {
        
        fileLists.removeAll()
        
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: FileTools.documentPath()) else {
            
            return
        }
        
        for i in 0 ..< files.count {
            // if ([files[i] hasSuffix:@".sqlite"]) {
            fileLists.append(files[i])
            //  }
        }
    }
    
    /// 获取新的数据库文件
    private func getLatestDateBaseFile() {
        
        var allSqlites = [String]()
        
        guard let destSqlites = try? FileManager.default.contentsOfDirectory(atPath: FileTools.documentPath()) else {
            return
        }
        
        for sqliteName in destSqlites {
            
            if sqliteName.hasSuffix(".sqlite") {
                
                allSqlites.append(sqliteName)
            }
        }
        
        // 用户手动删除了旧数据库
        if allSqlites.count == 1 && (allSqlites.last == dataBaseName) {
            return // 不需要处理
        }
        
        // 2.找到最新的数据库
        var baseIndex: Int = 0
        
        for fileName in allSqlites {
            
            guard var sqliteName = fileName as NSString? else {
                continue
            }
            
            let start = sqliteName.range(of: "(")
            
            if start.location != NSNotFound {
                
                sqliteName = sqliteName.substring(from: (start.location + start.length)) as NSString
                
                let end = sqliteName.range(of: ")")
                
                if end.location != NSNotFound {
                    
                    sqliteName = sqliteName.substring(to: end.location) as NSString
                }
            }
            
            // 获得副本序号
            baseIndex = Int(sqliteName.intValue) > baseIndex ? Int(sqliteName.intValue) : baseIndex
            
        }
        
//        print("最新的文件 baseIndex = \(baseIndex)")
        
        // 获取最后的数据库文件
        var newDataBase = ""
        
        for fileName in allSqlites {
            
            if fileName.contains("\(baseIndex)") {
                
                newDataBase = fileName
                
            } else {
                
                let path = FileTools.documentPath() + "/" + fileName
                
                _ = try? FileManager.default.removeItem(atPath: path)
            }
        }
        
        // 3.新数据库换名
        if !newDataBase.isEmpty && newDataBase != dataBaseName {
            
            let oldPath = FileTools.documentPath() + "/" + dataBaseName
            
            let newPath = FileTools.documentPath() + "/" + newDataBase
            
            _ = try? FileManager.default.moveItem(atPath: newPath,
                                                  toPath: oldPath)
        }
    }
}


// MARK: - GCDWebServerDelegate
extension SHWebDataBaseViewController: GCDWebUploaderDelegate {
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        
        let fileName =
            (path as NSString).lastPathComponent
        
        if fileName.contains(".sqlite") {
            
            getLatestDateBaseFile()
            
            SVProgressHUD.showSuccess(
                withStatus: "Upload \n \(dataBaseName)"
            )
            
            // 重启数据库
            SHSQLiteManager.shared.restart()
             
            return
        }
        
        SVProgressHUD.showSuccess(
            withStatus: "Upload \n \(fileName)"
        )
    }
    
    /// 删除文件的回调
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        
        let fileName =
            (path as NSString).lastPathComponent
        
        if fileName.contains(".sqlite") {
            
            SVProgressHUD.showSuccess(
                withStatus: "Delete \n \(dataBaseName)"
            )
            
            // 重启数据库
            SHSQLiteManager.shared.restart()
            
            return
        }
        
        SVProgressHUD.showSuccess(
            withStatus: "Delete \n \(fileName)"
        )
    }
    
    
    func numberOfFiles() -> Int {
        return fileLists.count
    }
    
    func fileName(at index: Int) -> String? {
        return fileLists[index]
    }
    
    func filePath(forFileName filename: String?) -> String? {
        
        return URL(fileURLWithPath: FileTools.documentPath()).appendingPathComponent(filename ?? "").absoluteString
    }
    
    func newFileDidUpload(_ name: String?, inTempPath tmpPath: String?) {
        
        if name == nil || tmpPath == nil {
            return
        }
        
        let path = URL(fileURLWithPath: FileTools.documentPath()).appendingPathComponent(name!).absoluteString
        
        if let _ = try? FileManager.default.moveItem(atPath: tmpPath!, toPath: path) {
            
            // ... 出错了
        }
        
        loadFileList()
    }
    
    func fileShouldDelete(_ fileName: String?) {
        
        let path = filePath(forFileName: fileName) ?? ""
        
        if (try? FileManager.default.removeItem(atPath: path)) != nil {
            
        }
        
        loadFileList()
    }
}
