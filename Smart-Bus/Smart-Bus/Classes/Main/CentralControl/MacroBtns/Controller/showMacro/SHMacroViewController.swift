//
//  SHMacroViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/11.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

/// 宏命令按钮的重用标示符
private let marcCellReuseIdentifier =
    "SHMacroCell"

class SHMacroViewController: SHViewController {
    
    @IBOutlet weak var listView: UICollectionView!
    
    
    /// 所有的宏命令
    private var allMacros: [SHMacro] = [SHMacro]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let title =
//            (SHLanguageTools.share()?.getTextFromPlist(
//                "MARCO_ACTION_BUTTON",
//                withSubTitle: "TITLE_NAME")
//            ) as! String
        
        navigationItem.title = "Macro Actions"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                imageName: "addDevice_navigationbar",
                hightlightedImageName: "addDevice_navigationbar",
                addTarget: self,
                action: #selector(addMoreMacro),
                isLeft: false
        )
        
        listView.register(UINib(nibName:
            marcCellReuseIdentifier,
                                bundle: nil),
                          forCellWithReuseIdentifier: marcCellReuseIdentifier
        )
        
        // 添加操作手势
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(settingMacro(longPressGestureRecognizer:))
        )
        
        listView.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        allMacros = SHSQLiteManager.shared.getMacros()
        
        if allMacros.isEmpty {

            SVProgressHUD.showInfo(withStatus: SHLanguageText.noData)
        }
        
        listView.reloadData()
    }
 

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let itemMarign: CGFloat = 1
        var totalCols = isPortrait ? 3 : 5
        
        if UIDevice.is_iPhone() {
            
            totalCols -= 1
        }
        
        let itemWidth = (listView.frame_width - CGFloat(totalCols) * itemMarign) / CGFloat(totalCols)
        
        let flowLayout = listView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        flowLayout.minimumLineSpacing = itemMarign
        flowLayout.minimumInteritemSpacing = itemMarign
    }
    
    /// 添加新的宏命令
    @objc func addMoreMacro() {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return;
        }
        
        let macro = SHMacro();
        
        macro.macroID =  SHSQLiteManager.shared.getMaxMacroID() + 1
        
        macro.macroName = "New Macro"
        macro.macroIconName = "Romatic"
        
        _ = SHSQLiteManager.shared.insertMacro(macro)
       
        let commandViewController = SHMacroCommandsViewController()
        
        commandViewController.macro = macro;
        
        navigationController?.pushViewController(
            commandViewController,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDataSource
extension SHMacroViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allMacros.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: marcCellReuseIdentifier,
                for: indexPath
                ) as! SHMacroCell
        
        cell.macro = allMacros[indexPath.item]
        
        return cell
    }
}


// MARK: - 手势操作
extension SHMacroViewController {
    
    @objc private func settingMacro(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if SHAuthorizationViewController.isOperatorDisable() {
            return
        }
        
        if longPressGestureRecognizer.state != .began {
            return
        }
        
        let selectIndexPath =
            listView.indexPathForItem(at:
                longPressGestureRecognizer.location(in: listView))
        
        guard let index = selectIndexPath else {
            return
        }
        
        let alertView = TYCustomAlertView(title: nil,
                                          message: nil,
                                          isCustom: true
        )
        
        let editAction =
            TYAlertAction(title: SHLanguageText.edit,
                          style: .default) { (action) in
            
            let macro = self.allMacros[index.item]
            
            let commandViewController = SHMacroCommandsViewController()
            
            commandViewController.macro = macro;
            
            self.navigationController?.pushViewController(
                commandViewController,
                animated: true
            )
        
        }
        
        alertView?.add(editAction)
        
        let deleteAction =
            TYAlertAction(title: SHLanguageText.delete,
                          style: .destructive) { (action) in
            
            let macro = self.allMacros[index.item]
            
            self.allMacros.remove(at: index.item)
            
            _ = SHSQLiteManager.shared.deleteMacro(macro)
            
            self.listView.reloadData()
        }
        
        alertView?.add(deleteAction)
        
        let cancelAction =
            TYAlertAction(title: SHLanguageText.cancel,
                                         style: .cancel,
                                         handler: nil
        )
        
        alertView?.add(cancelAction)
        
        let alertController =
            TYAlertController(alert: alertView,
                              preferredStyle: .alert,
                              transitionAnimation: .custom
        )
        
        present(alertController!, animated: true, completion: nil)
    }
}
