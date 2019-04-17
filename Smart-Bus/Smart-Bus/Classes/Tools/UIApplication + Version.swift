 

import UIKit
 
 /// 沙盒记录版本标示
 let sandboxVersionKey = "sandboxVersionKey"

 extension UIApplication {
    
    /// 是否为最新版本
    static func isLatestVersion() -> Bool {
        
        // 获得记录版本
        let sandboxVersion =
            UserDefaults.standard.object(
                forKey: sandboxVersionKey
                ) as? String
        
        // 当前应用版本
        let currentVersion =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        // 设置最新版本
        UserDefaults.standard.set(
            currentVersion,
            forKey: sandboxVersionKey
        )
        
        UserDefaults.standard.synchronize()
        
        return currentVersion == sandboxVersion
    }
 }
