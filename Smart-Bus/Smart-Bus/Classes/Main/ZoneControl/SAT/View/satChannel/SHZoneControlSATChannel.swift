//
//  SHZoneControlSATChannel.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/27.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit


/// 分类重用标示符
private let mediaSATCategoryCollectionCellReuseIdentifier =
    "SHMediaSATCategoryCollectionCell"

/// 通道重用标示符
private let mediaSATChannelCellReuseIdentifier = "SHMediaSATChannelCell"


class SHZoneControlSATChannel: UIView, loadNibView {
    
    /// 卫星电视
    var mediaSAT: SHMediaSAT?
    
    /// 所有的分类
    private lazy var categories = [SHMediaSATCategory]()
    
    /// 所有的频道
    private lazy var channels = [SHMediaSATChannel]()
    
    /// 引导输入框
    weak var delayTextField: UITextField?

    /// 分组视图的高度
    @IBOutlet weak var groupViewHeightConstraint: NSLayoutConstraint!
    
    
    /// 分类列表
    @IBOutlet weak var categoryListView: UICollectionView!
    
    /// 频道视图
    @IBOutlet weak var channelListView: UICollectionView!


    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - UI初始始化
extension SHZoneControlSATChannel {
    
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

        // 注册通知处理分类编辑完成
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadCategoryData),
            name: NSNotification.Name.SHMediaSATCategoryEditCategoryFinished,
            object: nil
        )
        
        loadCategoryData()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // 1.2 计算每个item的大小
        var itemMarign: CGFloat = min(channelListView.frame_width, channelListView.frame_height) * 0.1
        
        // 总列数
        let totalCols: Int = 2
        
        let itemWidth = (channelListView.frame_width - (CGFloat((totalCols + 1)) * itemMarign)) / CGFloat(totalCols)
        
        let itemSize: CGFloat =
            min(itemWidth, channelListView.frame_height)

        itemMarign = (channelListView.frame_width - CGFloat(totalCols) * itemSize) / CGFloat(totalCols + 1)

        let flowLayout = channelListView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize =
            CGSize(width: itemSize, height: itemSize)
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign

        if UIDevice.is_iPad() {

            groupViewHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }

    }
    
    /// 加载数据
    @objc private func loadCategoryData() {
        
        categories = SHSQLiteManager.shared.getSatCategory()
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
            
            let category = categories[indexPath.row]
            
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
