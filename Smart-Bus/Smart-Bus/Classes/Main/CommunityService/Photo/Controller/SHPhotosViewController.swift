//
//  SHPhotosViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/10/29.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHPhotosViewController: SHViewController, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    
    /// 按钮高度
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 照片按钮
    @IBOutlet weak var photosButton: UIButton!
    
    /// 相机
    @IBOutlet weak var cameraButton: UIButton!
    
    /// 胶卷
    @IBOutlet weak var albumsButton: UIButton!
    
    /// 选择胶卷
    @IBAction func albumsClick() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            let  picker = UIImagePickerController();
            
            picker.sourceType = .savedPhotosAlbum;
            
            picker.delegate = self;
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    /// 选择相机
    @IBAction func cameraClick(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let  picker = UIImagePickerController();
            
            picker.sourceType = .camera;
            
            picker.delegate = self;
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    /// 选择相册
    @IBAction func photosClick() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let  picker = UIImagePickerController();
        
            picker.sourceType = .photoLibrary;
            
            picker.delegate = self;
           
            present(picker, animated: true, completion: nil)
        }
    }
    
    
    /// 取消操作
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// 获得照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

     
        picker.dismiss(animated: true, completion: nil)
        
        
        let sourceImage = UIImage.fixOrientation((info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage))
        
        guard let iamge = sourceImage else {
            return
        }
        
        if picker.sourceType == .camera {
            
            UIImageWriteToSavedPhotosAlbum(iamge, self, nil, nil);
        }
        
        
        // .... 将要实现的内容
    }
}





// MARK: - UI与布局
extension SHPhotosViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = (SHLanguageTools.share()?.getTextFromPlist("MAIN_PAGE", withSubTitle: "PHOTO") as! String)
        
        photosButton.setRoundedRectangleBorder()
        cameraButton.setRoundedRectangleBorder()
        albumsButton.setRoundedRectangleBorder()
        
        if UIDevice.is_iPad() {
            photosButton.titleLabel?.font = UIView.suitFontForPad()
            cameraButton.titleLabel?.font = UIView.suitFontForPad()
            albumsButton.titleLabel?.font = UIView.suitFontForPad()
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
