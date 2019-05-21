//
//  SHAreaSettingViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/15.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

import UIKit

/// cell 重用标示
private let systemCellReusableIdentifier =
    "SHSetSystemViewCell"

class SHAreaSettingViewController: SHViewController {
    
    /// 设置区域
    var region: SHRegion? {
        
        didSet {
            
            isSetupZone = region == nil
        }
    }
    
    /// 当前区域
    var currentZone: SHZone? {
        
        didSet {
            
            isSetupZone = currentZone != nil
        }
    }
    
    /// 是否是设置Zone
    private var isSetupZone = true
    
    /// 设置名称
    private lazy var deviceNames =
        SHSQLiteManager.shared.getSystemNames()
    
    /// 区域中包含的所有开启功能的系统设备
    private lazy var allSystems = [UInt]()
    
    /// 区域高度
    @IBOutlet weak var zoneViewHeightConstraint: NSLayoutConstraint!
    
    /// 按钮宽度
    @IBOutlet weak var iconButtonWidthConstraint: NSLayoutConstraint!
    
    /// 按钮高度
    @IBOutlet weak var iconButtonHeightConstraint: NSLayoutConstraint!
    
    /// 区域
    @IBOutlet weak var iconButton: UIButton!
    
    /// 名称
    @IBOutlet weak var nameTextField: UITextField!
    
    /// 设置列表
    @IBOutlet weak var deviceListView: UITableView!
}

// MARK: - 图片切换问题
extension SHAreaSettingViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// 图片按钮点击
    @IBAction func iconButtonClick() {
        
        let alertView =
            TYCustomAlertView(
                title: nil,
                message: "Change picture?",
                isCustom: true
        )
        
        // 从图片库
        let libraryAction = TYAlertAction(title: "Library", style: .default) { (action) in
            
            let zoneIconViewController = SHZoneIconViewController()
            
            zoneIconViewController.selectImage =
                { (icon: SHIcon) -> () in
                    
                    var image: UIImage?
                    
                    if icon.iconID > maxIconIDForDataBase {
                        
                        if icon.iconData != nil {
                            
                            image =
                                UIImage(data: icon.iconData!)
                        }
                        
                    } else {
                        
                        if icon.iconName != nil {
                            
                            image = UIImage(named: icon.iconName!)
                        }
                    }
                    
                    if image == nil ||
                        icon.iconName == nil {
                        
                        return
                    }
                    
                    self.iconButton.setImage(
                        image,
                        for: .normal
                    )
                    
                    // 设置区域
                    if self.isSetupZone {
                        
                        self.currentZone!.zoneIconName = icon.iconName!
                        
                        _ = SHSQLiteManager.shared.updateZone(
                            self.currentZone!
                        )
                    
                    // 设置分区
                    } else {
                        
                        self.region!.regionIconName = icon.iconName!
                        
                        _ = SHSQLiteManager.shared.updateRegion(
                            self.region!
                        )
                    }
                    
            }
            
            let navigationIconViewController =
                SHNavigationController(
                    rootViewController:
                    zoneIconViewController
            )
            
            self.present(navigationIconViewController,
                         animated: true,
                         completion: nil
            )
        }
        
        alertView?.add(libraryAction)
        
        // 从相册
        let photoAction = TYAlertAction(title: "Photos", style: .default) { (action) in
            
            if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            self.present(picker,
                         animated: true,
                         completion: nil
            )
        }
        
        alertView?.add(photoAction)
        
        
        // 从相机
        let cameraAction = TYAlertAction(title: "Camera", style: .default) { (action) in
            
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            self.present(picker,
                         animated: true,
                         completion: nil
            )
        }
        
        alertView?.add(cameraAction)
        
        // 取消
        let cancelAction =
            TYAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
        )
        
        alertView?.add(cancelAction)
        
        
        let alertController =
            TYAlertController(
                alert: alertView,
                preferredStyle: .alert,
                transitionAnimation: .dropDown
        )
        
        alertController?.backgoundTapDismissEnable = true
        
        present(alertController!,
                animated: true,
                completion: nil
        )
    }
    
    // MARK: - 代理实现部分
    
    /// 取消操作
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    /// 获得照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        // 尺寸
        let iconSize =
            CGSize(width: navigationBarHeight * 2,
                   height: navigationBarHeight * 2)
        
        let borderColor =
            UIColor(hex: 0x7b7778,
                    alpha: 1.0
        )
        
        // 图片数据
        guard let sourceImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            
            let image =
            iconButton.imageView?.reSizeImage(sourceImage, to: iconSize),
            
            let sectionImage =
            iconButton.imageView?.circleImage(
                with: image,
                borderWidth: 3.0,
                borderColor: borderColor
            )
            
            else {
                
                return
        }
        
        // 保存到相册
        if picker.sourceType == .camera {
            
            UIImageWriteToSavedPhotosAlbum(
                sectionImage, self, nil, nil
            )
        }
        
        iconButton.setImage(sectionImage, for: .normal)
        
        // 保存到数据库
        let icon = SHIcon()
        icon.iconID =
            SHSQLiteManager.shared.getMaxIconID() + 1
        
        let iconName = "icon_\(icon.iconID)"
        icon.iconName = iconName
        
        icon.iconData =
            sectionImage.pngData()
        
        _ = SHSQLiteManager.shared.insertIcon(icon)
        
        // 区域还是分组
        if isSetupZone {
            
            currentZone!.zoneIconName = iconName
            
            _ = SHSQLiteManager.shared.updateZone(currentZone!)
        
        } else {
            
            region!.regionIconName = iconName
            
            _ = SHSQLiteManager.shared.updateRegion(region!)
        }
        
    }
}



// MARK: - UITextFieldDelegate
extension SHAreaSettingViewController: UITextFieldDelegate {
    
    /// 开始编辑
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(white: 0.3, alpha: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor.white
        
        
        guard let name = textField.text else {
            return
        }
        
        if isSetupZone {
            
            currentZone?.zoneName = name
            _ = SHSQLiteManager.shared.updateZone(currentZone!)
            
        } else {
            
            region?.regionName = name
            _ = SHSQLiteManager.shared.updateRegion(region!)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}


// MARK: - UITableViewDataSource
extension SHAreaSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deviceNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: systemCellReusableIdentifier,
                for: indexPath
                ) as! SHSetSystemViewCell
        
        cell.deviceName = deviceNames[indexPath.row]
        
        cell.hasDevice = allSystems.contains(UInt(indexPath.row + 1))
        
        cell.choiceDevice = { (isHaveDevice: Bool) -> Void in
            
            let systemID = UInt(indexPath.row + 1)
            
            if self.allSystems.contains(systemID) &&
                !isHaveDevice {
                
                for type in self.allSystems.enumerated() {
                    
                    if type.element == systemID {
                        
                        self.allSystems.remove(at: type.offset)
                        
                        break
                    }
                }
                
            } else if isHaveDevice &&
                !self.allSystems.contains(systemID) {
                
                self.allSystems.append(systemID)
            }
        }
        
        return cell
    }
}


extension SHAreaSettingViewController {
    
    /// 保存配置好的数据
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isSetupZone {
        
            _ = SHSQLiteManager.shared.saveSystemIDs(
                allSystems,
                zoneID: currentZone!.zoneID
            )
        }
        
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isSetupZone {
            allSystems =
                SHSQLiteManager.shared.getSystemIDs(
                    currentZone?.zoneID ?? 0)
            
            deviceListView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Area Setting"
        
        deviceListView.isHidden = !isSetupZone
        
        deviceListView.rowHeight =
            SHSetSystemViewCell.rowHeight
        
        deviceListView.register(
            UINib(nibName: systemCellReusableIdentifier,
                  bundle: nil),
            forCellReuseIdentifier:
            systemCellReusableIdentifier
        )
        
        
        // 名称
        nameTextField.text =
            isSetupZone ? currentZone?.zoneName : region?.regionName
        
        if UIDevice.is_iPad() {
            
            nameTextField.font = UIView.suitFontForPad()
        }
        
        // 图片
        let areaIconName =
            isSetupZone ? currentZone?.zoneIconName :
                region?.regionIconName
        
        guard let iconName = areaIconName,
                let icon =
                    SHSQLiteManager.shared.getIcon(iconName),
                let image = (icon.iconData == nil) ?
                    UIImage(named: iconName) :
                    UIImage(data: icon.iconData!) else {
            
            let defaultImage =
                isSetupZone ?
                    UIImage(named: "Ceooffice") :
                    UIImage(named: "regionIcon")
            
            iconButton.setImage(defaultImage,
                                for: .normal
            )
            
            return
        }
        
        iconButton.setImage(image, for: .normal)
    }
    
    /// 布局
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            zoneViewHeightConstraint.constant =
                navigationBarHeight * 2 + statusBarHeight
            
            iconButtonWidthConstraint.constant =
                navigationBarHeight * 2
            
            iconButtonHeightConstraint.constant =
                navigationBarHeight * 2
        }
    }
}
