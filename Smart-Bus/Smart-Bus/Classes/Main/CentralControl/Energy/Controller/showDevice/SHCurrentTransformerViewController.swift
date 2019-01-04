//
//  SHCurrentTransformerViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/11.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// CT24Cell重用ID
fileprivate let currentTransformerCellReuseIdentifier =
    "SHCurrentTransformerCollectionViewCell"

class SHCurrentTransformerViewController: SHViewController {

    /// 显示列表
    @IBOutlet weak var listView: UICollectionView!
    
    /// 所有的设备
    fileprivate var allCurrentTransformers: [SHCurrentTransformer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        navigationItem.title = "Energy"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addNewDevices),
                isLeft: false
        )
        
        listView.register(UINib(nibName:
            currentTransformerCellReuseIdentifier,
                                bundle: nil),
                          forCellWithReuseIdentifier: currentTransformerCellReuseIdentifier
        )
        
        // 添加操作手势
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(settingCurrentTransformer(longPressGestureRecognizer:))
        )
        
        listView.addGestureRecognizer(longPress)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        allCurrentTransformers = SHSQLManager.share()?.getAllCurrentTransformers() as? [SHCurrentTransformer]
        
        if allCurrentTransformers?.count == 0 {
             
            SVProgressHUD.showInfo(withStatus: SHLanguageText.noData)
        }
        
        listView.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let itemMarign: CGFloat = 1
        let totalCols = isPortrait ? 3 : 5
        
//        if UIDevice.is_iPhone() {
//
//            totalCols -= 1
//        }
        
        let itemWidth = (listView.frame_width - CGFloat(totalCols) * itemMarign) / CGFloat(totalCols)
        
        let flowLayout = listView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign
    }
}


// MARK: - 添加新的设备 && 设置
extension SHCurrentTransformerViewController {
    
    /// 添加新的设备
    @objc fileprivate func addNewDevices() {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return;
        }
        
        let currentTransformer = SHCurrentTransformer();
        
        currentTransformer.currentTransformerID =  UInt((SHSQLManager.share()?.getMaxCurrentTransformerID() ?? 0) + 1)
        
        currentTransformer.remark = "CT24"
        
        SHSQLManager.share()?.insert(currentTransformer)
        
        let addDevicesController = SHDeviceArgsViewController()
        
        addDevicesController.currentTransformer = currentTransformer
        
        navigationController?.pushViewController(
            addDevicesController,
            animated: true
        )
    }
    
    /// 设置的设备
    @objc fileprivate func settingCurrentTransformer(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        if longPressGestureRecognizer.state != .began {
            return
        }
        
        let selectIndexPath =
            listView.indexPathForItem(at:
                longPressGestureRecognizer.location(in: listView))
        
        guard let index = selectIndexPath else {
            return
        }
        
        let alertView = TYCustomAlertView(title: nil,
                                          message: nil,
                                          isCustom: true
        )
     
        
        let editAction = TYAlertAction(title: SHLanguageText.edit, style: .default) { (action) in
            
            let currentTransformer = self.allCurrentTransformers?[index.item]
            
            let detailViewController = SHDeviceArgsViewController()
            
            detailViewController.currentTransformer =
                currentTransformer
            
            self.navigationController?.pushViewController(
                detailViewController,
                animated: true
            )
            
        }
        
        alertView?.add(editAction)
        
        let deleteAction = TYAlertAction(title: SHLanguageText.delete, style: .destructive) { (action) in
            
            let currentTransformer = self.allCurrentTransformers?[index.item]
            
            self.allCurrentTransformers?.remove(at: index.item)
            
            SHSQLManager.share()?.delete(currentTransformer)
            
            self.listView.reloadData()
        }
        
        alertView?.add(deleteAction)
        
        let cancelAction = TYAlertAction(title: SHLanguageText.cancel,
                                         style: .cancel,
                                         handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let alertController =
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .custom
        )
        
        present(alertController!, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension SHCurrentTransformerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allCurrentTransformers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: currentTransformerCellReuseIdentifier,
                for: indexPath
                ) as! SHCurrentTransformerCollectionViewCell
        
        cell.currentTransformer = allCurrentTransformers?[indexPath.item]
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension SHCurrentTransformerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let realTimeDataController =
//            SHCurrentTransformerRealTimeDataViewController()
//
//        realTimeDataController.currentTransformer = allCurrentTransformers?[indexPath.item]
        
        let showDataController = SHCurrentTransformerShowDataViewController()
        showDataController.currentTransformer =
            allCurrentTransformers?[indexPath.item]
        
        navigationController?.pushViewController(
            showDataController,
            animated: true
        )
    }
    
}
