//
//  SHCentralControlViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/8.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

let centralControlCellReuseIdentifier = "SHCentralControlViewCell"

class SHCentralControlViewController: SHViewController {
    
    /// 列表
    @IBOutlet weak var listView: UICollectionView!
    
    /// 底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    fileprivate lazy var centralImageNames: [String] = {
        
        let icons = [
            "MARCO_BUTTONS",
            "LIGHTS",
            "MUSIC",
            "SECURITY",
            "CLIMATE",
            "SCHEDULE",
            "CAMERA",
            "APPLIANCES",
            "INTERCOM",
            "ENERGY"
        ]
        
        return icons
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化列表
        listView.register(
            UINib(nibName: centralControlCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier: centralControlCellReuseIdentifier
        )
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleArray: [String] = SHLanguageTools.share()?.getTextFromPlist("MAIN_PAGE", withSubTitle: "MAIN_LABEL") as! Array
        
        navigationItem.title = titleArray[1]
        
        listView.reloadData()
    }

    
    /// 布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPhoneX_More() {
            
            listViewBottomConstraint.constant = tabBarHeight_iPhoneX_more;
        }
        
        let itemMarignX:CGFloat = 1;
        
        var totalCols = self.isPortrait ? 4 : 6;
        
        if UIDevice.is_iPhone() {
            
            totalCols -= 1;
        }
        
        let itemWidth = (self.listView.frame_width - (CGFloat(totalCols) * itemMarignX)) / CGFloat(totalCols);
        
        let countForVerticalDirection = self.listView.frame_height / itemWidth;
        
        let itemMarignY = (self.listView.frame_height - (countForVerticalDirection * itemWidth)) / countForVerticalDirection;
        
        let flowLayout = listView!.collectionViewLayout as! UICollectionViewFlowLayout;
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = itemMarignY
        flowLayout.minimumInteritemSpacing = itemMarignX
    }
}


// MARK: - 数据源 
extension SHCentralControlViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return centralImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: centralControlCellReuseIdentifier,
            for: indexPath) as! SHCentralControlViewCell
        
        cell.iconName = centralImageNames[indexPath.row]
        
        return cell
    }
    
}


// MARK: - 代理
extension SHCentralControlViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
            
        case 0:
            navigationController?.pushViewController(
                SHMacroViewController(),
                animated: true
            )
            
        case 1:
            navigationController?.pushViewController(
                SHLightViewController(),
                animated: true
            )
            
        case 2:
            navigationController?.pushViewController(
                SHMusicViewController(),
                animated: true
            )
            
        case 3:
            navigationController?.pushViewController(
                SHSecurityViewController(),
                animated: true
            )
            
        case 4:
            navigationController?.pushViewController(
                SHClimateViewController(),
                animated: true
            )
            
        case 5:
            navigationController?.pushViewController(
                SHSchedualViewController(),
                animated: true
            )
            
        case 6:
            navigationController?.pushViewController(
                SHCameraViewController(),
                animated: true
            )
            
        case 7:
            navigationController?.pushViewController(
                SHApplianceViewController(),
                animated: true
            )
            
        case 8:
            navigationController?.pushViewController(
                SHIntercomViewController(),
                animated: true
            )
            
        case 9:
            navigationController?.pushViewController(
                SHCurrentTransformerViewController(),
                animated: true
            )
        default: break
            
        }
    }
}
