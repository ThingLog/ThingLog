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

    /// 현재 뷰의 부모 뷰 컨트롤러를 찾는다.
    /// - Returns: 현재 뷰의 부모 뷰 컨트롤러(optional)를 반환한다. 
    func findParentViewController() -> UIViewController? {
        if let nextResponder: UIViewController = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder: UIView = self.next as? UIView {
            return nextResponder.findParentViewController()
        } else {
            return nil
        }
    }
}
