//
//  SHZoneControlSATChannel.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/9/27.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

import UIKit

/// 分类重用标示符
private let  mediaSATCategoryCellReuseIdentifier = "SHMediaSATCategoryCell"

/// 通道重用标标符
private let mediaSATChannelCellReuseIdentifier = "SHMediaSATChannelCell"

/// 卫星电视的IR延时时间
let delayIRTimekey = "SHMediaSATChannelDelayIRTime"

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
    
    /// 显示分类
    @IBOutlet weak var categoryShowButton: SHZoneControlSATChannelButton!
    
    /// 编辑分类
    @IBOutlet weak var categoryEditButton: SHZoneControlSATChannelButton!
    
    /// 通道按钮
    @IBOutlet weak var channelButton: SHZoneControlSATChannelButton!
    
    /// 延时按钮
    @IBOutlet weak var delayForIRButton: SHZoneControlSATChannelButton!
    
    /// 分类列表
    @IBOutlet weak var categoryListView: UITableView!
    
    /// 频道视图
    @IBOutlet weak var channelListView: UICollectionView!


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 分类编辑
    @IBAction func categoryEditButtonClick() {
    
        let editController = SHMediaSATCategoryViewController()
        
        let editNavigationController =
            SHNavigationController(
                rootViewController: editController
        )
        
        let rootViewController =
            UIApplication.shared.keyWindow?.rootViewController
        
        rootViewController!.present(
            editNavigationController,
            animated: true,
            completion: nil
        )
    }

    
    /// 通道编辑
    @IBAction func channelButtonClick() {
        
        let editController = SHMediaSATChannelViewController()
        
        let editNavigationController =
            SHNavigationController(
                rootViewController: editController
        )
        
        let rootViewController =
            UIApplication.shared.keyWindow?.rootViewController
        
        rootViewController!.present(
            editNavigationController,
            animated: true,
            completion: nil
        )
    }
    
    /// 点击延时IR
    @IBAction func delayForIRButtonClick() {
        
        let title =
            SHLanguageTools.share()?.getTextFromPlist(
                "MEDIA_IN_ZONE",
                withSubTitle: "PROMPT_MESSAGE_3"
            ) as! String
        
        let alertView =
            TYCustomAlertView(
                title: nil,
                message: title,
                isCustom: true
        )
        
        alertView?.addTextField(configurationHandler: { (textField) in
            
            textField?.becomeFirstResponder()
            
            textField?.keyboardType = .numberPad
            textField?.clearButtonMode = .whileEditing
            textField?.textAlignment = .center

            let time = UserDefaults.standard.integer(
                forKey: delayIRTimekey
            ) 
            
            textField?.text = "\(time)"
            
            self.delayTextField = textField
        })
        
        let cancelAction =
            TYAlertAction(title: SHLanguageText.cancel,
                          style: .cancel,
                          
                          handler: nil)
 
        alertView?.add(cancelAction)
        
        let saveAction = TYAlertAction(
            title: SHLanguageText.save,
            style: .destructive) { (action) in
                            
                
                let time = Int(self.delayTextField?.text ?? "0") ?? 200
                
                
                if time >= 50 && time <= 5000 {
                    
                let error =
                    SHLanguageTools.share()?.getTextFromPlist(
                        "MEDIA_IN_ZONE",
                        withSubTitle: "PROMPT_MESSAGE_3"
                    ) as! String
                    
                    SVProgressHUD.showError(withStatus: error)
                    
                    return
                }
                
                UserDefaults.standard.set(time,
                                          forKey: delayIRTimekey
                )
                
                UserDefaults.standard.synchronize()

                SVProgressHUD.showSuccess(
                    withStatus: SHLanguageText.done
                )
        }
        
        alertView?.add(saveAction)
        
        let alertController =
            TYAlertController(
                alert: alertView,
                preferredStyle: .alert,
                transitionAnimation: .scaleFade
        )
        
        if UIDevice.is4_0inch() || UIDevice.is3_5inch() {

            alertController?.alertViewOriginY =
                navigationBarHeight + statusBarHeight
        }

        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        rootViewController?.present(
            alertController!,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UI初始始化
extension SHZoneControlSATChannel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryListView.rowHeight = SHMediaSATCategoryCell.rowHeight
        
        categoryListView.register(
            UINib(nibName: mediaSATCategoryCellReuseIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
                mediaSATCategoryCellReuseIdentifier
        )
        
        channelListView.register(
            UINib(nibName: mediaSATChannelCellReuseIdentifier,
                  bundle: nil),
            forCellWithReuseIdentifier:
                mediaSATChannelCellReuseIdentifier
        )
        
        channelButton.setTitle(SHLanguageText.channel,
                               for: .normal
        )
        
        let delayTitle =
            SHLanguageTools.share()?.getTextFromPlist(
                "MEDIA_IN_ZONE",
                withSubTitle: "DELAY_FOR_IR"
            ) as! String
        
        delayForIRButton.setTitle(delayTitle,
                                  for: .normal
        )
        
        let categoryShowTitle =
            SHLanguageTools.share()?.getTextFromPlist(
                "MEDIA_IN_ZONE",
                withSubTitle: "CATEGORY"
            ) as! String
        
        categoryShowButton.setTitle(categoryShowTitle,
                                  for: .normal
        )
        
        let categoryEditTitle =
            SHLanguageTools.share()?.getTextFromPlist(
                "MEDIA_IN_ZONE",
                withSubTitle: "CATEGORY_SETTINGS_TITLE"
            ) as! String
        
        categoryEditButton.setTitle(categoryEditTitle,
                                    for: .normal
        )

        // 注册通知处理分类编辑完成
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadCategoryData),
            name: NSNotification.Name.SHMediaSATCategoryEditCategoryFinished,
            object: nil
        )
        
        loadCategoryData()
        
        if UIDevice.is_iPad() {
            
            let font = UIView.suitFontForPad()
            
            delayForIRButton.titleLabel?.font = font
            channelButton.titleLabel?.font = font
            categoryEditButton.titleLabel?.font = font
            
            categoryShowButton.titleLabel?.font =
                UIFont.boldSystemFont(ofSize: 32)
        }
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
        
        // 默认选择第一个 - UI效果
        categoryListView.selectRow(
            at: IndexPath(row: 0, section: 0), animated: true,
            scrollPosition: .top
        )
        
        // 触发一下代理
        self.tableView(
            categoryListView,
            didSelectRowAt: IndexPath(row: 0, section: 0)
        )
    }
}


// MARK: - UITableViewDelegate
extension SHZoneControlSATChannel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

// MARK: - UITableViewDataSource
extension SHZoneControlSATChannel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: mediaSATCategoryCellReuseIdentifier,
                for: indexPath
            ) as! SHMediaSATCategoryCell
        
        cell.category = categories[indexPath.row]
        
        return cell
    }
}


// MARK: - UICollectionViewDataSource
extension SHZoneControlSATChannel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaSATChannelCellReuseIdentifier, for: indexPath) as! SHMediaSATChannelCell
        
        cell.channel = channels[indexPath.item]
        cell.mediaSAT = self.mediaSAT
        
        return cell
    }
    
    
}
