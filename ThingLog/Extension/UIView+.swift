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
}
