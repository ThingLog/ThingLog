//
//  BaseViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
    // MARK: - Rx
    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode()
        view.backgroundColor = SwiftGenColors.primaryBackground.color

        setupNavigationBar()
        setupView()
        setupBinding()
    }

    @objc
    func setupNavigationBar() {
        // Override setupNavigationBar
    }

    @objc
    func setupView() {
        // Override setupView
    }

    @objc
    func setupBinding() {
        // Override setupBinding
    }
}
