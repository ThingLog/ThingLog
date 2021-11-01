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
final class WriteViewController: BaseViewController {
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
        /* iOS 15.0 에서 tableFooterView 에 생기는 separator 제거 코드
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
         */
        return tableView
    }()

    let doneButton: CenterTextButton = {
        let button: CenterTextButton = CenterTextButton(buttonHeight: 54.0, title: "작성 완료")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties
    var coordinator: WriteCoordinator?
    var selectedImages: [UIImage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private(set) var viewModel: WriteViewModel

    init(viewModel: WriteViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = SwiftGenColors.white.color
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        doneButton.heightAnchor.constraint(equalToConstant: doneButton.frame.height + view.safeAreaInsets.bottom).isActive = true
        doneButton.titleEdgeInsets = UIEdgeInsets(top: -view.safeAreaInsets.bottom, left: 0, bottom: 0, right: 0)
    }

    override func setupNavigationBar() {
        setupBaseNavigationBar()

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

    override func setupView() {
        view.addSubview(tableView)
        view.addSubview(doneButton)

        setupTableView()
        setupDoneButton()
    }

    override func setupBinding() {
        bindKeyboardWillShow()
        bindKeyboardWillHide()
        bindNotificationPassSelectPHAssets()
    }
}

extension WriteViewController {
    @objc
    /// 글쓰기 화면을 닫는다.
    /// 글쓰기 화면을 닫기 전에 alert 팝업을 띄워 다시 한 번 사용자에게 묻는다.
    /// 글쓰기 화면을 닫으면서 navigationController.viewControllers를 초기화한다.
    func close() {
        let alertController: AlertViewController = AlertViewController()

        alertController.hideTitleLabel()
        alertController.changeContentsText("글이 저장되지 않고 삭제됩니다.\n나가시겠어요?")
        alertController.hideTextField()
        alertController.leftButton.setTitle("아니요", for: .normal)
        alertController.rightButton.setTitle("네", for: .normal)

        alertController.leftButton.rx.tap.bind {
            alertController.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)

        alertController.rightButton.rx.tap.bind { [weak self] in
            alertController.dismiss(animated: false) {
                self?.coordinator?.dismissWriteViewController()
            }
        }.disposed(by: disposeBag)

        alertController.modalPresentationStyle = .overFullScreen
        present(alertController, animated: false, completion: nil)
    }

    /// indexPath.row의 위치로 이동한다.
    /// - Parameter indexPath: 이동하려는 셀의 IndexPath
    func scrollToCurrentRow(at indexPath: IndexPath) {
        if indexPath.section == WriteViewModel.Section.type.rawValue {
            let rowRect: CGRect = tableView.rectForRow(at: indexPath)
            UIView.animate(withDuration: 0.3) {
                self.tableView.scrollRectToVisible(rowRect, animated: false)
            }
        } else if indexPath.section == WriteViewModel.Section.contents.rawValue {
            let bottomOffset: CGPoint = CGPoint(x: 0,
                                                y: tableView.contentSize.height - tableView.bounds.height + tableView.contentInset.bottom)
            UIView.animate(withDuration: 0.3) {
                self.tableView.setContentOffset(bottomOffset, animated: false)
            }
        }
    }
}

// MARK: - DataSource
extension WriteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        WriteViewModel.Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemCount[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section: WriteViewModel.Section? = .init(rawValue: indexPath.section)

        switch section {
        case .image:
            guard let cell: WriteImageTableCell = tableView.dequeueReusableCell(withIdentifier: WriteImageTableCell.reuseIdentifier, for: indexPath) as? WriteImageTableCell else {
                return UITableViewCell()
            }

            cell.coordinator = coordinator
            cell.thumbnailImages = selectedImages

            return cell
        case .category:
            guard let cell: WriteCategoryTableCell = tableView.dequeueReusableCell(withIdentifier: WriteCategoryTableCell.reuseIdentifier, for: indexPath) as? WriteCategoryTableCell else {
                return UITableViewCell()
            }
            return cell
        case .type:
            guard let cell: WriteTextFieldCell = tableView.dequeueReusableCell(withIdentifier: WriteTextFieldCell.reuseIdentifier, for: indexPath) as? WriteTextFieldCell else {
                return WriteTextFieldCell()
            }

            cell.keyboardType = viewModel.typeInfo[indexPath.row].keyboardType
            cell.placeholder = viewModel.typeInfo[indexPath.row].placeholder

            cell.isEditingSubject
                .bind { [weak self] _ in
                    self?.scrollToCurrentRow(at: indexPath)
                }.disposed(by: cell.disposeBag)

            return cell
        case .rating:
            guard let cell: WriteRatingCell = tableView.dequeueReusableCell(withIdentifier: WriteRatingCell.reuseIdentifier, for: indexPath) as? WriteRatingCell else {
                return WriteRatingCell()
            }

            cell.selectRatingBlock = { [weak self] in
                self?.view.endEditing(true)
            }

            return cell
        case .contents:
            guard let cell: WriteTextViewCell = tableView.dequeueReusableCell(withIdentifier: WriteTextViewCell.reuseIdentifier, for: indexPath) as? WriteTextViewCell else {
                return WriteTextViewCell()
            }

            cell.delegate = self
            cell.textView.rx.didBeginEditing
                .bind { [weak self] in
                    self?.scrollToCurrentRow(at: indexPath)
                }.disposed(by: cell.disposeBag)

            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Delegate
extension WriteViewController: WriteTextViewCellDelegate {
    func updateTextViewHeight() {
        DispatchQueue.main.async { [weak tableView] in
            tableView?.beginUpdates()
            tableView?.endUpdates()
        }
    }
}
