//
//  SHOtherControlViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// 其它控制的重用cell
let otherControlViewCellReuseIdentifier =
    "SHOtherControlViewCell"

@objcMembers class SHOtherControlViewController: SHViewController {
    
    /// 当前区域
    @objc var currentZone: SHZone?
    
    /// 所有的其它控制
    private lazy var otherControls = [SHOtherControl]()
    
    /// 列表
    @IBOutlet weak var listView: UITableView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID else {
            
            return
        }
        
        otherControls =
            SHSQLiteManager.shared.getOtherControls(zoneID)
        
        if otherControls.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        }
        
        listView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        listView.register(
            UINib(nibName:
                otherControlViewCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
            otherControlViewCellReuseIdentifier
        )
        
        listView.rowHeight =
            SHOtherControlViewCell.rowHeight
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            listViewBottomConstraint.constant =
            tabBarHeight_iPhoneX_more
        }
    }

}

// MARK: - UITableViewDataSource
extension SHOtherControlViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return otherControls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier:
                otherControlViewCellReuseIdentifier,
                for: indexPath
            ) as! SHOtherControlViewCell
        
        cell.otherControl = otherControls[indexPath.row]
        
        return cell
    }
}
