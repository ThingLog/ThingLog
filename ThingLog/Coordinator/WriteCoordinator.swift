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
    func showWriteViewController(with type: PageType) {
        let viewModel: WriteViewModel = WriteViewModel(writeType: type)
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

    /// 사용자에게 사진 접근 권한이 없음을 알리고, 앱 설정으로 이동하는 버튼을 제공하는 Alert을 띄운다.
    ///
    /// 이 메서드를 호출하는 `WriteImageTableCell` 에서는 ViewController를 present 할 수 없기 때문에 coordinator에서 처리한다.
    func showMoveSettingAlert() {
        let alert: UIAlertController = UIAlertController(title: "",
                                                         message: "사진 접근 권한이 없습니다.\n설정 > 개인정보 보호 > 사진에서\n권한을 추가하세요.",
                                                         preferredStyle: .alert)
        let cancleAction: UIAlertAction = UIAlertAction(title: "취소",
                                                        style: .cancel,
                                                        handler: nil)
        let settingAction: UIAlertAction = UIAlertAction(title: "설정",
                                                         style: .default,
                                                         handler: { [weak self] _ in
            self?.moveAppSetting()
        })

        alert.addAction(cancleAction)
        alert.addAction(settingAction)
        navigationController.present(alert, animated: true, completion: nil)
    }

    /// 앱 설정 화면으로 이동한다.
    func moveAppSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
