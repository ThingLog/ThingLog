//
//  WriteCoordinator.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import UIKit

final class WriteCoordinator: SystemSettingCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private weak var parentViewController: UITabBarController?

    init(navigationController: UINavigationController,
         parentViewController: UITabBarController?) {
        self.navigationController = navigationController
        self.parentViewController = parentViewController
    }

    func start() {
        showWriteViewController(with: .bought)
    }

    /// WriteViewController로 이동한다.
    /// - Parameter type: PageType에 따라 ViewModel을 생성하기 위해 필요하다.
    func showWriteViewController(with type: PageType) {
        let viewModel: WriteViewModel = WriteViewModel(pageType: type)
        let writeViewController: WriteViewController = WriteViewController(viewModel: viewModel)
        writeViewController.coordinator = self
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(writeViewController, animated: true)
        parentViewController?.present(navigationController, animated: true)
    }

    /// CategoryViewController로 이동한다.
    func showCategoryViewController() {
        let categoryViewController: CategoryViewController = CategoryViewController()
        categoryViewController.coordinator = self
        navigationController.pushViewController(categoryViewController, animated: true)
    }

    /// PhotosViewController로 이동한다.
    func showPhotosViewController() {
        let photosViewController: PhotosViewController = PhotosViewController()
        photosViewController.coordinator = self
        navigationController.pushViewController(photosViewController, animated: true)
    }

    /// naviagtionController를 dismiss 한다.
    func dismissWriteViewController() {
        navigationController.dismiss(animated: true) {
            self.navigationController.viewControllers.removeAll()
        }
    }

    /// 뒤로 이동한다.
    func back() {
        navigationController.popViewController(animated: true)
    }
}
