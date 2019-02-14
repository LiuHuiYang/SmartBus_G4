//
//  SHDmxChannelSettingViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/30.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHDmxChannelSettingViewController: SHViewController {
    
    /// 分组
    var dmxGroup: SHDmxGroup?
    
    /// 所有的通道
    private lazy var allChannels: [SHDmxChannel] =
        [SHDmxChannel]()
    
    /// 通道列表
    @IBOutlet weak var channelListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Dmx Channel"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addNewDmxChannel),
                isLeft: false
        )
        
        channelListView.rowHeight = SHZoneDeviceGroupSettingCell.rowHeight
        
        channelListView.register(
            UINib(nibName: deviceGroupSettingCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier: deviceGroupSettingCellReuseIdentifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let group = dmxGroup else {
            
            return
        }
        
        allChannels =
            SHSQLiteManager.shared.getDmxGroupChannels(group)
        
        if allChannels.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        }
        
        channelListView.reloadData()
    }
    
    /// 增加新的通道
    @objc private func addNewDmxChannel() {
        
        let dmxChannel = SHDmxChannel()
        dmxChannel.zoneID = dmxGroup?.zoneID ?? 0
        dmxChannel.groupID = dmxGroup?.groupID ?? 1
        dmxChannel.groupName = dmxGroup?.groupName ?? "dmx group"
        
        let res =
            SHSQLiteManager.shared.insertDmxChannel(
                dmxChannel
            )

        dmxChannel.id = (res == 0) ? 1 : UInt(res)

        let detailViewController = SHDeviceArgsViewController()
        
        detailViewController.dmxChannel = dmxChannel
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }

}


// MARK: - UITableViewDelegate
extension SHDmxChannelSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = SHDeviceArgsViewController()
        
        detailViewController.dmxChannel =
            allChannels[indexPath.row]
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "\t\(SHLanguageText.delete)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let dmxChannel = self.allChannels[indexPath.row]
            
            self.allChannels.remove(at: indexPath.row)
            
           
            _ = SHSQLiteManager.shared.deleteDmxChannel(dmxChannel)
            
            tableView.reloadData()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "\t\(SHLanguageText.edit)\t") { (action, indexPath) in
            
            tableView.setEditing(false, animated: true)
            
            let detailViewController =
                SHDeviceArgsViewController()
            
            detailViewController.dmxChannel =
                self.allChannels[indexPath.row]
            
            self.navigationController?.pushViewController(
                detailViewController,
                animated: true
            )
        }
        
        return [deleteAction, editAction]
    }
}

// MARK: - UITableViewDataSource
extension SHDmxChannelSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: deviceGroupSettingCellReuseIdentifier,
                for: indexPath
            ) as! SHZoneDeviceGroupSettingCell
        
        cell.dmxChannel = allChannels[indexPath.row]
        
        return cell
    }
    
    
}

