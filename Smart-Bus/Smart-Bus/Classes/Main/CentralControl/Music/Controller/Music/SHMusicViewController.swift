//
//  SHMusicViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/29.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

import UIKit

private let deviceCellReuseIdentifier = "SHZoneDevicesCell"

class SHMusicViewController: SHViewController {
    
    /// 所有的音乐列表
    @IBOutlet weak var listView: UICollectionView!
    
    /// 所有的音乐设备
    private lazy var allAudios = (SHSQLManager.share()?.getAllZonesAudioDevices() as? [SHAudio]) ?? [SHAudio]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.register(
            UINib(nibName: deviceCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier: deviceCellReuseIdentifier
        )
        
        let title =
            (SHLanguageTools.share()?.getTextFromPlist(
                "MAIN_PAGE",
                withSubTitle: "MUSIC")
            ) as! String
        
        navigationItem.title = title
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if UIDevice.is_iPhoneX_More() {
//
//            listViewBottomConstraint.constant = tabBarHeight_iPhoneX
//        }
        
        let itemMarign: CGFloat = 1
        let totalCols  = isPortrait ? 3 : 5
        let itemWidth = (listView.frame_width - (CGFloat(totalCols) * itemMarign)) / CGFloat(totalCols)
        
        let flowLayout = listView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize =
            CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign
    }
}


// MARK: - UICollectionViewDataSource
extension SHMusicViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let audioPlayController = SHZoneAudioPlayControlViewController()
        
        audioPlayController.currentAudio = allAudios[indexPath.item]
        
        navigationController?.pushViewController(
            audioPlayController,
            animated: true
        )
        
        // ===================================================
        // 备用功能扩展代码【以后如果要增加录制的话，使用下面的注释的代码】
        // ===================================================
        
        //    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:nil message:nil isCustom:YES];
        //
        //    // 播放
        //    [alertView addAction: [TYAlertAction actionWithTitle:@"Play" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        //
        //        SHZoneAudioPlayControlViewController *audioPlayController = [[SHZoneAudioPlayControlViewController alloc] init];
        //
        //        audioPlayController.currentAudio = self.allAudios[indexPath.item];
        //
        //        [self.navigationController pushViewController:audioPlayController animated:YES];
        //
        //    }]];
        //
        //    // 录制
        //    [alertView addAction: [TYAlertAction actionWithTitle:@"Record" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        //
        //        SHAudioRecordViewController *recordController = [[SHAudioRecordViewController alloc] init];
        //
        //        recordController.currentAudio = self.allAudios[indexPath.item];
        //
        //        [self.navigationController pushViewController:recordController animated:YES];
        //
        //    }]];
        //
        //    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
        //
        //    alertController.backgoundTapDismissEnable = YES;
        //
        //    [self presentViewController:alertController animated:YES completion:nil];
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allAudios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: deviceCellReuseIdentifier,
                for: indexPath
            ) as! SHZoneDevicesCell
        
        cell.zoneAudio = allAudios[indexPath.item]
        
        return cell
    }
    
    
}
