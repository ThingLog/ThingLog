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
    // MARK: - View Properties
    let tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let headerLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 29.0))
        headerLabel.font = UIFont.Pretendard.body2
        headerLabel.textColor = SwiftGenColors.gray3.color
        headerLabel.text = "\(Date().toString(.year))년 \(Date().toString(.month))월 \(Date().toString(.day))일"
        headerLabel.textAlignment = .center

        tableView.tableHeaderView = headerLabel
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    let doneButton: CenterTextButton = {
        let button: CenterTextButton = CenterTextButton(buttonHeight: 54.0, title: "작성 완료")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties
    var coordinator: Coordinator?
    var viewModel: WriteViewModel?
    let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color

        setupNavigationBar()
        setupView()
        setupBind()
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

// MARK: - DataSource
extension WriteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        WriteViewModel.Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.itemCount[section] ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section: WriteViewModel.Section? = .init(rawValue: indexPath.section)

        switch section {
        case .image:
            guard let cell: WriteImageTableCell = tableView.dequeueReusableCell(withIdentifier: WriteImageTableCell.reuseIdentifier, for: indexPath) as? WriteImageTableCell else {
                return UITableViewCell()
            }

            return cell
        case .type:
            guard let cell: WriteTextFieldCell = tableView.dequeueReusableCell(withIdentifier: WriteTextFieldCell.reuseIdentifier, for: indexPath) as? WriteTextFieldCell else {
                return WriteTextFieldCell()
            }

            cell.keyboardType = viewModel?.typeInfo[indexPath.row].keyboardType ?? .default
            cell.placeholder = viewModel?.typeInfo[indexPath.row].placeholder

            return cell
        case .rating:
            guard let cell: WriteRatingCell = tableView.dequeueReusableCell(withIdentifier: WriteRatingCell.reuseIdentifier, for: indexPath) as? WriteRatingCell else {
                return WriteRatingCell()
            }
            return cell
        case .free:
            guard let cell: WriteTextViewCell = tableView.dequeueReusableCell(withIdentifier: WriteTextViewCell.reuseIdentifier, for: indexPath) as? WriteTextViewCell else {
                return WriteTextViewCell()
            }

            cell.delegate = self

            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Delegate
extension WriteViewController: WriteTextViewCellDelegate, UITextViewDelegate {
    func updateTextViewHeight(_ cell: WriteTextViewCell, _ textView: UITextView) {
        DispatchQueue.main.async { [weak tableView] in
            tableView?.beginUpdates()
            tableView?.endUpdates()
        }
    }
}
