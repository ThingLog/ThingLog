//
//  WriteCoordinator.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import UIKit

final class WriteCoordinator: Coordinator {
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
    /// - Parameter type: WriteType에 따라 ViewModel을 생성하기 위해 필요하다.
    func showWriteViewController(with type: WriteType) {
        let writeViewController: WriteViewController = WriteViewController()
        writeViewController.coordinator = self
        writeViewController.viewModel = WriteViewModel(writeType: type)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(writeViewController, animated: true)
        parentViewController?.present(navigationController, animated: true)
    }
}
