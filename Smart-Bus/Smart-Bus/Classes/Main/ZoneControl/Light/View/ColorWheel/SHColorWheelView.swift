//
//  SHColorWheelView.swift
//  Smart-Bus
//
//  Created by Mark Liu on 2017/4/16.
//  Copyright © 2017年 SmartHomeGroup. All rights reserved.
//

import UIKit

/// Swift中的代理方法默认是 必须 实现的

/// 取色计代理
@objc protocol SHColorWheelViewDelegate {
    
    /// 设置区域颜色
    @objc optional func setZonesColor(_ color: UIColor?)
    
    @objc optional func setZonesColorData(_ colorData: Data?, recognizer: UIGestureRecognizer?)
}

// 360度
private let Circle: CGFloat = 360.0

class SHColorWheelView: UIView {

    /// 代理
    weak var delegate: SHColorWheelViewDelegate?

    /// 内部绘制出来的图片
    private var iconView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addGestureRecognizers()
    }
    
    /// 添加手势
    private func addGestureRecognizers() {
        
        // 1.点击手势
        let tapGestureRecognizer =
            UITapGestureRecognizer(
                target: self,
                action: #selector(selectColor(_:))
        )
        
        addGestureRecognizer(tapGestureRecognizer)
   
 
        // 拖拽手势
        let panGestureRecognizer =
            UIPanGestureRecognizer(
                target: self,
                action: #selector(changeColor(_:))
        )
        
        addGestureRecognizer(panGestureRecognizer)
        
        tapGestureRecognizer.require(
            toFail: panGestureRecognizer
        )
    }
}


// MARK: - 手势操作 && 代理回调
extension SHColorWheelView {
    
    /// 拖拽手势取出的颜色
    @objc private func changeColor(_ recognizer: UIPanGestureRecognizer?) {
        
        guard let view = recognizer?.view,
            let point = recognizer?.location(in: view) else {
                return
        }
        
        // 获得某个点的颜色
        // let color = iconView?.color(atPixel: point)
        
        //  因为拖动起来一直是在递增，所以每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
        recognizer?.setTranslation(CGPoint.zero, in: view)
        
        // 执行代理回调
        delegate?.setZonesColorData!(
            iconView?.data(withColor: point),
            recognizer: recognizer
        )
    }
    
    @objc private func selectColor(_ recognizer: UITapGestureRecognizer?) {
        
        guard let view = recognizer?.view,
            let point = recognizer?.location(in: view) else {
                return
        }
        
        // 获得某个点的颜色
        // let color = iconView?.color(atPixel: point)
        
        // 执行代理回调
        delegate?.setZonesColorData!(
            iconView?.data(withColor: point),
            recognizer: recognizer
        )
    }
}


// MARK: - 绘制取色计
extension SHColorWheelView {
    
    /// 绘制图形
    override func draw(_ rect: CGRect) {
        
        let radius: CGFloat =
            min(rect.size.width, rect.size.height) * 0.48
        
        let maxRadius: CGFloat =
            min(rect.size.width, rect.size.height) * 0.5
        
        let angle: CGFloat = 2 * (CGFloat.pi) / Circle
        
        let center = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.5)
        
        UIGraphicsBeginImageContextWithOptions(
            rect.size,
            true,
            0
        )
        
        /*************** 去除整背景颜色 ****************/
        UIColor.clear.setFill()
        UIRectFill(rect)
        
        /******** 外围区域的白色 **************/
        let whitePath =
            UIBezierPath(arcCenter: center,
                         radius: maxRadius,
                         startAngle: 0,
                         endAngle: 2 * .pi,
                         clockwise: true
        )
        
        whitePath.lineWidth = maxRadius - radius
        whitePath.addLine(to: center)
        whitePath.close()
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        whitePath.fill()
        whitePath.stroke()
        
        /**************** 绘制区域中彩虹 *********************/
        for i in 0 ..< 360 {
            
            let path =
                UIBezierPath(arcCenter: center,
                             radius: radius,
                             startAngle: CGFloat(i) * angle,
                             endAngle: CGFloat(i + 1) * angle,
                             clockwise: true
            )
            
            path.addLine(to: center)
            path.close()
            
            let color = UIColor(hue: CGFloat(i) / Circle,
                                saturation: 1,
                                brightness: 1,
                                alpha: 1
            )
            
            color.setFill()
            color.setStroke()
            
            path.fill()
            path.stroke()
        }
        
        /***************** 生成图片 ***********/
        
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        iconView = UIImageView(image: image)
        iconView?.bounds = bounds
        iconView?.isUserInteractionEnabled = true
        addSubview(iconView!)
    }
    
    /// 布局时才切圆角
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setFillet()
    }
    
    /// 切成圆角
    private func setFillet() {
        
        let radius: CGFloat =
            min(bounds.size.width, bounds.size.height) * 0.5
        
        let bezierPath =
            UIBezierPath(
                arcCenter: CGPoint(x: radius, y: radius),
                radius: radius,
                startAngle: 0,
                endAngle: CGFloat.pi * 2,
                clockwise: true
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        layer.mask = maskLayer
    }
}
