//
//  CategoryCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/18.
//

import UIKit

final class CategoryCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let categoryViewController: CategoryViewController = CategoryViewController()
        categoryViewController.coordinator = self 
        navigationController.pushViewController(categoryViewController, animated: true)
    }
}
