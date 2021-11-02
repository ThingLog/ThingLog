//
//  UIView+.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//

import UIKit

extension UIView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
    
    /// 뷰위에 그라데이션 layer를 추가하는 메서드입니다.
    /// - Parameters:
    ///   - startColor: 시작하는 컬러를 지정합니다.
    ///   - endColor: 끝나는 컬러를 지정합니다.
    ///   - startPoint: 시작하고자 하는 위치를 지정합니다.
    ///   - endPoint: 끝나는 위치를 지정합니다.
    ///
    /// ```swift
    /// // 하단에서 상단으로 주고싶을떄
    /// setGradient(startColor: .black,
    ///             endColor: .white,
    ///             startPoint: CGPoint(x: 0.0, y: 1.0),
    ///             endPoint: CGPoint(x: 0.0, y: 0.0)
    /// ```
    func setGradient(startColor: UIColor,
                     endColor: UIColor,
                     startPoint: CGPoint,
                     endPoint: CGPoint) {
        if let sublayers: [CALayer] = layer.sublayers {
            for sublayer in sublayers where sublayer.name == "customGradient"{
                return
            }
        }
 
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds
        gradient.name = "customGradient"
        layer.addSublayer(gradient)
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
