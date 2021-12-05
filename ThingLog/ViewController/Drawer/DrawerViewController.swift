//
//  DrawerViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/28.
//
import RxSwift
import UIKit

/// 진열장을 보여주는 뷰컨트롤러다
final class DrawerViewController: UIViewController {
    var coordinator: DrawerCoordinator?
    
    // MARK: - View
    let collectionView: UICollectionView = {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: floor(screenWidth / 2) - 2, height: 150)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSize(width: screenWidth, height: 270)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DrawerCollectionCell.self, forCellWithReuseIdentifier: DrawerCollectionCell.reuseIdentifier)
        collectionView.register(DrawerHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: DrawerHeaderView.reuseIdentifier)
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    // MARK: - Properties
    var drawersData: [Drawerable] = []
    var drawerRespository: DrawerRepositoryable = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                                           defaultDrawers: DefaultDrawerModel().drawers)
    /// 네비 X 버튼 누를 경우 다시 되돌리기 위한 대표 진열장 아이템이다.
    var representativeDrawer: Drawerable?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setupNavigationBar()
        setupRightNavigationBarItem()
        setupView()
        
        fetchDrawers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        drawerRespository.completeNewEvent()
    }
    
    // MARK: - Setup
    
    private func setupBackgroundColor() {
        collectionView.backgroundColor = SwiftGenColors.primaryBackground.color
        view.backgroundColor = SwiftGenColors.primaryBackground.color
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        
        let safeLayout: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        setupBaseNavigationBar()
        let logoView: LogoView = LogoView("진열장", font: UIFont.Pretendard.headline4)
        logoView.textAlignment = .center
        navigationItem.titleView = logoView
        
        let backButton: UIButton = UIButton()
        backButton.setImage(SwiftGenIcons.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = SwiftGenColors.primaryBlack.color
        backButton.rx.tap
            .bind { [weak self] in
                // 대표진열장이 변경됐어도 다시 되돌린다.
                self?.drawerRespository.updateRepresentative(drawer: self?.representativeDrawer)
                self?.coordinator?.back()
            }
            .disposed(by: disposeBag)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    private func setupRightNavigationBarItem() {
        let editButton: UIButton = UIButton()
        editButton.setTitle("완료", for: .normal)
        editButton.titleLabel?.font = UIFont.Pretendard.body1
        editButton.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        editButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.back()
            }
            .disposed(by: disposeBag)
        let editBarButton: UIBarButtonItem = UIBarButtonItem(customView: editButton)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 17
        navigationItem.rightBarButtonItems = [fixedSpace, editBarButton]
    }
    
    func fetchDrawers() {
        drawerRespository.fetchDrawers { drawerList in
            guard let drawerList: [Drawerable] = drawerList else { return }
            self.drawersData = drawerList
            self.collectionView.reloadData()
        }
        representativeDrawer = drawerRespository.fetchRepresentative()
    }
}

extension DrawerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        drawersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawerCollectionCell.reuseIdentifier, for: indexPath) as? DrawerCollectionCell else {
            return UICollectionViewCell()
        }
        
        let drawer: Drawerable = drawersData[indexPath.item]
        
        cell.drawerView.hideQuestionImageView(drawer.isAcquired)
        cell.drawerView.hideTitleLabel(!drawer.isAcquired)
        cell.drawerView.hideSubLabel(true)
        cell.drawerView.hideNewBadge(!drawer.isNewDrawer)
        cell.drawerView.setTitleLabel(fontType: UIFont.Pretendard.title2,
                                      color: SwiftGenColors.primaryBlack.color,
                                      text: drawer.title)
        
        guard let imageData: Data = drawer.imageData,
              var drawerImage: UIImage = UIImage(data: imageData) else {
            return UICollectionViewCell()
        }
        if drawer.isAcquired == false {
            drawerImage = drawerImage.withRenderingMode(.alwaysTemplate)
        }
        cell.drawerView.setImage(drawerImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DrawerHeaderView.reuseIdentifier, for: indexPath) as? DrawerHeaderView else {
            return UICollectionReusableView()
        }
        headerView.drawerView.hideQuestionImageView(true)
        
        if let representative: Drawerable = drawerRespository.fetchRepresentative(),
           let imageData: Data = representative.imageData,
           let drawerImage: UIImage = UIImage(data: imageData) {
            headerView.drawerView.setImage(drawerImage)
            headerView.drawerView.setSubLabel(fontType: UIFont.Pretendard.title2,
                                              color: SwiftGenColors.primaryBlack.color,
                                              text: representative.title)
        } else {
            headerView.drawerView.setImage(SwiftGenDrawerList.emptyRepresentative.image.withRenderingMode(.alwaysTemplate))
            headerView.drawerView.setSubLabel(fontType: UIFont.Pretendard.body2,
                                              color: SwiftGenColors.gray2.color,
                                              text: "아직 대표 물건이 없어요!")
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drawer: Drawerable = drawersData[indexPath.item]
        coordinator?.showSelectingDrawerViewController(drawer: drawer)
    }
}
