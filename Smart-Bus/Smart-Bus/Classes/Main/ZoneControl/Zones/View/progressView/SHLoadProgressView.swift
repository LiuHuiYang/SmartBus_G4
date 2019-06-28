//
//  SHLoadProgressView.swift
//  Smart-Bus
//
//  Created by Apple on 2019/6/28.
//  Copyright © 2019 SmartHome. All rights reserved.
//

import UIKit

class SHLoadProgressView: UIView, loadNibView {
    
    /// 进度条
    @IBOutlet weak var progressView: UIProgressView!
    
    /// 进度条
    @IBOutlet weak var progressLabel: UILabel!
    
    /// 定时器
    private var progressTimer: Timer?

    /// 加载视图
    static let shared = SHLoadProgressView.loadFromNib()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        progressView.isHidden = false
        progressLabel.text = ""
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressView.isHidden = false
        progressLabel.text = ""
    }
    
    // 从 xib或sb文件加载
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 从文件中他对， 要注释掉
        // fatalError的意思是无条件停止执行并打印。
        //  fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.superview != nil {
            
            self.frame = superview?.bounds ?? CGRect.zero
        }
    }
    
    /// 加载到父控件
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        progressValueChange()
    }
    
    /// 进度条变化
    private func progressValueChange() {
        
        progressView.isHidden = false
        progressView.progress = 0.0
        progressLabel.text = ""
        
        // 加载定时器变化
        let timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(updateProgress),
            userInfo: nil,
            repeats: true
        )
        
        RunLoop.current.add(timer, forMode: .common)
        
        progressTimer = timer
    }
    
    
    /// 更新进度条
    @objc private func updateProgress() {
        
        progressView.progress += 0.01
        progressLabel.text = "\(Int(progressView.progress * 100))%"
    
        if progressView.progress >= 1.0 {
            
            progressTimer?.invalidate()
            progressTimer = nil
            
            
            NotificationCenter.default.post(
                name:
                NSNotification.Name(
                    rawValue: commandExecutionComplete
                ),
                object: nil
            )
            
            if superview != nil {
                
                progressView.progress = 0.0
                progressLabel.text = ""
                
                removeFromSuperview()
            }
        }
        
    }
}

extension SHLoadProgressView {
     
    /// 指定View上显示
    ///
    /// - Parameter view: 指定的View
    static func showIn(_ superView: UIView) {
        
        let view = SHLoadProgressView.shared
        
        if view.superview != nil {
            
            view.removeFromSuperview()
        }
        
        superView .addSubview(view)
        
        view.progressView.transform =
            CGAffineTransform(scaleX: 1.0, y: 1.5);
        
        if UIDevice.is_iPad() {
            
            view.progressLabel.font =
                UIFont.boldSystemFont(ofSize: 22)
            
            view.progressView.transform =
                CGAffineTransform(scaleX: 1.0, y: 3.0);
        }
    }
}
