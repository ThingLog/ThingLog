//
//  CommentViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/14.
//

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
    var commentInputViewBottomConstraint: NSLayoutConstraint?
    var coordinator: Coordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let logoView: LogoView = LogoView("게시물", font: UIFont.Pretendard.headline4)
        navigationItem.titleView = logoView

        let backButton: UIButton = UIButton()
        backButton.setImage(SwiftGenIcons.longArrowR.image, for: .normal)
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
        view.addSubviews(tableView, commentInputView)

        setupTableView()
        setupCommentInputView()
    }

    override func setupBinding() {
        bindKeyboardWillShow()
        bindKeyboardWillHide()
    }
}
