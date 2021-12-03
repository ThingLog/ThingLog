//
//  TrashViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/14.
//
import CoreData
import RxSwift
import UIKit

/// 휴지통 화면을 구성하는 뷰컨트롤러이다.
final class TrashViewController: UIViewController {
    var coordinator: SettingCoordinator?
    
    /// 네비게이션바 우측에 있는 선택or취소 버튼이다
    let editButton: UIButton = UIButton()
    
    let topBorderLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 2) / 3, height: (UIScreen.main.bounds.width - 2) / 3)
        flowLayout.sectionHeadersPinToVisibleBounds = false
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collection.register(TwoLabelVerticalHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TwoLabelVerticalHeaderView.reuseIdentifier)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    /// 네비게이션 우측 선택 버튼을 클릭시 나타나는  `삭제` 또는 `복구` 버튼이 포함된 뷰다.
    private let deleteButtonView: LeftRightButtonView = {
        let deleteView: LeftRightButtonView = LeftRightButtonView()
        deleteView.clipsToBounds = true
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        return deleteView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
                                                    collectionView,
                                                    deleteButtonView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 휴지통에 데이터가 없는 경우에 보여주는 뷰다.
    var emptyView: EmptyResultsView = {
        let view: EmptyResultsView = EmptyResultsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.label.text = "휴지통이 비었습니다"
        return view
    }()
    
    // MARK: - Properties
    var fetchResultController: NSFetchedResultsController<PostEntity>?

    // CoreData가 외부에서 변경될 때 호출하는 클로저다.
    var completionBlock: ((Int) -> Void)?
    
    /// 현재 휴지통에서 복구또는 삭제 기능을 활성화한 상태인지를 확인하기 위한 프로퍼티다. 활성화한 상태는 true이다.
    var isEditMode: Bool = false
    
    /// 삭제하고자 할 때 잠시 저장해두는 프로퍼티입니다.
    var deleteStorage: [Int] = [] {
        didSet {
            deleteButtonView.leftButton.setTitle(deleteStorage.isEmpty ? "모두 삭제" : "삭제", for: .normal)
            deleteButtonView.rightButton.setTitle(deleteStorage.isEmpty ? "모두 복구" : "복구", for: .normal)
        }
    }
    
    /// 하단의 세이프에리아를 포함한 높이를 반환한다.
    private var deleteButtonViewHeight: CGFloat {
        let window: UIWindow? = UIApplication.shared.windows.first
        let bottomPadding: CGFloat = window?.safeAreaInsets.bottom ?? 00
        return bottomPadding + 54
    }
    
    private var deleteButtonHeightConstraint: NSLayoutConstraint?
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupBaseCollectionView()
        setupEmptyView()
        setupNavigationBar()
        setupRightNavigationBarItem()
        setupBackgroundColor()
        
        subscribeEditButton()
        subscribeDeleteButton()
        subscribeReceoveryButton()
        
        fetchTrashPosts()
    }
    
    // MARK: - Setup
    private func setupBackgroundColor() {
        collectionView.backgroundColor = SwiftGenColors.primaryBackground.color
        emptyView.backgroundColor = SwiftGenColors.primaryBackground.color
        deleteButtonView.backgroundColor = SwiftGenColors.primaryBackground.color
        topBorderLineView.backgroundColor = SwiftGenColors.gray4.color
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        view.addSubview(topBorderLineView)
        
        deleteButtonHeightConstraint = deleteButtonView.heightAnchor.constraint(equalToConstant: 0)
        deleteButtonHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            topBorderLineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBorderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            topBorderLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBorderLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topBorderLineView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBaseCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupEmptyView() {
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        setupBaseNavigationBar()
        let logoView: LogoView = LogoView("휴지통", font: UIFont.Pretendard.headline4)
        logoView.textAlignment = .center
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
    
    private func setupRightNavigationBarItem() {
        editButton.setTitle("선택", for: .normal)
        editButton.titleLabel?.font = UIFont.Pretendard.body1
        editButton.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        let editBarButton: UIBarButtonItem = UIBarButtonItem(customView: editButton)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 17
        navigationItem.rightBarButtonItems = [fixedSpace, editBarButton]
    }
}

// MARK: - Subscribe
extension TrashViewController {
    /// 네비게이션 바 우측에 있는 버튼을 바인딩한다.
    private func subscribeEditButton() {
        editButton.rx.tap
            .bind { [weak self] in
                self?.changeEditButton(isCurrentEditMode: self?.isEditMode ?? true)
                // 하단에 삭제버튼의 높이를 애니메이션 준다.
                self?.hideDeleteButton(self?.isEditMode ?? true)
            }
            .disposed(by: disposeBag)
    }
    
    /// 하단의 **삭제 버튼을 바인딩하여, 얼럿뷰를 띄우는 메서드다.
    private func subscribeDeleteButton() {
        deleteButtonView.leftButton.rx.tap
            .bind { [weak self] in
                self?.showDeletingAlert()
            }
            .disposed(by: disposeBag)
    }
    
    /// 복구하는 버튼을 subscribe한다.
    private func subscribeReceoveryButton() {
        deleteButtonView.rightButton.rx.tap.bind { [weak self] in
            self?.recoverTrashData { success in
                self?.changeEditButton(isCurrentEditMode: true)
                self?.hideDeleteButton(true)
                if success == false {
                    self?.showWarningAlert()
                }
            }
        }.disposed(by: disposeBag)
    }
}

// MARK: - Logic
extension TrashViewController {
    private func recoverTrashData(_ completion: @escaping (Bool) -> Void) {
        let preparedData: [PostEntity] = self.prepareData()
        PostRepository(fetchedResultsControllerDelegate: nil).recover(preparedData) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    private func deleteTrashData(_ completion: @escaping (Bool) -> Void) {
        let preparedData: [PostEntity] = prepareData()
        PostRepository(fetchedResultsControllerDelegate: nil).delete(preparedData) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    /// 하단 삭제또는 복구버튼을 숨기거나 나타내도록 한다.
    private func hideDeleteButton(_ bool: Bool, _ completion: (() -> Void)? = nil) {
        // 하단에 삭제버튼의 높이를 애니메이션 준다.
        UIView.animate(withDuration: 0.3) {
            self.deleteButtonHeightConstraint?.constant = bool ? 0.0 : (self.deleteButtonViewHeight)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.deleteStorage.removeAll()
            self.isEditMode.toggle()
            self.fetchTrashPosts()
            completion?()
        }
    }
    
    /// 삭제 또는 복구하기 위해, 저장한 deleteStorage를 기반으로 PostEntity들을 만들어낸다.
    func prepareData() -> [PostEntity] {
        var postEntities: [PostEntity] = []
        if deleteStorage.isEmpty {
            postEntities = fetchResultController?.fetchedObjects ?? []
        } else {
            postEntities = deleteStorage.compactMap {
                fetchResultController?.fetchedObjects?[$0]
            }
        }
        return postEntities
    }
    
    private func fetchTrashPosts() {
        let postRepo: PostRepository = PostRepository(fetchedResultsControllerDelegate: self)
        fetchResultController = postRepo.fetchResultsController(by: .fromTrash)
        collectionView.reloadData()
    }
    
    /// 네비게이션 바 우측에 있는 버튼의 타이틀을 변경한다.
    private func changeEditButton(isCurrentEditMode: Bool) {
        editButton.setTitle( isCurrentEditMode ? "선택" : "취소", for: .normal)
    }
    
    /// 삭제 또는 복구 얼럿을 띄우도록 한다
    func showDeletingAlert() {
        let alert: AlertViewController = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.hideTextField()
        alert.leftButton.setTitle("취소", for: .normal)
        alert.rightButton.setTitle("삭제", for: .normal)
        let text: String = self.deleteStorage.isEmpty == true ? "전체 게시물 선택" : "\(self.deleteStorage.count)개의 게시물 선택"
        alert.titleLabel.text = text
        alert.changeContentsText("정말 삭제 하시겠어요?\n이 동작은 취소할 수 없습니다")
        
        // 취소버튼
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }
        .disposed(by: alert.disposeBag)
        
        // 삭제버튼
        alert.rightButton.rx.tap.bind { [weak self] in
            self?.deleteTrashData { success in
                self?.changeEditButton(isCurrentEditMode: true)
                self?.hideDeleteButton(true) {
                    alert.dismiss(animated: false) {
                        if success == false {
                            self?.showWarningAlert()
                        }
                    }
                }
            }
        }
        .disposed(by: alert.disposeBag)
        self.present(alert, animated: false)
    }
    
    /// 삭제나 오류가 실패했을 때 보여주는 얼럿이다.
    func showWarningAlert() {
        let alert: AlertViewController = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.hideTextField()
        alert.hideRightButton()
        alert.hideTitleLabel()
        alert.leftButton.setTitle("확인", for: .normal)
        alert.changeContentsText("오류가 발생했습니다. \n다시 시도해주세요")
        
        // 취소버튼
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }
        .disposed(by: alert.disposeBag)
        self.present(alert, animated: false)
    }
}

extension TrashViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}
