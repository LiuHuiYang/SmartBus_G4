 

import Foundation
 
/// 输出日志
///
/// - parameter message:  日志消息
/// - parameter logError: 错误标记，默认是 false，如果是 true，发布时仍然会输出
/// - parameter file:     文件名
/// - parameter method:   方法名
/// - parameter line:     代码行数
func printMessage<T>(message: T,
                 logError: Bool = false,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line)
{
    if logError {
        
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    
    } else {
        
        #if DEBUG
       
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        
        #endif
    }
}
 
