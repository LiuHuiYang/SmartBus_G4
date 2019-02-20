//
//  SHSettingViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标标示
fileprivate let cellReuseIdentifier = "SHSettingViewCell"

class SHSettingViewController: SHViewController {
    
    /// 显示列表
    @IBOutlet weak var listView: UITableView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    /// 显示的图片
    fileprivate lazy var settingImages: [String] = {
        
        let array = [
            "languages_setting",
            "server_setting",
            "roulter_setting",
            "datamigration_setting",
            "transmission_setting",
            "auth_setting",
            "about_setting"
        ]
        
        return array
    }()
    
    /// 默认文字
    fileprivate lazy var settingTexts: [String] = {
        
        let texts = [
            "Languages setting",
            "G4 server remote control",
            "Real ip remote control",
            "Data migration",
            "Database uploading and downloading",
            "Allow change of device configuration",
            "About"
        ]
        
        return texts
    }()
    
    /// 显示的中文
    fileprivate lazy var settingTextsChinese: [String] = {
        
        let chineseTexts = [
            "语言设置",
            "G4服务器远程控制",
            "路由器远程控制",
            "数据迁移",
            "数据库文件上传与下载",
            "允许修改设备配置",
            "关于"
        ]
        
        return chineseTexts
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化列表
        listView.rowHeight = SHSettingViewCell.rowHeight
        
        listView.register(
            UINib(nibName: cellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: cellReuseIdentifier
        )
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = (SHLanguageTools.share()?.getTextFromPlist("SETTINGS", withSubTitle: "SETTINGS") as! String)
        
        listView.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            listViewBottomConstraint.constant =
            tabBarHeight_iPhoneX_more
        }
    }
}


// MARK: - 数据源
extension SHSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SHSettingViewCell
        
        cell.showImage =
            UIImage(named: settingImages[indexPath.row])
        
        cell.showText = SHLanguageTools.isChinese() ?
            settingTextsChinese[indexPath.row] :
            settingTexts[indexPath.row]
        
        return cell
    }
}

// MARK: - 代理
extension SHSettingViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(
                SHLanguagesViewController(),
                animated: true
            )
            
        case 1:
            navigationController?.pushViewController(
                SHNetWorkServerViewController(),
                animated: true
            )
            
        case 2:
            navigationController?.pushViewController(
                SHNetWorkRealIPViewController(),
                animated: true
            )
            
        case 3:
            navigationController?.pushViewController(
                SHDataMigrationViewController(),
                animated: true
            )
            
        case 4:
            navigationController?.pushViewController(
                SHWebDataBaseViewController(),
                animated: true
            )
            
        case 5:
            navigationController?.pushViewController(
                SHAuthorizationViewController(),
                animated: true
            )
            
        case 6:
            navigationController?.pushViewController(
                SHAboutVersionViewController(),
                animated: true
            )
            
        default:
            break  // 一定要有一句话
        }
    }
}
