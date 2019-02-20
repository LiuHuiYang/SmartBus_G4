//
//  SHChangeMacroImageViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/12.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 宏图标cell重用标示
fileprivate let macroIconViewCellReuseIdentifier = "SHIconViewCell"

class SHChangeMacroImageViewController: SHViewController {
    
    /// 所有的宏图片
    @IBOutlet weak var iconListView: UICollectionView!
    
    /// 选择图片的回调
    var selectMacroImage:((_ macroImageName: String) -> ())?
    
    
    fileprivate var allMacroImages: [String] = {
       
        let array = [
        
            "Romatic" ,
            "BBQ Party" ,
            "Bed Time" ,
            "dining" ,
            "Energy Saving" ,
            "Manual" ,
            "Meeting" ,
            "Night Visitor" ,
            "Party" ,
            "Macro" ,
            "TV Time" ,
            "Vistor"
        ]
        
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iconListView.register(
            UINib(nibName: macroIconViewCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier: macroIconViewCellReuseIdentifier
        )
        
        navigationItem.title = "Choose Image For Macro"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, font: nil, normalTextColor: nil
            , highlightedTextColor: nil, imageName: "close", hightlightedImageName: "close", addTarget: self, action: #selector(close), isNavigationBackItem: true)
        
    }

    @objc fileprivate func close() -> Void {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let itemMarign: CGFloat = 1
        
        let totalCols = isPortrait ? 4 : 6
        
        let itemWidth = (iconListView.frame_width - (CGFloat(totalCols) * itemMarign)) / CGFloat(totalCols)
        
        // 获得布局
        let flowLayout =  iconListView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign
        
        iconListView.layoutSubviews()
    }

}


// MARK: - UITableViewDataSource
extension SHChangeMacroImageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allMacroImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: macroIconViewCellReuseIdentifier, for: indexPath) as! SHIconViewCell
        
        cell.zoneImage = UIImage(named: "\(allMacroImages[indexPath.item])_normal")
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate
extension SHChangeMacroImageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectMacroImage?(self.allMacroImages[indexPath.item])
        
        close()
    }
}
