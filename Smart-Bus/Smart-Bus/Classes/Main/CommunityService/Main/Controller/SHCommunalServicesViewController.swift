//
//  SHCommunalServicesViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHCommunalServicesViewController: SHViewController {
    
    /// listView底部约束
    @IBOutlet weak var listViewBottomConstraint: NSLayoutConstraint!
    
    /// 列表
    @IBOutlet weak var listView: UICollectionView!
    
    fileprivate lazy var communalImageNames: [String] = {
        
        let array = [
            "COMMUNITY",
            "HOME_STATUS",
            "METERS",
            "WEATHER",
            "PHOTO",
            "ALARM",
            "SMS_CONTROL" 
        ]
        
        return array
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = (SHLanguageTools.share()?.getTextFromPlist("MAIN_PAGE", withSubTitle: "MAIN_LABEL") as! Array).last
        
        listView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.register(UINib(nibName: centralControlCellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: centralControlCellReuseIdentifier)
    }
    
    
}


extension SHCommunalServicesViewController:
    UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
            
        case 0:
            navigationController?.pushViewController(SHCommunityViewController(), animated: true)
            
        case 1:
            navigationController?.pushViewController(SHHomeStatusViewController(), animated: true)
            
        case 2:
            navigationController?.pushViewController(SHMetersViewController(), animated: true)
            
        case 3:
            navigationController?.pushViewController(SHWeatherViewController(), animated: true)
            
        case 4:
            navigationController?.pushViewController(SHPhotosViewController(), animated: true)
            
        case 5:
            navigationController?.pushViewController(SHAlarmViewController(), animated: true)
            
        case 6:
            navigationController?.pushViewController(SHSmsControlViewController(), animated: true)
            
        default: break
            
        }
    }
}

extension SHCommunalServicesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return communalImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: centralControlCellReuseIdentifier, for: indexPath) as! SHCentralControlViewCell
        
        cell.iconName = communalImageNames[indexPath.row]
        
        
        return cell
    }
}
