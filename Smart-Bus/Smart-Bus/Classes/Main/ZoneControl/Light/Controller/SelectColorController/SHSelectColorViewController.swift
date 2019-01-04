//
//  SHSelectColorViewController.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/4/27.
//  Copyright © 2017年 SmartHomeGroup. All rights reserved.
//

import UIKit

class SHSelectColorViewController: SHViewController {
    
    /// 执行回调
    var selectColorCallBack: ((_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> Void)?
    
    // 四个属性
    var red:   CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue:  CGFloat = 0.0
    var alpha: CGFloat = 0
    
    /// 回调执行过了
    var isCallBackCompleted = false
    
    /// 取色计
    private lazy var colorView: SHColorWheelView = {
        
        let view = SHColorWheelView()
        
        view.delegate = self
        
        return view
    }()

    /// 按钮高度
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    /// 取消按钮
    @IBOutlet weak var doneButton: UIButton!
    
    /// 显示颜色的view
    @IBOutlet weak var showColorView: UIView!

    /// 完成
    @IBAction func doneButtonClick() {
    
        selectColorCallBack?(red, green, blue, alpha)
        
        dismiss(animated: true, completion: nil)
    }
    
    /// 显示取色计
    func showColor(_ completion: @escaping (_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> Void) {
        
        selectColorCallBack = completion
        
        let rootController =
            UIApplication.shared.keyWindow?.rootViewController
        
        rootController?.present(
            self,
            animated: true,
            completion: nil
        )
    }
}


// MARK: - SHColorWheelViewDelegate
extension SHSelectColorViewController: SHColorWheelViewDelegate {
    
    /// 实现这个代理是为了方便发送数据
    func setZonesColorData(_ colorData: Data?, recognizer: UIGestureRecognizer?) {
        
        if colorData == nil ||
            recognizer == nil {
            
            return
        }
        
        let colors = [UInt8](colorData!)
        
        red   = CGFloat(colors[0]) / 255.0
        green = CGFloat(colors[1]) / 255.0
        blue  = CGFloat(colors[2]) / 255.0
        alpha = CGFloat(colors[3]) / 255.0
        
        let color =
            UIColor(red:red, green:green, blue:blue, alpha:alpha)
        
        showColorView.backgroundColor = color
        
        if recognizer!.state == .ended {
            
            selectColorCallBack?(red, green, blue, alpha)
            
            isCallBackCompleted = true
        }
    }
}


// MARK: - UI初始化
extension SHSelectColorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.setTitle(SHLanguageText.done, for: .normal)
        doneButton.setRoundedRectangleBorder()
        
        view.addSubview(colorView)
        colorView.backgroundColor = UIColor.orange
        
        if UIDevice.is_iPad() {
            
            doneButton.titleLabel?.font = UIView.suitFontForPad()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let colorWidth =
            min(view.frame_width, view.frame_height)
        
        colorView.frame =
            CGRect(x: 0, y: 0, width: colorWidth * 0.75, height: colorWidth * 0.75)
        
        colorView.center = view.center
        
        // 在重绘制图片 -- 触发系统重新绘制 drawRect
        //        colorView.setNeedsDisplay(colorView.bounds)
        
        if UIDevice.is_iPad() {
            
            buttonHeightConstraint.constant =
                navigationBarHeight + statusBarHeight
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // 这个方法在重布局时调用，不显示(iPad, iPhone正常.)
        colorView.setNeedsDisplay()
    }
}
