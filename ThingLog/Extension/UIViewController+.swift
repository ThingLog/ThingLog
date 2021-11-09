//
//  UIViewController+.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/14.
//

import UIKit

extension UIViewController {
    
    /// 상단의 네비게이션바의  경계선을 없애는 코드이며 iOS15의 대응하는 코드가 같이 있다.
    func setupBaseNavigationBar() {
        if #available(iOS 15, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = SwiftGenColors.primaryBackground.color
            appearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = SwiftGenColors.primaryBackground.color
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }
    }
}
 
