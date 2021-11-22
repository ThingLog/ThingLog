//
//  PostViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/09.
//

import CoreData
import UIKit

/// 게시물을 표시하는 뷰 컨트롤러
final class PostViewController: BaseViewController {
    // MARK: - View Properties
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    // MARK: - Properties
    var coordinator: PostCoordinatorProtocol?
    private(set) var viewModel: PostViewModel

    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchedResultsController.delegate = self
        viewModel.fetchedResultsControllerDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let startIndexPath: IndexPath = IndexPath(row: viewModel.startIndexPath.row, section: 0)
        tableView.scrollToRow(at: startIndexPath, at: .top, animated: false)
    }

    // MARK: - Setup
    override func setupNavigationBar() {
        setupBaseNavigationBar()

        let logoView: LogoView = LogoView("게시물")
        navigationItem.titleView = logoView

        let backButton: UIButton = UIButton()
        backButton.setImage(SwiftGenIcons.longArrowR.image.withTintColor(SwiftGenColors.primaryBlack.color), for: .normal)
        backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.back()
            }
            .disposed(by: disposeBag)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }

    override func setupView() {
        setupTableView()
    }

    // MARK: - Public
    func showRemovePostAlert(post: PostEntity) {
        let alert: AlertViewController = AlertViewController()
        alert.hideTextField()
        alert.hideTitleLabel()
        alert.contentsLabel.text = "게시물을 정말 삭제하시겠어요?"
        alert.leftButton.setTitle("취소", for: .normal)
        alert.rightButton.setTitle("삭제", for: .normal)
        alert.modalPresentationStyle = .overFullScreen
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)

        alert.rightButton.rx.tap.bind { [weak self] in
            self?.viewModel.delete(post)
            alert.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)

        present(alert, animated: false, completion: nil)
    }
}

extension PostViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()

        // 만약 표시할 수 있는 데이터가 없다면 이전 화면으로 이동한다.
        if viewModel.fetchedResultsController.fetchedObjects?.count ?? 0 == 0 {
            coordinator?.back()
        }
    }
}
