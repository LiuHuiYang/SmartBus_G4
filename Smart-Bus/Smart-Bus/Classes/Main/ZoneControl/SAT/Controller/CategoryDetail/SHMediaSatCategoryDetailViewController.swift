//
//  SHMediaSatCategoryDetailViewController.swift
//  Smart-Bus
//
//  Created by Apple on 2019/4/11.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHMediaSatCategoryDetailViewController: SHViewController {

    /// 分组
    var satCategory: SHMediaSATCategory?
    
    /// 频道
    private var satChannels = [SHMediaSATChannel]()
    
    /// 频道列表
    @IBOutlet weak var listView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        satChannels =
            SHSQLiteManager.shared.getSatChannels(satCategory!)
        
        listView.reloadData()
        
        if satChannels.isEmpty {
            
            SVProgressHUD.showInfo(withStatus:
                SHLanguageText.noData
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title =
            SHLanguageTools.share()?.getTextFromPlist(
                "MEDIA_IN_ZONE",
                withSubTitle: "CATEGORY_SETTINGS_TITLE"
            ) as? String
        
        // 增加频道
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addMoreSatChannel),
                isLeft: false
        )
        
        // 注册
        listView.register(
            UINib(nibName: mediaSatCategoryEditCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                mediaSatCategoryEditCellReuseIdentifier
        )
        
        listView.rowHeight = SHMediaSATCategoryEditViewCell.rowHeight
    }

    
    /// 增加更多的频道
    @objc private func addMoreSatChannel() {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        guard let category = satCategory else {
            return
        }
        
        let channelViewController =
            SHDeviceArgsViewController()
        
        let satChannel = SHMediaSATChannel()
        satChannel.categoryID = category.categoryID
        satChannel.zoneID = category.zoneID
        satChannel.channelID =
            SHSQLiteManager.shared.getMaxChannelID(
                category
            ) + 1
        
        _ = SHSQLiteManager.shared.insertSatChannel(satChannel)
        
        channelViewController.mediaSatChannel = satChannel
        
        navigationController?.pushViewController(
            channelViewController,
            animated: true
        )
    }
}


// MARK: - UITableViewDelegate
extension SHMediaSatCategoryDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "\t\(SHLanguageText.delete)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let channel = self.satChannels[indexPath.row]
            
            self.satChannels.remove(at: indexPath.row)
            
            _ = SHSQLiteManager.shared.deleteSatChannel(
                channel
            )
            
            tableView.reloadData()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "\t\(SHLanguageText.edit)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            self.tableView(self.listView,
                           didSelectRowAt: indexPath
            )
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        let detailViewController = SHDeviceArgsViewController()
        
        detailViewController.mediaSatChannel =
            satChannels[indexPath.row]
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}

// MARK: - UITableViewDataSource
extension SHMediaSatCategoryDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return satChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier:
                    mediaSatCategoryEditCellReuseIdentifier
            ) as! SHMediaSATCategoryEditViewCell
        
        cell.channel = satChannels[indexPath.row]
        
        return cell
    }
}
