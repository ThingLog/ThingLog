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
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 2) / 3, height: (UIScreen.main.bounds.width - 2) / 3)
        flowLayout.sectionHeadersPinToVisibleBounds = false
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collection.register(TwoLabelVerticalHeaderView.self, forSupplementaryViewOfKind: TwoLabelVerticalHeaderView.reuseIdentifier, withReuseIdentifier: TwoLabelVerticalHeaderView.reuseIdentifier)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    /// 네비게이션 우측 선택 버튼을 클릭시 나타나는  `삭제` 또는 `복구` 버튼이 포함된 뷰다.
    private let deleteButtonView: LeftRightButtonView = {
        let deleteView: LeftRightButtonView = LeftRightButtonView()
        deleteView.clipsToBounds = true
        deleteView.backgroundColor = SwiftGenColors.white.color
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        return deleteView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [collectionView, deleteButtonView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 휴지통에 데이터가 없는 경우에 보여주는 뷰다.
    private var emptyView: EmptyResultsView = {
        let view: EmptyResultsView = EmptyResultsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = SwiftGenColors.white.color
        view.label.text = "휴지통이 비었습니다"
        return view
    }()
    
    // MARK: - Properties
    var fetchResultController: NSFetchedResultsController<PostEntity>? {
        didSet {
            fetchResultController?.delegate = self
        }
    }
    // Test 아이템 개수
    var items: [Int] = Array(repeating: 1, count: 40)
    
    // CoreData가 외부에서 변경될 때 호출하는 클로저다.
    var completionBlock: ((Int) -> Void)?
    
    /// 현재 휴지통에서 복구또는 삭제 기능을 활성화한 상태인지를 확인하기 위한 프로퍼티다. 활성화한 상태는 true이다.
    private var isEditMode: Bool = false
    
    /// 삭제하고자 할 때 잠시 저장해두는 프로퍼티입니다.
    private var deleteStorage: [Int] = [] {
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
        
        subscribeEditButton()
        subscribeDeleteButton()
    }
    
    // MARK: - Setup
    private func setupStackView() {
        view.addSubview(stackView)
        deleteButtonHeightConstraint = deleteButtonView.heightAnchor.constraint(equalToConstant: 0)
        deleteButtonHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBaseCollectionView() {
        collectionView.backgroundColor = SwiftGenColors.white.color
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
        backButton.setImage(SwiftGenAssets.paddingBack.image, for: .normal)
        backButton.tintColor = SwiftGenColors.black.color
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
        editButton.setTitleColor(SwiftGenColors.black.color, for: .normal)
        let editBarButton: UIBarButtonItem = UIBarButtonItem(customView: editButton)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 17
        navigationItem.rightBarButtonItems = [fixedSpace, editBarButton]
    }
    
    /// 네비게이션 바 우측에 있는 버튼의 타이틀을 변경한다.
    private func changeEditButton(isCurrentEditMode: Bool) {
        editButton.setTitle( isCurrentEditMode ? "선택" : "취소", for: .normal)
    }
}

extension TrashViewController {
    /// 네비게이션 바 우측에 있는 버튼을 바인딩한다.
    private func subscribeEditButton() {
        editButton.rx.tap
            .bind { [weak self] in
                self?.changeEditButton(isCurrentEditMode: self?.isEditMode ?? true)
                if self?.isEditMode == true {
                    self?.deleteStorage.removeAll()
                }
                // 하단에 삭제버튼의 높이를 애니메이션 준다.
                UIView.animate(withDuration: 0.3) {
                    self?.deleteButtonHeightConstraint?.constant = (self?.isEditMode == true) ? 0.0 : (self?.deleteButtonViewHeight ?? 0.0)
                    self?.view.layoutIfNeeded()
                }
                
                self?.isEditMode.toggle()
                self?.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    /// 하단의 **삭제 버튼을 바인딩하여, 얼럿뷰를 띄우는 메서드다.
    private func subscribeDeleteButton() {
        deleteButtonView.leftButton.rx.tap
            .bind { [weak self] in
                let alert: AlertViewController = AlertViewController()
                alert.modalPresentationStyle = .overFullScreen
                alert.hideTextField()
                alert.leftButton.setTitle("취소", for: .normal)
                alert.rightButton.setTitle("삭제", for: .normal)
                let text: String = self?.deleteStorage.isEmpty == true ? "전체 게시물 선택" : "\(self?.deleteStorage.count ?? 0)개의 게시물 선택"
                alert.titleLabel.text = text
                alert.changeContentsText("정말 삭제 하시겠어요?\n이 동작은 취소할 수 없습니다")
                
                alert.leftButton.rx.tap.bind {
                    self?.changeEditButton(isCurrentEditMode: true)
                    alert.dismiss(animated: false, completion: nil)
                }
                .disposed(by: alert.disposeBag)
                
                alert.rightButton.rx.tap.bind { [weak self] in
                    // TODO: - ⚠️n개일 때 또는 전체일 때 삭제 로직 변경
                    self?.items.removeAll()
                    self?.emptyView.isHidden = false
                    self?.changeEditButton(isCurrentEditMode: true)
                    alert.dismiss(animated: false, completion: nil)
                }
                .disposed(by: alert.disposeBag)
                
                self?.present(alert, animated: false)
            }
            .disposed(by: disposeBag)
    }
}

extension TrashViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //                let numberOfItems: Int = fetchResultController?.fetchedObjects?.count ?? 0
        //                emptyView.isHidden = numberOfItems != 0
        //                return numberOfItems
        return items.count  // Test Code
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ContentsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath)as? ContentsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let item: PostEntity = fetchResultController?.fetchedObjects?[indexPath.item],
           let data: Data = (item.attachments?.allObjects as? [AttachmentEntity])?.first?.thumbnail {
            cell.updateView(item)
        }
        
        // 휴지통에서 사용할 경우, ContentsCollectionViewCell의 뷰를 약간 조정한다.
        cell.setupForTrashView()
        cell.checkButton.isHidden = !isEditMode
        if isEditMode {
            if deleteStorage.contains(indexPath.item) {
                cell.changeCheckButton(isSelected: true)
            } else {
                cell.changeCheckButton(isSelected: false)
            }
        }
        
        cell.backgroundColor = .systemGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: TwoLabelVerticalHeaderView.reuseIdentifier, withReuseIdentifier: TwoLabelVerticalHeaderView.reuseIdentifier, for: indexPath) as? TwoLabelVerticalHeaderView else {
            return UICollectionReusableView()
        }
        return headerView
    }
}

extension TrashViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditMode {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ContentsCollectionViewCell else { return }
            
            if let index: Int = deleteStorage.firstIndex(of: indexPath.item) {
                deleteStorage.remove(at: index)
                cell.changeCheckButton(isSelected: false)
            } else {
                deleteStorage.append(indexPath.item)
                cell.changeCheckButton(isSelected: true)
            }

            var deleteStorageCount: String = String(deleteStorage.count)
            if deleteStorageCount == "0" {
                deleteStorageCount = ""
            }
            editButton.setTitle(deleteStorageCount + " 취소", for: .normal)
            editButton.sizeToFit()
        }
    }
}

extension TrashViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
        completionBlock?(controller.fetchedObjects?.count ?? 0)
    }
}
