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
    let drawerView: ImageWithTwoLabellVerticalCetnerXView = {
        let drawerView: ImageWithTwoLabellVerticalCetnerXView = ImageWithTwoLabellVerticalCetnerXView(imageViewHeight: 100)
        drawerView.translatesAutoresizingMaskIntoConstraints = false
        drawerView.hideQuestionImageView(true)
        drawerView.setSubLabel(fontType: UIFont.Pretendard.body2,
                               color: SwiftGenColors.gray3.color,
                               text: "아직 대표 물건이 없어용!")
        return drawerView
    }()
    
    private let borderView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray4.color
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: floor(UIScreen.main.bounds.width / 2) - 2, height: 150)
        flowLayout.minimumInteritemSpacing = 0
        print(UIScreen.main.bounds.width, flowLayout.itemSize.width)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = SwiftGenColors.white.color
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DrawerCollectionCell.self, forCellWithReuseIdentifier: DrawerCollectionCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Properties
    private let drawerViewTopPadding: CGFloat = 40
    private let borderViewTopPadding: CGFloat = 36
    private let padding: CGFloat = 20
    
    // TODO: - ⚠️ 실제 데이터로 이용 예정
    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupNavigationBar()
        setupRightNavigationBarItem()
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.addSubview(drawerView)
        view.addSubview(borderView)
        view.addSubview(collectionView)
        
        let safeLayout: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            drawerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drawerView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: drawerViewTopPadding),
            
            borderView.topAnchor.constraint(equalTo: drawerView.bottomAnchor, constant: borderViewTopPadding),
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            borderView.heightAnchor.constraint(equalToConstant: 0.5),
            
            collectionView.topAnchor.constraint(equalTo: borderView.bottomAnchor),
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
        let editButton: UIButton = UIButton()
        editButton.setTitle("확인", for: .normal)
        editButton.titleLabel?.font = UIFont.Pretendard.body1
        editButton.setTitleColor(SwiftGenColors.black.color, for: .normal)
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
}

extension DrawerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // test data
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawerCollectionCell.reuseIdentifier, for: indexPath) as? DrawerCollectionCell else {
            return UICollectionViewCell()
        }
        
        // test data 
        let bool: Bool = [true, false].randomElement()!
        cell.drawerView.hideQuestionImageView(bool)
        cell.drawerView.hideTitleLabel(!bool)
        cell.drawerView.hideSubLabel(true)
        cell.drawerView.setTitleLabel(fontType: UIFont.Pretendard.title2,
                                      color: SwiftGenColors.black.color,
                                      text: "문구세트")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // test
        coordinator?.showSelectingDrawerViewController()
    }
}
