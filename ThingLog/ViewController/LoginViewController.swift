//
//  LoginViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/19.
//

import RxSwift
import UIKit

/// 로그인화면 또는, 프로필 편집화면에 사용되는 뷰컨트롤러다.
final class LoginViewController: UIViewController {
    var coordinator: Coordinator?
    
    lazy var collectionView: UICollectionView = {
        let collection: UICollectionView =
            UICollectionView(frame: .zero, collectionViewLayout: LoginCollectionSection.resultsCollectionViewLayout(isLogin))
        // Cell
        collection.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier)
        collection.register(TextFieldWithLabelWithButtonCollectionCell.self,
                            forCellWithReuseIdentifier: TextFieldWithLabelWithButtonCollectionCell.reuseIdentifier)
        collection.register(ButtonRoundCollectionCell.self,
                            forCellWithReuseIdentifier: ButtonRoundCollectionCell.reuseIdentifier)
        
        // Header, Footer
        collection.register(LoginTopHeaderView.self,
                            forSupplementaryViewOfKind: LoginTopHeaderView.reuseIdentifier,
                            withReuseIdentifier: LoginTopHeaderView.reuseIdentifier)
        collection.register(UICollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionReusableView.reuseIdentifier,
                            withReuseIdentifier: UICollectionReusableView.reuseIdentifier)
        collection.register(LeftLabelRightButtonHeaderView.self,
                            forSupplementaryViewOfKind: LeftLabelRightButtonHeaderView.reuseIdentifier,
                            withReuseIdentifier: LeftLabelRightButtonHeaderView.reuseIdentifier)
        collection.backgroundColor = SwiftGenColors.white.color
        collection.alwaysBounceVertical = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Properties
    // 로그인 화면인 경우와 아닌 경우에 뷰를 다르게 보여주기 위해 필요한 프로퍼티다.
    var isLogin: Bool
    // TextFeild가 강조된 경우에만 스크롤이 더 가능하기 위해 필요한 프로퍼티다.
    var isEditMode: Bool = false
    // ⚠️ test1()메서드를 사용하지 않는다면 필요없다.
    var selectedIndexRecommend: IndexPath?
    
    let recommendList: [String] = ["나를 찾는 여정", "미니멀리즘", "건강한 소비 습관", "취향모음", "물건의 역사", "물건을 통해 나를 본다"]
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    /// 로그인이 포함된 화면인지 아닌지를 주입하는 이니셜라이저다.
    init(isLogin: Bool) {
        self.isLogin = isLogin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.isLogin = true
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupCollectionView()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    // TODO: ⚠️ 지원님이 글쓰기 화면에서 구현하실 하단의 검은색버튼 뷰를 재활용하여 추가할 예정이다.
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layoutIfNeeded()
    }
    
    private func setupNavigationBar() {
        setupBaseNavigationBar()
        if isLogin {
            setupNavigationBarWithLogin()
        } else {
            setupNavigationBarWithEditMode()
        }
    }
    
    /// 로그인 화면인 경우에 나타날 Navigationbar를 세팅한다.
    private func setupNavigationBarWithLogin() {
        let logoView: UIButton = UIButton()
        logoView.setTitle("Logo", for: .normal)
        logoView.titleLabel?.font = UIFont.Pretendard.headline3
        logoView.setTitleColor(SwiftGenColors.black.color, for: .normal)
        logoView.rx.tap
            .bind { [weak self] in
                guard let coordinator = self?.coordinator as? SettingCoordinator else { return }
                coordinator.back()
            }
            .disposed(by: disposeBag)
        let logoBarButton: UIBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.leftBarButtonItem = logoBarButton
    }
    
    /// 프로필 편집 화면인 경우에 나타날 Navigationbar를 세팅한다.
    private func setupNavigationBarWithEditMode() {
        let titleView: UIView = LogoView("프로필 편집", font: UIFont.Pretendard.headline4)
        navigationItem.titleView = titleView
        
        let clearButton: UIButton = UIButton()
        clearButton.setImage(SwiftGenAssets.closeBig.image, for: .normal)
        clearButton.tintColor = SwiftGenColors.black.color
        clearButton.rx.tap
            .bind { [weak self] in
                guard let coordinator = self?.coordinator as? HomeCoordinator else { return }
                coordinator.back()
            }
            .disposed(by: disposeBag)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: clearButton)
        navigationItem.leftBarButtonItem = backBarButton
        
        let editButton: UIButton = UIButton()
        editButton.setTitle("확인", for: .normal)
        editButton.titleLabel?.font = UIFont.Pretendard.body1
        editButton.setTitleColor(SwiftGenColors.black.color, for: .normal)
        editButton.rx.tap
            .bind { [weak self] in
                guard let coordinator = self?.coordinator as? HomeCoordinator else { return }
                coordinator.back()
            }
            .disposed(by: disposeBag)
        let editBarButton: UIBarButtonItem = UIBarButtonItem(customView: editButton)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 24
        navigationItem.rightBarButtonItems = [fixedSpace, editBarButton]
    }
}

// MARK: - Collection DataSource
extension LoginViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        isEditMode ? LoginCollectionSection.allCases.count : LoginCollectionSection.allCases.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == LoginCollectionSection.recommand.section ? recommendList.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section: LoginCollectionSection = LoginCollectionSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case LoginCollectionSection.topPadding,
             LoginCollectionSection.bottomPadding:
            return dequeueEmptyView(collectionView, cellForItemAt: indexPath)
        case LoginCollectionSection.userName:
            guard let cell = dequeueTextFieldCell(collectionView,
                                                  cellForItemAt: indexPath,
                                                  maximumTextCount: 10,
                                                  placeHolder: "닉네임을 입력하세요") as? TextFieldWithLabelWithButtonCollectionCell else {
                return UICollectionViewCell()
            }
            subscribeTextFieldCell(cell, collectionView, cellForItemAt: indexPath)
            subscribeEnterKeyOfUserNameTextField(cell, collectionView, cellForItemAt: indexPath)
            return cell
        case LoginCollectionSection.userOneLine:
            guard let cell = dequeueTextFieldCell(collectionView,
                                                  cellForItemAt: indexPath,
                                                  maximumTextCount: 20,
                                                  placeHolder: "한 줄 소개") as? TextFieldWithLabelWithButtonCollectionCell else {
                return UICollectionViewCell()
            }
            subscribeTextFieldCell(cell, collectionView, cellForItemAt: indexPath)
            subscribeEnterKeyOfUserOneLineTextField(cell, collectionView, cellForItemAt: indexPath)
            return cell
        case LoginCollectionSection.recommand:
            return dequeueRecommandView(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case LoginTopHeaderView.reuseIdentifier:
            guard let login = collectionView.dequeueReusableSupplementaryView(ofKind: LoginTopHeaderView.reuseIdentifier, withReuseIdentifier: LoginTopHeaderView.reuseIdentifier, for: indexPath) as? LoginTopHeaderView else {
                return UICollectionReusableView()
            }
            return  login
        case LeftLabelRightButtonHeaderView.reuseIdentifier:
            guard let recommend = collectionView.dequeueReusableSupplementaryView(ofKind: LeftLabelRightButtonHeaderView.reuseIdentifier, withReuseIdentifier: LeftLabelRightButtonHeaderView.reuseIdentifier, for: indexPath) as? LeftLabelRightButtonHeaderView else {
                return UICollectionReusableView()
            }
            recommend.rightButton.isHidden = true
            recommend.updateTitle(title: "추천 소개 글", subTitle: nil)
            return recommend
        default:
            let empty: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionReusableView.reuseIdentifier, withReuseIdentifier: UICollectionReusableView.reuseIdentifier, for: indexPath)
            return empty
        }
    }
}

// MARK: - Collection Delegate
extension LoginViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == LoginCollectionSection.recommand.section {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ButtonRoundCollectionCell else { return
            }
            //            test1_Tint(cell: cell, indexPath: indexPath)
            test2_Tint(cell: cell, indexPath: indexPath)
            
            // 한 줄 소개 입력창에 반영
            guard let textFieldCell = collectionView.cellForItem(at: IndexPath(item: 0, section: LoginCollectionSection.userOneLine.section)) as? TextFieldWithLabelWithButtonCollectionCell else { return
            }
            textFieldCell.textField.text = recommendList[indexPath.item]
            
            // ⚠️test1_Tint() 메서드와 같이 작용해야하는 코드
            //            textFieldCell.textField.text = selectedIndexRecommend == nil ? "" : recommendList[indexPath.item]
        }
    }
}

extension LoginViewController {
    /// 셀의 버튼의 섹을 강조하거나 강조하지 않도록 하는 메서드다.
    private func tint(_ cell: ButtonRoundCollectionCell, _ bool: Bool) {
        UIView.animate(withDuration: 0.2) {
            cell.changeColor(borderColor: SwiftGenColors.gray3.color,
                             backgroundColor: bool ? SwiftGenColors.gray5.color : SwiftGenColors.white.color ,
                             textColor: SwiftGenColors.black.color )
        } completion: { _  in
            UIView.animate(withDuration: 0.2) {
                cell.changeColor(borderColor: SwiftGenColors.gray3.color,
                                 backgroundColor: !bool ? SwiftGenColors.gray5.color : SwiftGenColors.white.color ,
                                 textColor: SwiftGenColors.black.color )
            }
        }
    }
    
    /// 기존 와이어프레임이 제안한 코드
    private func test1_Tint(cell: ButtonRoundCollectionCell, indexPath: IndexPath) {
        if let beforeIndex: IndexPath = selectedIndexRecommend {
            if beforeIndex == indexPath {
                tint(cell, false)
                selectedIndexRecommend = nil
            } else {
                guard let beforeCell = collectionView.cellForItem(at: beforeIndex) as? ButtonRoundCollectionCell else { return
                }
                tint(beforeCell, false)
                tint(cell, true)
                selectedIndexRecommend = indexPath
            }
        } else {
            tint(cell, true)
            selectedIndexRecommend = indexPath
        }
    }
    
    /// 내가 제안하고 싶은 코드
    /// 왜냐하면, test1처럼 하게 되면, 관련된 인터렉션이 굉장히 많다. 그에 따라 코드가 복잡해지는 단점이 있다. 그리고 선택했을 때, 해당 텍스트를 수정하는 경우에는 또 강조를 풀어야하는지, 만약 그렇다면, 텍스트를 수정하다가 다시 원래대로 선택했던 문장으로 바꾸게 된다면, 또 강조를 해야하는지, 등의 논리적인 흐름에 문제가 있다라고 생각한다. 그래서 항상 강조되있기 보다는 잠시 반짝거리도록 바꾸는게 훨씬 코드가 깔끔하고, 추가적으로 발생할 수 있는 상황에 대해서 대비할 코드가 거의 없다라는 장점이 더 크다라고 생각한다.
    private func test2_Tint(cell: ButtonRoundCollectionCell, indexPath: IndexPath) {
        tint(cell, true)
    }
}
