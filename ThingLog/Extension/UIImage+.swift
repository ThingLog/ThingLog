//
//  UIImage+.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/25.
//

import UIKit

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage? {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
