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
    lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = SwiftGenColors.primaryBackground.color
        
        let headerLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 29.0))
        headerLabel.font = UIFont.Pretendard.body2
        headerLabel.textColor = SwiftGenColors.gray2.color
        headerLabel.text = viewModel.createDate
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

    lazy var doneButton: RoundCenterTextButton = {
        let button: RoundCenterTextButton = RoundCenterTextButton(cornerRadius: doneButtonHeight / 2)
        button.setTitle("작성완료", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    let doneButtonHeight: CGFloat = 52.0
    var coordinator: WriteCoordinatorProtocol?
    private(set) var viewModel: WriteViewModel

    // MARK: - Init
    init(viewModel: WriteViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 게시물 수정일 때 썸네일과 카테고리가 제대로 표시되지 않는 문제를 해결하기 위해 해당 섹션만 별도로 reload
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewModel.modifyEntity != nil {
            let imageSection: Int = WriteViewModel.Section.image.rawValue
            let categorySection: Int = WriteViewModel.Section.category.rawValue
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: [IndexPath(row: 0, section: imageSection)],
                                     with: .none)
                tableView.reloadRows(at: [IndexPath(row: 0, section: categorySection)],
                                     with: .none)
            }
        }
    }

    // MARK: - Setup
    override func setupNavigationBar() {
        setupBaseNavigationBar()
        
        let logoView: LogoView = LogoView("글쓰기")
        navigationItem.titleView = logoView
        
        let closeButton: UIButton = {
            let button: UIButton = UIButton()
            button.setTitle("닫기", for: .normal)
            button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
            button.titleLabel?.font = UIFont.Pretendard.body1
            return button
        }()
        
        closeButton.rx.tap.bind { [weak self] in
            self?.closeWithAlert()
        }.disposed(by: disposeBag)

        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    override func setupView() {
        view.addSubviews(tableView, doneButton)
        
        setupTableView()
        setupDoneButton()
    }
    
    override func setupBinding() {
        bindKeyboardWillShow()
        bindKeyboardWillHide()
        bindDoneButton()
        bindThumbnailSubjectUpdate()
        bindCategorySubject()
    }
}

extension WriteViewController {
    @objc
    /// 글쓰기 화면을 닫는다.
    /// 글쓰기 화면을 닫기 전에 alert 팝업을 띄워 다시 한 번 사용자에게 묻는다.
    /// 글쓰기 화면을 닫으면서 navigationController.viewControllers를 초기화한다.
    func closeWithAlert() {
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

    /// 필수 항목(사진 선택)이 누락되었을 때 사용자에게 안내 알럿을 띄운다.
    func showRequiredAlert() {
        let alertController: AlertViewController = AlertViewController()

        alertController.hideTitleLabel()
        alertController.changeContentsText("사진은 필수 입력 항목이에요")
        alertController.hideTextField()
        alertController.hideRightButton()
        alertController.leftButton.setTitle("확인", for: .normal)

        alertController.leftButton.rx.tap.bind {
            alertController.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)
        alertController.modalPresentationStyle = .overFullScreen
        present(alertController, animated: false, completion: nil)
    }

    /// 글 작성을 완료하고 이전 화면으로 돌아간다.
    func close() {
        coordinator?.dismissWriteViewController()
    }
    
    /// indexPath.row의 위치로 이동한다.
    /// - Parameter indexPath: 이동하려는 셀의 IndexPath
    func scrollToCurrentRow(at indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

// MARK: - TableView Delegate
extension WriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == WriteViewModel.Section.category.rawValue {
            guard let categories: [Category] = try? viewModel.categorySubject.value() else {
                return
            }

            let entities: [CategoryEntity] = categories.map { $0.toEntity(in: CoreDataStack.shared.mainContext) }
            coordinator?.showCategoryViewController(entities: entities)
        }
    }
}

// MARK: - Delegate
extension WriteViewController: TextViewCellDelegate {
    func updateTextViewHeight() {
        DispatchQueue.main.async { [weak tableView] in
            tableView?.beginUpdates()
            tableView?.endUpdates()
        }
    }
}
