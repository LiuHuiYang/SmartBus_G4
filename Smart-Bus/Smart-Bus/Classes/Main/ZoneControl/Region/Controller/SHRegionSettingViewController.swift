//
//  SHRegionSettingViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2019/1/15.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHRegionSettingViewController: SHViewController {
 
    /// 地区
    var region: SHRegion?
    
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

    
     


}


// MARK: - 图片切换问题
extension SHRegionSettingViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// 图片按钮点击
    @IBAction func iconButtonClick() {
    
        let alertView =
            TYCustomAlertView(
                title: nil,
                message: "Change section picture?",
                isCustom: true
        )
        
        // 从图片库
        let libraryAction = TYAlertAction(title: "Library", style: .default) { (action) in
            
            let zoneIconViewController = SHZoneIconViewController()
            
            zoneIconViewController.selectImage =
                { (icon: SHIcon) -> () in
                    
                    guard let area = self.region,
                        icon.iconName != area.regionIconName else {
                        
                        return
                    }
                    
                    var image: UIImage?
                    
                    // 10 就是最大会系统ID
                    if icon.iconID > maxIconIDForDataBase {
                        
                        if icon.iconData != nil {
                        
                            image =
                                UIImage(data: icon.iconData!)
                        }
                        
                    } else {
                        
                        image = UIImage(named: area.regionIconName)
                    }
                    
                    if image == nil ||
                       icon.iconName == nil {
                        
                        return
                    }
                    
                    self.iconButton.setImage(
                        image,
                        for: .normal
                    )
                    
                    area.regionIconName = icon.iconName!
                    SHSQLManager.share()?.update(area)
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
        
        alertController?.backgoundTapDismissEnable =
            true
        
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
        guard let area = region,
            
            let sourceImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
        
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
            (SHSQLManager.share()?.getMaxIconID() ?? 0)
                + 1
        
        let iconName = "icon_\(icon.iconID)"
        icon.iconName = iconName
        
        icon.iconData =
            sectionImage.pngData()
        
        // 插入到图片
        SHSQLManager.share()?.inserNewIcon(icon)
        
        area.regionIconName = iconName
        
        SHSQLManager.share()?.update(area)
    }
}


// MARK: - 名称问题
extension SHRegionSettingViewController: UITextFieldDelegate {
    
    /// 开始编辑
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.textColor =
            UIColor(white: 0.3, alpha: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor.white
      
        guard let area = region,
            let name = textField.text,
            name != area.regionName else {
                
            return
        }
        
        area.regionName = name
        SHSQLManager.share()?.update(area)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}


// MARK: - UI初始化
extension SHRegionSettingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title =
            (region?.regionName ?? "region") + " Setting"
        
        // 名称
        nameTextField.text = region?.regionName
        
        if UIDevice.is_iPad() {
            
            nameTextField.font = UIView.suitFontForPad()
        }
        
        // 图片
        guard let area = region,
            let iconData =
            SHSQLManager.share()?.getIcon(
                area.regionIconName
            )?.iconData,
            
            let image = UIImage(data: iconData)
            
            else {
                
                let defaultIcon =
                    UIImage(
                        named:
                        "HOME_STATUS_highlighted"
                )
                
                iconButton.setImage(defaultIcon,
                                    for: .normal
                )
                
                return
        }
        
        iconButton.setImage(image, for: .normal)
        
    }
    
    
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