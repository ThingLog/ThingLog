//
//  ModifyCategoryCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/20.
//

import Foundation

protocol ModifyCategoryCoordinator: Coordinator {
    func showCategoryViewController()
}

extension ModifyCategoryCoordinator {
    /// CategoryViewController로 이동한다.
    func showCategoryViewController() {
        let categoryViewController: CategoryViewController = CategoryViewController(categoryViewType: .modify)
        categoryViewController.coordinator = self
        navigationController.pushViewController(categoryViewController, animated: true)
    }
}
