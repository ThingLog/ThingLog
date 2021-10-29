//
//  Coordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/18.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    /// 뒤로 이동한다.
    func back() {
        navigationController.popViewController(animated: true)
    }
}
