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
    deinit {
        print("OnboardingStartViewController dead ✅")
    }
    var coordinator: OnboardingCoordinator?
    
    // MARK: - View
    let titleView: UIStackView = {
        let leftLabel: UILabel = UILabel()
        leftLabel.font = UIFont.Pretendard.headline2
        leftLabel.text = "띵로그"
        leftLabel.textColor = SwiftGenColors.primaryBlack.color
        
        let rightLabel: UILabel = UILabel()
        rightLabel.font = UIFont.Pretendard.body2
        rightLabel.text = "Thing Log"
        rightLabel.textColor = SwiftGenColors.gray2.color
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [leftLabel, rightLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let slogan: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.headline2n2
        label.text = "모든\n물건을\n기록하다"
        label.numberOfLines = 3
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    private let topPaddingForTitle: CGFloat = 10
    private let topPaddingForSlogan: CGFloat = 36
    private let logoHeight: CGFloat = 120
    private let startButtonHeight: CGFloat = 52
    private let leadingPadding: CGFloat = 20
    private let startButtonPadding: CGFloat = 20
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        setupView()
        setupBaseNavigationBar()
        
        subscribeStartButton()
    }
    
    func setupView() {
        view.addSubview(titleView)
        view.addSubview(slogan)
        view.addSubview(logoView)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPaddingForTitle),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingPadding),
            slogan.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: topPaddingForSlogan),
            slogan.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingPadding),
            
            logoView.heightAnchor.constraint(equalToConstant: logoHeight),
            logoView.widthAnchor.constraint(equalToConstant: logoHeight),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startButtonPadding),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -startButtonPadding),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -startButtonPadding),
            startButton.heightAnchor.constraint(equalToConstant: startButtonHeight)
        ])
    }
    
    func subscribeStartButton() {
        startButton.rx.tap.bind { [weak self] in
            self?.coordinator?.showOnboardlingList()
        }.disposed(by: disposeBag)
    }
}
