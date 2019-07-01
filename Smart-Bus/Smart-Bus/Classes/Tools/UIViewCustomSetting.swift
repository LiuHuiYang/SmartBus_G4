/*
 
 设置项目工程中的基本UIView及子控件的属性
 
 */

import UIKit


extension UIView {
    
    @objc func setRoundedRectangleBorder() {
        
        let isPad = UIDevice.is_iPad()
        
        self.layer.borderColor =
            UIColor(hex: 0xECECEC, alpha: 0.8)?.cgColor
        
        self.layer.borderWidth =
            isPad ? 3.0 : 1.0
        
        self.layer.cornerRadius =
            isPad ? statusBarHeight : statusBarHeight * 0.5
    }
    
    /// 文本白色样式
    ///
    /// - Returns: UIColor
    @objc static func textWhiteColor() -> UIColor {
        
        return UIColor(hex: 0xfdfdfd, alpha: 1.0)
    }
    
    /// 文本白色样式
    ///
    /// - Returns: UIColor
    @objc static func highlightedTextColor() -> UIColor {
        
        return UIColor(hex: 0xEF963B, alpha: 1.0)
    }
  
 
    /// iPad的适配字体(加大)
    ///
    /// - Returns: UIFont
    @objc static func suitLargerFontForPad() -> UIFont {
        
        return UIFont.boldSystemFont(ofSize: 36)
    }
     
    
    /// iPad的适配字体(普通)
    ///
    /// - Returns: UIFont
    @objc static func suitFontForPad() -> UIFont {
        
        return UIFont.boldSystemFont(ofSize: 24)
    }
}
 

