//
//  SHRegionViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/15.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标示符
private let zoneControlCellReuseIdentifier =
    "SHZoneControlViewCell"

class SHRegionViewController: SHViewController {
    
    /// 所有的区域
    private lazy var regions = [SHRegion]()
    
    /// 地区列表
    @IBOutlet weak var listView: UICollectionView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sections"
        
        let addItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addRegion),
                isLeft: false
        )
        
        navigationItem.rightBarButtonItem = addItem

        listView.register(
            UINib(nibName: zoneControlCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier:
            zoneControlCellReuseIdentifier
        )
        
        // 添加手势
        let longPress =
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(settingRegion(longPressGestureRecognizer:))
        )
        
        longPress.minimumPressDuration = 1.0
        
        listView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        
        regions = SHSQLiteManager.shared.getAllRegions()
        
        if regions.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        }
        
        listView.reloadData()
    }
    
    /// 布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            listViewBottomConstraint.constant =
            tabBarHeight_iPhoneX_more
        }
        
        let itemMarignX: CGFloat = 1
        
        var totalCols = isPortrait ? 4 : 6
        
        if UIDevice.is_iPhone() {
            
            totalCols -= 1
        }
        
        let itemWidth: CGFloat = (listView.frame_width - (CGFloat(totalCols) * itemMarignX)) / CGFloat(totalCols)
        
        let countForVerticalDirection = Int(listView.frame_height / itemWidth)
        
        let itemMarignY = (listView.frame_height - (CGFloat(countForVerticalDirection) * itemWidth)) / CGFloat(countForVerticalDirection)
        
        let flowLayout = listView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize =
            CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = itemMarignY
        flowLayout.minimumInteritemSpacing = itemMarignX
    }
}


// MARK: - 地区设置
extension SHRegionViewController {
    
    /// 添加地区
    @objc private func addRegion() {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        let region = SHRegion()
        region.regionID =
            SHSQLiteManager.shared.getMaxRegionID()
                + 1
        region.regionName = "New Region"
        region.regionIconName = "regionIcon"
        
        _ = SHSQLiteManager.shared.insertRegion(region)
   
        let detailController =
            SHRegionSettingViewController()
        
        detailController.region = region
        
        navigationController?.pushViewController(
            detailController,
            animated: true
        )
    }
    
    /// 编辑与删除地区
    @objc private func settingRegion(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        if longPressGestureRecognizer.state != .began {
            return
        }
        
        guard let index =
            listView.indexPathForItem(
                at: longPressGestureRecognizer.location(
                    in: listView)
            ) else {
                
                return
        }
        
        
        let alertView = TYCustomAlertView(title: nil,
                                          message: nil,
                                          isCustom: true
        )
        
        let editAction =
            TYAlertAction(
                title: SHLanguageText.edit,
                style: .default) { (action) in
                    
                    let region = self.regions[index.item]
                    
                    let detailController =
                        SHRegionSettingViewController()
                    
                    detailController.region = region
                    self.navigationController?.pushViewController(
                        detailController,
                        animated: true
                    )
                    
        }
        
        alertView?.add(editAction)
        
        let deleteAction =
            TYAlertAction(title: SHLanguageText.delete,
                          style: .destructive) { (action) in
                            
                            let region = self.regions[index.item]
                            self.regions.remove(at: index.item)
                            SHSQLManager.share()?.deleteRegion(region.regionID)
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
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .custom
        )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension SHRegionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let zoneController = SHZoneControlViewController()
        
        zoneController.region = regions[indexPath.item];
        
        navigationController?.pushViewController(
            zoneController,
            animated: true
        )
    }
}


// MARK: - UICollectionViewDataSource
extension SHRegionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: zoneControlCellReuseIdentifier,
                for: indexPath
                ) as! SHZoneControlViewCell
        
        cell.region = regions[indexPath.item]
        
        return cell
    }
    
    
    
}
