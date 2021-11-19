//
//  OnboardingStartViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/14.
//
import RxSwift
import UIKit

/// 온보딩 시작하는 첫 화면
final class OnboardingStartViewController: UIViewController {
    var coordinator: OnboardingCoordinator?
    
    // MARK: - View
    // 상단 유동적인 높이를 지정하기 위한 빈 뷰
    let topEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleView: UIStackView = {
        let imageView: UIImageView = UIImageView(image: SwiftGenIcons.thingLog.image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = SwiftGenColors.primaryBlack.color
        imageView.contentMode = .scaleAspectFit
        
        let bottomLabel: UILabel = UILabel()
        bottomLabel.font = UIFont.Pretendard.body1
        bottomLabel.text = "물건 기록 어플"
        bottomLabel.textColor = SwiftGenColors.primaryBlack.color
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [imageView, bottomLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let logoView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: SwiftGenIcons.group.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var startButton: RoundCenterTextButton = {
        let button: RoundCenterTextButton = RoundCenterTextButton(cornerRadius: startButtonHeight / 2)
        button.setTitle("시작하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private let topPaddingForLogo: CGFloat = 33
    private let startButtonHeight: CGFloat = 52
    private let leadingPadding: CGFloat = 20
    private let startButtonPadding: CGFloat = 20
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode()
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        setupView()
        setupBaseNavigationBar()
        
        subscribeStartButton()
    }
    
    func setupView() {
        view.addSubviews(topEmptyView,
                         titleView,
                         logoView,
                         startButton)
        
        NSLayoutConstraint.activate([
            topEmptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topEmptyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14),
            topEmptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topEmptyView.widthAnchor.constraint(equalToConstant: 1),
            
            titleView.topAnchor.constraint(equalTo: topEmptyView.bottomAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: topPaddingForLogo),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.26),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startButtonPadding),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -startButtonPadding),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -startButtonPadding),
            startButton.heightAnchor.constraint(equalToConstant: startButtonHeight)
        ])
    }
    
    func subscribeStartButton() {
        startButton.rx.tap.bind { [weak self] in
            self?.coordinator?.showOnboardingList()
        }.disposed(by: disposeBag)
    }
}
