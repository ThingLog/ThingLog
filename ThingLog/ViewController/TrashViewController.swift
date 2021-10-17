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
    
    /// 네비게이션 우측 선택 버튼을 클릭시 나타나는  **삭제 또는 **복구 버튼이 포함된 뷰다.
    private let deleteButtonView: LeftRightButtonView = {
        let deleteView: LeftRightButtonView = LeftRightButtonView()
        deleteView.isHidden = true
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
    // CoreData가 외부에서 변경될 때 호출하는 클로저다.
    var completionBlock: ((Int) -> Void)?
    
    /// 현재 휴지통에서 복구또는 삭제 기능을 활성화한 상태인지를 확인하기 위한 프로퍼티다. 활성화한 상태는 true이다.
    private var isEditMode: Bool = false
    
    private let deleteButtonViewHeight: CGFloat = 54
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupBaseCollectionView()
        setupEmptyView()
        setupNavigationBar()
        setupRightNavigationBarItem()
    }
    
    // MARK: - Setup
    private func setupStackView() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            deleteButtonView.heightAnchor.constraint(equalToConstant: deleteButtonViewHeight)
        ])
    }
    private func setupBaseCollectionView() {
        collectionView.backgroundColor = SwiftGenColors.white.color
        collectionView.dataSource = self
    }
    
    private func setupEmptyView() {
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        setupBaseNavigationBar()
        
        let logoView: LogoView = LogoView("휴지통", font: UIFont.Pretendard.headline4)
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
    
    func setupRightNavigationBarItem() {
        let editButton: UIButton = UIButton()
        editButton.setTitle("선택", for: .normal)
        editButton.titleLabel?.font = UIFont.Pretendard.body1
        editButton.setTitleColor(SwiftGenColors.black.color, for: .normal)
        editButton.rx.tap
            .bind { [weak self] in
                editButton.setTitle( (self?.isEditMode == true) ? "선택" : "취소", for: .normal)
                self?.deleteButtonView.isHidden = self?.isEditMode == true
                self?.isEditMode.toggle()
                self?.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        let editBarButton: UIBarButtonItem = UIBarButtonItem(customView: editButton)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 24
        navigationItem.rightBarButtonItems = [fixedSpace, editBarButton]
    }
}

extension TrashViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//                let numberOfItems: Int = fetchResultController?.fetchedObjects?.count ?? 0
//                emptyView.isHidden = numberOfItems != 0
//                return numberOfItems
        return 15 // Test Code
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

extension TrashViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
        completionBlock?(controller.fetchedObjects?.count ?? 0)
    }
}
