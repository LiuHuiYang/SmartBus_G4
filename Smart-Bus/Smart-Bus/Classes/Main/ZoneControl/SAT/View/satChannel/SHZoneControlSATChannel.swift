//
//  SHZoneControlSATChannel.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/27.
//  Copyright © 2017年 SmartHome. All rights reserved.

import UIKit


/// 分类重用标示符
private let mediaSATCategoryCollectionCellReuseIdentifier =
    "SHMediaSATCategoryCollectionCell"

/// 通道重用标示符
private let mediaSATChannelCellReuseIdentifier = "SHMediaSATChannelCell"


class SHZoneControlSATChannel: UIView, loadNibView {
    
    /// 卫星电视
    var mediaSAT: SHMediaSAT? {
        
        didSet {
            
            loadCategoryData()
        }
    }
    
    /// 所有的分类
    private lazy var categories = [SHMediaSATCategory]()
    
    /// 所有的频道
    private var channels = [SHMediaSATChannel]()
    
    /// 引导输入框
    weak var delayTextField: UITextField?

    /// 分组视图的高度
    @IBOutlet weak var groupViewHeightConstraint: NSLayoutConstraint!
    
    /// 分类列表
    @IBOutlet weak var categoryListView: UICollectionView!
    
    /// 频道视图
    @IBOutlet weak var channelListView: UICollectionView!
 
}

// MARK: - UI初始始化
extension SHZoneControlSATChannel {
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            
            return
        }
        
        loadCategoryData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       categoryListView.register(
        UINib(
            nibName: mediaSATCategoryCollectionCellReuseIdentifier,
            bundle: nil),
        
            forCellWithReuseIdentifier:
                mediaSATCategoryCollectionCellReuseIdentifier
        )
 
        channelListView.register(
            UINib(nibName: mediaSATChannelCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier:
                mediaSATChannelCellReuseIdentifier
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
  
        if UIDevice.is_iPad() {

            groupViewHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
        
        let isPortrait = frame_height > frame_width
        
        let totalCols =
            UIDevice.is_iPad() ? (isPortrait ? 3 : 4) : 2
 
        let itemMarign =
            UIDevice.is_iPad() ?
                statusBarHeight :
                statusBarHeight * 0.5
        
        let itemHeight =
            groupViewHeightConstraint.constant - statusBarHeight
        
        let itemWidth =
            (frame_width - statusBarHeight * 2 -
                CGFloat(totalCols + 1) * itemMarign) /
                CGFloat(totalCols)
  
        let categoryFlowLayout = categoryListView.collectionViewLayout as! UICollectionViewFlowLayout

        categoryFlowLayout.itemSize =
            CGSize(width: itemWidth,
                   height: itemHeight
        )

        categoryFlowLayout.minimumLineSpacing =
            itemMarign
        
        categoryFlowLayout.minimumInteritemSpacing =
            itemMarign
     
        // 详细频道列表
        
        let channelFlowLayout = channelListView.collectionViewLayout as! UICollectionViewFlowLayout
        
        channelFlowLayout.itemSize =
            CGSize(width: itemWidth,
                   height: itemHeight
        )
        
        channelFlowLayout.minimumLineSpacing =
            itemMarign

        channelFlowLayout.minimumInteritemSpacing =
            itemMarign
    }
    
    /// 加载数据
    @objc private func loadCategoryData() {
        
        
        guard let sat = self.mediaSAT else {
            return
        }
        
        categories = SHSQLiteManager.shared.getSatCategory(sat)
        
        categoryListView.reloadData()
        
        if categories.isEmpty {
            
            SVProgressHUD.showInfo(
                withStatus: SHLanguageText.noData
            )
            
            return
        }
        
        // 默认执行第一个
        let indexPath = IndexPath(item: 0, section: 0)
        categoryListView.selectItem(
            at: indexPath,
            animated: false,
            scrollPosition:
                UICollectionView.ScrollPosition.bottom
        )
        
        self.collectionView(categoryListView,
                            didSelectItemAt: indexPath
        )
        
    }
}


// MARK: - UICollectionViewDelegate
extension SHZoneControlSATChannel: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryListView {
            
            SVProgressHUD.dismiss()
            
            let category = categories[indexPath.item]
            
            channels =
                SHSQLiteManager.shared.getSatChannels(category)
            
            if channels.isEmpty {
                
                SVProgressHUD.showInfo(withStatus: SHLanguageText.noData)
                
            }
            
            channelListView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SHZoneControlSATChannel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == channelListView {
            
             return channels.count
        
        } else if collectionView == categoryListView {
        
            return categories.count
        } 
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == channelListView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaSATChannelCellReuseIdentifier, for: indexPath) as! SHMediaSATChannelCell
            
            cell.channel = channels[indexPath.item]
            cell.mediaSAT = self.mediaSAT
            
            return cell
        
        } else if collectionView == categoryListView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                mediaSATCategoryCollectionCellReuseIdentifier, for: indexPath) as! SHMediaSATCategoryCollectionCell
            
            cell.category = categories[indexPath.item];
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}
