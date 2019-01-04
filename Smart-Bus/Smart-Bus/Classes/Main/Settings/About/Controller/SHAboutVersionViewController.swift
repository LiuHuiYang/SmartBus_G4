//
//  SHAboutVersionViewController.swift
//  Smart-Bus
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

class SHAboutVersionViewController: SHViewController {
    
    /// 版本信息
    @IBOutlet weak var versionLabel: UILabel!
    
    /// 二维码的显示框
    @IBOutlet weak var qrcodeView: UIImageView!
    
    /// 二维码宽度
    @IBOutlet weak var qrcodeViewWidthConstraint: NSLayoutConstraint!
    
    /// 二维码高度
    @IBOutlet weak var qrcodeViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "About";
        
        if UIDevice.is_iPad()  {
            
            versionLabel.font = UIView.suitFontForPad()
        }
        
       let versionTitle =  SHLanguageTools.share()!.getTextFromPlist("SETTINGS", withSubTitle: "VERSION")!
        
        
       let version =
            Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        
        versionLabel.text = "\(versionTitle): \(version)"
        
        let image = createQRCode(
            urlString: "https://itunes.apple.com/us/app/smart-bus-g4/id482559360",
            imageSize: qrcodeView.frame.size,
            logolImage: UIImage(named: "qrcode_center")!)
        
        guard let qrcode = image else {
            return
        }
        
        qrcodeView.image = qrcode
    }
}




// MARK: - 二维码的生成
extension SHAboutVersionViewController {


    /// 生成二维码图片
    ///
    /// - Parameters:
    ///   - urlString: url字符串
    ///   - imageSize: 整个二维码图片的大小
    ///   - logolImage: 中间的小图片
    /// - Returns: 二维码图片
    func createQRCode(urlString: String, imageSize: CGSize, logolImage: UIImage?) -> UIImage? {

        // ============== 生成二维码 ===================
        let filterCreate = CIFilter(name: "CIQRCodeGenerator")

        guard let filter = filterCreate else {
            
            return nil
            
        }

        filter.setDefaults()
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        //    官方建议使用 NSISOLatin1StringEncoding 来编码，但经测试这种编码对中文或表情无法生成，改用 NSUTF8StringEncoding 就可以了。
        let inputData = urlString.data(using: String.Encoding.utf8)!
        
        filter.setValue(inputData, forKey: "inputMessage")
        
        
        let qrcodeImage = UIImage(ciImage: filter.outputImage!.transformed(by: CGAffineTransform(scaleX: 30, y: 30)))
        
        //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
        UIGraphicsBeginImageContext(qrcodeImage.size);
        
        //把二维码图片画上去
        qrcodeImage.draw(in: CGRect(x: 0, y: 0, width: qrcodeImage.size.width, height: qrcodeImage.size.height))
        
        //再把小图片画上去
        let logoImageSize = CGFloat.minimum(qrcodeImage.size.width, qrcodeImage.size.height) * 0.35
        
        let logoImageX =
            (qrcodeImage.size.width - logoImageSize) * 0.5;
        
        let logoImageY =
            (qrcodeImage.size.height - logoImageSize) * 0.5;
        
        logolImage?.draw(in: CGRect(x: logoImageX, y: logoImageY, width: logoImageSize, height: logoImageSize))
        
        let logoQRCodeimage =
            UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return logoQRCodeimage;
    }
}



// MARK: - 页面布局
extension SHAboutVersionViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.is_iPad() {
            
            let constant = CGFloat.minimum(view.frame_width, view.frame_height) * 0.5
            
            qrcodeViewWidthConstraint.constant = constant
            qrcodeViewHeightConstraint.constant = constant
        }
    }
}
