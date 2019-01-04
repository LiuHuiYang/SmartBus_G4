//
//  SHZoneIconViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/16.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// cell重用标标
let iconViewCellReuseIdentifier = "SHIconViewCell"

class SHZoneIconViewController: SHViewController {
    
    /// 选择的图片
    @objc var selectImage:((_ icon: SHIcon) -> Void)?
    
    /// 图标列表
    @IBOutlet weak var iconListView: UICollectionView!
    
    /// 所有的图片
    fileprivate lazy var allIcons: [SHIcon] =
        SHSQLManager.share()?.getAllIcons() as! [SHIcon]

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        navigationItem.title = "Choose Icon For Zone"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(imageName: "close",
                            hightlightedImageName: "close",
                            addTarget: self,
                            action: #selector(close),
                            isLeft: true
        )
        
        
        // 注册cell
        iconListView.register(
            UINib(nibName: iconViewCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier: iconViewCellReuseIdentifier
        )
        
        // 添加手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(deleteZoneImage(longPressGestureRecognizer:))
        )
        
        iconListView.addGestureRecognizer(longPress)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 计算每个item的大小
        let itemMarign: CGFloat = 1
        
        let totalCols = isPortrait ? 4 : 6
        
        let itemWidth = (self.iconListView.frame_width - (CGFloat(totalCols) * itemMarign)) / CGFloat(totalCols);
        
        let flowLayout = iconListView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign
    }

    /// 关闭
    @objc fileprivate func close() {
        
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - 删除图片
extension SHZoneIconViewController {
    
    @objc fileprivate func deleteZoneImage(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    
        if longPressGestureRecognizer.state != .began {
            
            return
        }
        
        let selectIndex = iconListView.indexPathForItem(at: longPressGestureRecognizer.location(in: iconListView))
        
        guard let index = selectIndex?.item else {
            return
        }
        
        let icon = allIcons[index]
        
        if icon.iconID > (SHSQLManager.share()?.getMaxIconIDForSystemIcon())! {
            
            let alertView =
                TYCustomAlertView(title: "Do you want to delete the picture?",
                                  message: nil,
                                  isCustom: true
            )
            
            let cancelAction = TYAlertAction(title: SHLanguageText.cancel,
                                             style: .default,
                                             handler: nil
            )
            
            alertView?.add(cancelAction)
            
            let sureAction = TYAlertAction(title: SHLanguageText.yes, style: .destructive) { (action) in
                
                UIImage.deleteZoneControlImage(forZones: icon.iconName)
                
                self.allIcons.remove(at: index)
                
                SHSQLManager.share()?.delete(icon)
                
                self.iconListView.reloadData()
                
                SVProgressHUD.showSuccess(withStatus: nil)
            }
            
            alertView?.add(sureAction)
            
            let alertController =
                TYAlertController(alert: alertView!,
                                  preferredStyle: .alert,
                                  transitionAnimation: .scaleFade
            )
            
            present(alertController!, animated: true, completion: nil)
            
        } else {
            
            let alertView = TYCustomAlertView(
                title: "System Icon can not been deleted!",
                message: nil,
                isCustom: true
            )
            
            let sureAction = TYAlertAction(title: SHLanguageText.ok,
                                           style: .default,
                                           handler: nil
            )
            
            alertView?.add(sureAction)
            
            let alertController =
                TYAlertController(alert: alertView!,
                                  preferredStyle: .alert,
                                  transitionAnimation: .scaleFade
            )
            
            present(alertController!, animated: true, completion: nil)
        }
    }
}




// MARK: - UICollectionViewDelegate
extension SHZoneIconViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectImage?(allIcons[indexPath.item])
        
        close()
    }
}

// MARK: - UICollectionViewDataSource
extension SHZoneIconViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: iconViewCellReuseIdentifier,
            for: indexPath
        ) as! SHIconViewCell
        
        let icon = allIcons[indexPath.row]
        
        var zoneImage = UIImage(named: icon.iconName ?? "")
        
        if zoneImage == nil {
            
            zoneImage = UIImage(data: icon.iconData!)
        }
        
        cell.zoneImage = zoneImage
        
        return cell
    }
    
    
    
}
