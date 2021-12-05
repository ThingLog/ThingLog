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
        collection.alwaysBounceVertical = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var loginButton: RoundCenterTextButton = {
        let button: RoundCenterTextButton = RoundCenterTextButton(cornerRadius: loginButtonHeight / 2)
        button.setTitle("로그인하기", for: .normal)
        button.setTitleColor(SwiftGenColors.white.color.withAlphaComponent(0.5), for: .disabled)
        button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    // 로그인 화면인 경우와 아닌 경우에 뷰를 다르게 보여주기 위해 필요한 프로퍼티다.
    var isLogin: Bool
    // TextFeild가 강조된 경우에만 스크롤이 더 가능하기 위해 필요한 프로퍼티다.
    var isEditMode: Bool = false
    
    private let loginButtonHeight: CGFloat = 56
    
    let recommendList: [String] = ["나를 찾는 여정", "미니멀리즘", "건강한 소비 습관", "취향모음", "물건의 역사", "물건을 통해 나를 본다"]
    var disposeBag: DisposeBag = DisposeBag()
    
    lazy var userInformation: UserInformationable = UserInformation(userAliasName: "",
                                                                    userOneLineIntroduction: "",
                                                                    isAumatedDarkMode: traitCollection.userInterfaceStyle == .dark) {
        didSet {
            if userInformation.userAliasName.isEmpty && userInformation.userOneLineIntroduction.isEmpty {
                loginButton.backgroundColor = SwiftGenColors.primaryBlack.color.withAlphaComponent(0.5)
                loginButton.isEnabled = false
            } else {
                loginButton.backgroundColor = SwiftGenColors.primaryBlack.color
                loginButton.isEnabled = true
            }
        }
    }
    
    private let userInformationViewModel: UserInformationViewModelable = UserInformationUserDefaultsViewModel()
    
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
        setupBackgroundColor()
        setupView()
        setupNavigationBar()
        fetchUserInformation()
        
        subscribeLoginButton()
    }
    
    func setupBackgroundColor() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        collectionView.backgroundColor = SwiftGenColors.primaryBackground.color
    }
    
    // MARK: - Setup
    private func setupView() {
        view.addSubview(collectionView)
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: isLogin ? loginButtonHeight : 0)
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
        navigationController?.isNavigationBarHidden = true
    }
    
    /// 프로필 편집 화면인 경우에 나타날 Navigationbar를 세팅한다.
    private func setupNavigationBarWithEditMode() {
        navigationController?.isNavigationBarHidden = false
        let titleView: UIView = LogoView("프로필 편집", font: UIFont.Pretendard.headline4)
        navigationItem.titleView = titleView
        
        let clearButton: UIButton = UIButton()
        clearButton.setImage(SwiftGenIcons.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = SwiftGenColors.primaryBlack.color
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
        editButton.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        editButton.rx.tap
            .bind { [weak self] in
                guard let coordinator = self?.coordinator as? HomeCoordinator else { return }
                self?.updateUserInformation()
                coordinator.back()
            }
            .disposed(by: disposeBag)
        let editBarButton: UIBarButtonItem = UIBarButtonItem(customView: editButton)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 17
        navigationItem.rightBarButtonItems = [fixedSpace, editBarButton]
    }
    
    func fetchUserInformation() {
        userInformationViewModel.fetchUserInformation { userInformation in
            if let userInformation: UserInformationable = userInformation {
                self.userInformation = userInformation
                self.collectionView.reloadData()
            }
        }
    }
}

extension LoginViewController {
    func subscribeLoginButton() {
        loginButton.rx.tap.bind { [weak self] in
            self?.updateUserInformation()
            self?.enterTabBarViewController()
        }.disposed(by: disposeBag)
    }
    
    /// 탭바 화면으로 넘어가는 메소드다
    private func enterTabBarViewController() {
        if let rootCordinator: LoginCoordinator = coordinator as? LoginCoordinator {
            rootCordinator.showTabBarController()
            
            // 테스트를 위해서, 설정화면에서 호출한 경우,
        } else if let rootCordinator: SettingCoordinator = coordinator as? SettingCoordinator {
            rootCordinator.back()
        }
    }
    
    /// 로그인정보 저장하기
    func updateUserInformation() {
        let newUserInformation: UserInformationable = UserInformation(userAliasName: userInformation.userAliasName.isEmpty ? "닉네임" : userInformation.userAliasName,
                                                                      userOneLineIntroduction: userInformation.userOneLineIntroduction,
                                                                      isAumatedDarkMode: userInformation.isAumatedDarkMode)
        userInformationViewModel.updateUserInformation(newUserInformation)
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
            cell.textField.text = userInformation.userAliasName
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
            cell.textField.text = userInformation.userOneLineIntroduction
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
            // 다음에 하기 버튼 클릭시 바로 탭바 화면으로 넘어간다.
            login.laterButton.rx.tap.bind { [weak self] in
                self?.updateUserInformation()
                self?.enterTabBarViewController()
            }.disposed(by: login.disposeBag)
            return  login
            
        case LeftLabelRightButtonHeaderView.reuseIdentifier:
            guard let recommend = collectionView.dequeueReusableSupplementaryView(ofKind: LeftLabelRightButtonHeaderView.reuseIdentifier, withReuseIdentifier: LeftLabelRightButtonHeaderView.reuseIdentifier, for: indexPath) as? LeftLabelRightButtonHeaderView else {
                return UICollectionReusableView()
            }
            recommend.leftIconView.isHidden = false 
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
            tint(cell, true)
            
            // 한 줄 소개 입력창에 반영
            guard let textFieldCell = collectionView.cellForItem(at: IndexPath(item: 0, section: LoginCollectionSection.userOneLine.section)) as? TextFieldWithLabelWithButtonCollectionCell else { return
            }
            textFieldCell.textField.text = recommendList[indexPath.item]
            userInformation.userOneLineIntroduction = recommendList[indexPath.item]
        }
    }
}

extension LoginViewController {
    /// 셀의 버튼의 섹을 잠시 강조하는 메서드다
    private func tint(_ cell: ButtonRoundCollectionCell, _ bool: Bool) {
        UIView.animate(withDuration: 0.3) {
            cell.changeColor(borderColor: SwiftGenColors.primaryBlack.color,
                             backgroundColor: bool ? SwiftGenColors.primaryBlack.color : SwiftGenColors.primaryBackground.color ,
                             textColor: bool ? SwiftGenColors.white.color : SwiftGenColors.primaryBlack.color )
        } completion: { _  in
            UIView.animate(withDuration: 0.3) {
                cell.changeColor(borderColor: SwiftGenColors.gray3.color,
                                 backgroundColor: !bool ? SwiftGenColors.primaryBlack.color : SwiftGenColors.primaryBackground.color ,
                                 textColor: !bool ? SwiftGenColors.white.color : SwiftGenColors.primaryBlack.color )
            }
        }
    }
}
