//
//  WriteCoordinator.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import CoreData
import UIKit

protocol WriteCoordinatorProtocol: SystemSettingCoordinatorProtocol {
    /// WriteViewController로 이동한다.
    /// - Parameter viewModel: WriteViewController를 생성하기 위해 WriteViewModel이 필요하다.
    func showWriteViewController(with viewModel: WriteViewModel)

    /// CategoryViewController로 이동한다.
    func showCategoryViewController(with type: CategoryViewController.CategoryViewType,
                                    entities: [CategoryEntity])

    /// PhotosViewController로 이동한다.
    func showPhotosViewController()

    /// naviagtionController를 dismiss 한다.
    func dismissWriteViewController()
}

extension WriteCoordinatorProtocol {
    /// CategoryViewController로 이동한다.
    func showCategoryViewController(with type: CategoryViewController.CategoryViewType = .select,
                                    entities: [CategoryEntity] = []) {
        let categoryViewController: CategoryViewController = CategoryViewController(categoryViewType: type)
        categoryViewController.coordinator = self
        categoryViewController.selectedCategory = entities
        navigationController.pushViewController(categoryViewController, animated: true)
    }

    /// PhotosViewController로 이동한다.
    func showPhotosViewController() {
        let photosViewController: PhotosViewController = PhotosViewController()
        photosViewController.coordinator = self
        navigationController.pushViewController(photosViewController, animated: true)
    }
}

final class WriteCoordinator: WriteCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private weak var parentViewController: UITabBarController?

    init(navigationController: UINavigationController,
         parentViewController: UITabBarController?) {
        self.navigationController = navigationController
        self.parentViewController = parentViewController
    }

    func start() {
        showWriteViewController(with: WriteViewModel(pageType: .bought))
    }

    /// WriteViewController로 이동한다.
    /// - Parameter type: PageType에 따라 ViewModel을 생성하기 위해 필요하다.
    func showWriteViewController(with viewModel: WriteViewModel) {
        let writeViewController: WriteViewController = WriteViewController(viewModel: viewModel)
        writeViewController.coordinator = self
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(writeViewController, animated: true)
        parentViewController?.present(navigationController, animated: true)
    }

    /// naviagtionController를 dismiss 한다.
    func dismissWriteViewController() {
        navigationController.dismiss(animated: true) {
            self.navigationController.viewControllers.removeAll()
        }
    }
}
