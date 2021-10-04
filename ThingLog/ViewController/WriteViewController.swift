//
//  WriteViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import UIKit

import RxCocoa
import RxSwift

/// 글쓰기 화면(샀다, 사고싶다, 선물받았다)를 담당하는 ViewController
final class WriteViewController: UIViewController {
    // MARK: - Properties
    var coordinator: Coordinator?
    var viewModel: WriteViewModel?
    let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color

        setupNavigationBar()
        setupTestView()
    }

    @objc
    /// 글쓰기 화면을 닫는다.
    /// 글쓰기 화면을 닫기 전에 alert 팝업을 띄워 다시 한 번 사용자에게 묻는다.
    /// 글쓰기 화면을 닫으면서 navigationController.viewControllers를 초기화한다.
    func close() {
        let alertController: UIAlertController = UIAlertController(title: "Title Here",
                                                                   message: "Alert description",
                                                                   preferredStyle: .alert)

        let cancleAction: UIAlertAction = UIAlertAction(title: "cancle",
                                                        style: .cancel,
                                                        handler: nil)
        let saveAction: UIAlertAction = UIAlertAction(title: "save",
                                                      style: .default,
                                                      handler: { [weak self] _ in
            self?.navigationController?.dismiss(animated: true, completion: {
                self?.navigationController?.viewControllers.removeAll()
            })
        })

        alertController.addAction(cancleAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
}
