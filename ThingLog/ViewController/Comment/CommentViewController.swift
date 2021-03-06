//
//  CommentViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/14.
//

import CoreData
import UIKit

/// 게시물 > 댓글 화면을 나타내는 뷰 컨트롤러
final class CommentViewController: BaseViewController {
    // MARK: - View Properties
    /// 게시물 본문, 댓글 목록을 표시하는 테이블 뷰
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = SwiftGenColors.primaryBackground.color
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()

    /// 댓글 입력하는 뷰
    let commentInputView: TextViewWithSideButtonsView = {
        let view: TextViewWithSideButtonsView = TextViewWithSideButtonsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.white.color
        return view
    }()

    // MARK: - Properties
    var tableViewBottomConstraint: NSLayoutConstraint?
    var tableViewBottomSafeAnchorConstraint: NSLayoutConstraint?
    var commentInputViewBottomConstraint: NSLayoutConstraint?
    var coordinator: Coordinator?
    var viewModel: CommentViewModel

    // MARK: - Init
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.repository.fetchedResultsController.delegate = self
    }

    // MARK: - Setup
    override func setupNavigationBar() {
        super.setupNavigationBar()

        let logoView: LogoView = LogoView("게시물", font: UIFont.Pretendard.headline4)
        navigationItem.titleView = logoView

        let backButton: UIButton = UIButton()
        backButton.setImage(SwiftGenIcons.longArrowR.image.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = SwiftGenColors.primaryBlack.color
        backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.back()
            }
            .disposed(by: disposeBag)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }

    override func setupView() {
        view.backgroundColor = SwiftGenColors.white.color
        view.addSubviews(tableView, commentInputView)

        setupTableView()
        setupCommentInputView()
    }

    override func setupBinding() {
        bindKeyboardWillShow()
        bindKeyboardWillHide()
        bindCommentInputView()
    }

    // MARK: - Public
    /// 댓글 편집 모드 여부에 따라 CommentInputView를 숨김/표시한다.
    func hideCommentInputView(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.commentInputView.isHidden = bool
            self?.tableViewBottomConstraint?.isActive = !bool
            self?.tableViewBottomSafeAnchorConstraint?.isActive = bool
        }
    }

    /// 댓글을 삭제하기 전에 사용자에게 경고 알럿을 띄운다.
    func showRemoveCommentAlert(at index: Int) {
        let alert: AlertViewController = AlertViewController()
        alert.hideTextField()
        alert.hideTitleLabel()
        alert.contentsLabel.text = "댓글을 정말 삭제하시겠어요?"
        alert.leftButton.setTitle("아니요", for: .normal)
        alert.rightButton.setTitle("네", for: .normal)
        alert.modalPresentationStyle = .overFullScreen
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)

        alert.rightButton.rx.tap.bind { [weak self] in
            self?.viewModel.removeComment(at: index)
            alert.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)

        present(alert, animated: false, completion: nil)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CommentViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
