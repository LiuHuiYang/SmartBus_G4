//
//  SHChangeMoodImageViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/19.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHChangeMoodImageViewController: SHViewController {
    
    /// 选择的图片名称
    var selectMoodImage: ((_ moodIconName: String) -> ())?

    /// 图标列表
    @IBOutlet weak var iconListView: UICollectionView!
    
    /// 所有的图片
    fileprivate lazy var moodImageNames: [String] = {
       
        let array = [
        
            "mood_romantic",
            "mood_bye",
            "mood_dining",
            "mood_meeting",
            "mood_night",
            "mood_party",
            "mood_study",
            "mood_tv"
        ]
        
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        navigationItem.title = "Choose Image For Mood"
        
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
    }
    
    /// 关闭
    @objc fileprivate func close() {
        
        dismiss(animated: true, completion: nil)
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

}


// MARK: - UICollectionViewDelegate
extension SHChangeMoodImageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectMoodImage?(moodImageNames[indexPath.item])
        
        close()
    }
}



// MARK: - UICollectionViewDataSource
extension SHChangeMoodImageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return moodImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: iconViewCellReuseIdentifier,
            for: indexPath
            ) as! SHIconViewCell
        
        let iconName = moodImageNames[indexPath.row] + "_normal"
        
        cell.zoneImage = UIImage(named: iconName)
        
        return cell
    }
    
}
