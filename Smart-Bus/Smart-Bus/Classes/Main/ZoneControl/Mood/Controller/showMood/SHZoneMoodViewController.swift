//
//  SHZoneMoodViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/7/26.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

/// cell重用标示
private let moodCellReuseIdentifier = "SHMoodCell"

class SHZoneMoodViewController: SHViewController {
    
    /// 当前区域
    var currentZone: SHZone?
    
    /// 所有的模型
    lazy var allMoods = [SHMood]()
    
    /// 两个按钮的高度约束
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 所有的模式显示列表
    @IBOutlet weak var moodsCollectionView: UICollectionView!
    
    /// 录制按钮
    @IBOutlet weak var recordButton: UIButton!
    
    /// 底部约束
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    /// 录制
    @IBAction func recordMoodClick() {
        
        let recordMoodController =
            SHZoneControlRecordMoodViewController()
        
        recordMoodController.currentZone = currentZone
        
        navigationController?.pushViewController(
            recordMoodController,
            animated: true
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title =
            (SHLanguageTools.share()?.getTextFromPlist(
                "MOOD_IN_ZONE",
                withSubTitle: "RECORD_MOOD")
                ) as! String
        
        recordButton.setTitle(title, for: .normal)
        
        recordButton.setRoundedRectangleBorder()
        
        moodsCollectionView.backgroundColor = UIColor.clear
        moodsCollectionView.register(
            UINib(nibName: moodCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier: moodCellReuseIdentifier
        )
        
        if UIDevice.is_iPad() {
            recordButton.titleLabel?.font = UIView.suitFontForPad()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let zone = currentZone else {
            
            return
        }
        
        allMoods =
            SHSQLiteManager.shared.getMoods(zone.zoneID)
        
        if allMoods.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
        }
        
        moodsCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomHeightConstraint.constant = (UIDevice.is_iPhoneX_More()) ? (tabBarHeight_iPhoneX_more + statusBarHeight) : (tabBarHeight + statusBarHeight)
        
        if UIDevice.is_iPad() {
            buttonHeightConstraint.constant =
                (navigationBarHeight + statusBarHeight)
        }
        
        let itemMarign: CGFloat =
            moodsCollectionView.frame_width * 0.02
        
        let totalCols = isPortrait ? 2 : 3
        
        let itemWidth: CGFloat =
            (moodsCollectionView.frame_width - (CGFloat(totalCols) * itemMarign)) / CGFloat(totalCols)
        
        let flowLayout =
            moodsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.5)
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign
        
        
    }
}


// MARK: - UITableViewDataSource
extension SHZoneMoodViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: moodCellReuseIdentifier,
                for: indexPath
                ) as! SHMoodCell
        
        cell.mood = allMoods[indexPath.item]
        
        return cell
    }
}
