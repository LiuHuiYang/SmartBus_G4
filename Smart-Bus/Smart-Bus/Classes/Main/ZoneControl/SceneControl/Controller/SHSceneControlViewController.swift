//
//  SHSceneControlViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标示
private let sceneControlViewCellReuseIdentifier = "SHSceneControlViewCell"

class SHSceneControlViewController: SHViewController {
    
    /// 当前区域
    var currentZone: SHZone?
    
    /// 所有的场景
    private lazy var scenes = [SHScene]()
    
    /// 列表
    @IBOutlet weak var listView: UITableView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID else {
            
            return
        }
        
        scenes = SHSQLiteManager.shared.getScenes(zoneID)
        
        if scenes.isEmpty {
            
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
                sceneControlViewCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                sceneControlViewCellReuseIdentifier
        )
        
        listView.rowHeight =
            SHSceneControlViewCell.rowHeight
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
extension SHSceneControlViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scenes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier:
                    sceneControlViewCellReuseIdentifier,
                for: indexPath
        ) as! SHSceneControlViewCell
        
        cell.scene = scenes[indexPath.row]
        
        return cell
    }
    
}
