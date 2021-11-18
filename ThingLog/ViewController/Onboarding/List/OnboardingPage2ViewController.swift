//
//  OnboardingPage2ViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/14.
//
import Lottie
import UIKit

/// 두번째 온보딩 화면을 보여주는 ViewController다.
final class OnboardingPage2ViewController: UIViewController {
    // 상단 유동적인 높이를 지정하기 위한 빈 뷰
    let topEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var startAnimationView: AnimationView = {
        let view: AnimationView = self.traitCollection.userInterfaceStyle == .dark ? AnimationView(name: AnimationJson.onboarding2Dark.name) : AnimationView(name: AnimationJson.onboarding2.name)
        view.animationSpeed = 1.0
        view.loopMode = .loop
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.headline2
        label.text = "나의"
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.headline2
        label.text = "을 발견하다"
        label.textColor = SwiftGenColors.primaryBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let underlineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.primaryBlack.color
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leadingEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let trailingEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.headline3
        label.text = "모아 보기"
        label.textColor = SwiftGenColors.primaryBlack.color
        return label
    }()
    
    let contentsLael: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body1
        label.text = "기록을 통해 나의 가치를 발견할 수 있습니다.\n나에 대해 알아가 보세요!"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = SwiftGenColors.gray2.color
        return label
    }()
    
    lazy var textStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel,
                                                                    contentsLael])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    private let topPaddingForTextStackView: CGFloat = 120
    var willEnterForegroundObserver: NSObjectProtocol?
    
    // MARK: - Life Cycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        subscribeWillEnterForegroundNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.startAnimationView.play()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(willEnterForegroundObserver)
        startAnimationView.stop()
    }
    
    // 다크모드 감지
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        
        startAnimationView.animation = Animation.named(self.traitCollection.userInterfaceStyle == .dark ? AnimationJson.onboarding2Dark.name : AnimationJson.onboarding2.name)
        DispatchQueue.main.async {
            self.startAnimationView.play()
        }
    }
    
    func setupView() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        view.addSubviews(startAnimationView,
                         leftLabel,
                         rightLabel,
                         underlineView,
                         textStackView,
                         leadingEmptyView,
                         trailingEmptyView,
                         topEmptyView)
        
        NSLayoutConstraint.activate([
            topEmptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topEmptyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.17),
            topEmptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topEmptyView.widthAnchor.constraint(equalToConstant: 1),
            
            startAnimationView.topAnchor.constraint(equalTo: topEmptyView.bottomAnchor),
            startAnimationView.widthAnchor.constraint(equalTo: underlineView.widthAnchor, multiplier: 0.75),
            startAnimationView.heightAnchor.constraint(equalTo: startAnimationView.widthAnchor, multiplier: 0.83),
            startAnimationView.centerXAnchor.constraint(equalTo: underlineView.centerXAnchor),
            
            underlineView.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor,
                                                   constant: 2),
            underlineView.trailingAnchor.constraint(equalTo: rightLabel.leadingAnchor,
                                                    constant: -2),
            underlineView.heightAnchor.constraint(equalToConstant: 4),
            underlineView.topAnchor.constraint(equalTo: startAnimationView.bottomAnchor),
            
            leadingEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leadingEmptyView.widthAnchor.constraint(equalTo: trailingEmptyView.widthAnchor),
            
            leftLabel.leadingAnchor.constraint(equalTo: leadingEmptyView.trailingAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: trailingEmptyView.leadingAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: underlineView.topAnchor,
                                              constant: -4),
            rightLabel.bottomAnchor.constraint(equalTo: leftLabel.bottomAnchor),
            
            textStackView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: topPaddingForTextStackView),
            textStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func subscribeWillEnterForegroundNotification() {
        willEnterForegroundObserver =
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                   object: nil,
                                                   queue: .main) {
                [weak self] notification in
                DispatchQueue.main.async {
                    self?.startAnimationView.play()
                }
            }
    }
}
