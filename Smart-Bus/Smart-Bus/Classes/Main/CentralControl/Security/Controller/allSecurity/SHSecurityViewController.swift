//
//  SHSecurityViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/12.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 安防区域的cell重用标示
private let securityZoneViewCellReuseIdentifier =
    "SHSecurityZoneViewCell"

class SHSecurityViewController: SHViewController {
    
    /// 安防区域
    private lazy var allSecurityZones = [SHSecurityZone]()
    
    @IBOutlet weak var listView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
         
        // 导航栏
        navigationItem.title =  SHLanguageText.securityTitle
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(imageName: "addDevice_navigationbar",
                            hightlightedImageName: "addDevice_navigationbar",
                            addTarget: self,
                            action: #selector(addMoreSecurityZone),
                            isLeft: false
        )
        
        // 初始化列表
        listView.register(UINib(
            nibName: securityZoneViewCellReuseIdentifier,
            bundle: nil),
                          forCellWithReuseIdentifier: securityZoneViewCellReuseIdentifier
        )
        
        // 增加手势
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(settingSecurityZone(longPressGestureRecognizer:))
        )
        
        listView.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        allSecurityZones =
            SHSQLiteManager.shared.getSecurityZones()
        
        listView.reloadData()
        
        if allSecurityZones.isEmpty {
       
            SVProgressHUD.showError(withStatus: SHLanguageText.noData)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let itemMarign: CGFloat = 1
        
        let totalCols = isPortrait ? 3 : 5
        
        let itemWidth = (listView.frame_width - (CGFloat(totalCols) * itemMarign)) / CGFloat(totalCols)
        
        let flowLayout = listView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign
    }
}


// MARK: -  安防模块的配置
extension SHSecurityViewController {
    
    /// 编辑
    @objc fileprivate func settingSecurityZone(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        if longPressGestureRecognizer.state != .began {
            return
        }
        
        let selectIndexPath = listView.indexPathForItem(
            at: longPressGestureRecognizer.location(in: listView)
        )
        
        guard let index = selectIndexPath?.item else {
            return
        }
        
        let alertView = TYCustomAlertView(title: nil,
                                          message: nil,
                                          isCustom: true
        )
        
        let editAction = TYAlertAction(title: SHLanguageText.edit, style: .default) { (action) in
            
            let editSecurityZoneController = SHDeviceArgsViewController()
            
            editSecurityZoneController.securityZone = self.allSecurityZones[index]
            
            self.navigationController?.pushViewController(
                editSecurityZoneController,
                animated: true
            )
        }
        
        alertView?.add(editAction)
        
        let deleteAction =
            TYAlertAction(title: SHLanguageText.delete,
                          style: .destructive) { (action) in
            
            let securityZone = self.allSecurityZones[index]
            
            self.allSecurityZones.remove(at: index)
                            
            _ = SHSQLiteManager.shared.deleteSecurityZone(
                securityZone
            )
            
            self.listView.reloadData()
        }
        
        alertView?.add(deleteAction)
        
        let cancelAction =
            TYAlertAction(title: SHLanguageText.cancel,
                          style: .cancel,
                          handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let alertController =
            TYAlertController(alert: alertView!,
                              preferredStyle: .alert,
                              transitionAnimation: .custom
        )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!, animated: true, completion: nil)
    }
    
    /// 增加
    @objc fileprivate func addMoreSecurityZone() {
    
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        let securityZone = SHSecurityZone()
        
        
        securityZone.id =
            SHSQLiteManager.shared.getMaxSecurityID() + 1
        
        securityZone.zoneNameOfSecurity = "Security"
      
        _ = SHSQLiteManager.shared.insertSecurityZone(
            securityZone
        )
        
        let editSecuriytZoneController = SHDeviceArgsViewController()
        
        editSecuriytZoneController.securityZone = securityZone
        
        navigationController?.pushViewController(
            editSecuriytZoneController,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDataSource
extension SHSecurityViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allSecurityZones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: securityZoneViewCellReuseIdentifier,
                for: indexPath
            ) as! SHSecurityZoneViewCell
        
        cell.securityZone = allSecurityZones[indexPath.item]
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension SHSecurityViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let securityControlViewController = SHSecurityControlViewController()
        
        securityControlViewController.securityZone = allSecurityZones[indexPath.item]
        
        navigationController?.pushViewController(
            securityControlViewController,
            animated: true
        )
    }
}
