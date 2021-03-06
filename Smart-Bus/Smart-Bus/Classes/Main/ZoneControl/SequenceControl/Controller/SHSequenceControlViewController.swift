//
//  SHSequenceControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2019/1/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

private let sequenceControlViewCellReuseIdentifier =
    "SHSequenceControlViewCell"

class SHSequenceControlViewController: SHViewController {
    
    /// 当前区域
    var currentZone: SHZone?
    
    /// 所有的序列
    private lazy var sequences = [SHSequence]()
    
    /// 列表
    @IBOutlet weak var listView: UITableView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zoneID = currentZone?.zoneID else {
                    
            return
        }
        
        sequences =
            SHSQLiteManager.shared.getSequences(zoneID)
        
        if sequences.isEmpty {
            
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
                sequenceControlViewCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                sequenceControlViewCellReuseIdentifier
        )
        
        listView.rowHeight =
            SHSequenceControlViewCell.rowHeight
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
extension SHSequenceControlViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sequences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier:
                    sequenceControlViewCellReuseIdentifier,
                for: indexPath
            ) as! SHSequenceControlViewCell
        
        cell.sequence = sequences[indexPath.row]
        
        return cell
    }
}
