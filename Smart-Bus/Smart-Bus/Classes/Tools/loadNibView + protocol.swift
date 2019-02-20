 

import UIKit
 
 protocol loadNibView {
    
 }
 
 extension loadNibView where Self: UIView {
    
    // Swift中，Self 表示当前类，作为函数返回值类型
    static func loadFromNib() -> Self {
        
        return Bundle.main.loadNibNamed(
            "\(self)",
            owner: nil,
            options: nil
        )?.first as! Self
    }
 }
