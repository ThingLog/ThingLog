//
//  WriteViewController+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import UIKit

extension WriteViewController {
    /// WriteType 값이 넘어왔는 지 확인하기 위한 뷰를 구성하는 메서드.
    /// 이후 화면 구성에서 삭제할 예정
    func setupTestView() {
        guard let viewModel = viewModel else {
            return
        }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(viewModel.writeType)"
        label.textColor = SwiftGenColors.black.color

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupNavigationBar() {
        if #available(iOS 15, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = SwiftGenColors.white.color
            appearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = SwiftGenColors.white.color
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }

        let logoView: LogoView = LogoView("글쓰기")
        navigationItem.titleView = logoView

        let closeButton: UIButton = {
            let button: UIButton = UIButton()
            button.setTitle("닫기", for: .normal)
            button.setTitleColor(SwiftGenColors.black.color, for: .normal)
            button.titleLabel?.font = UIFont.Pretendard.body1
            return button
        }()

        closeButton.rx.tap.bind { [weak self] in
            self?.close()
        }.disposed(by: disposeBag)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
}
