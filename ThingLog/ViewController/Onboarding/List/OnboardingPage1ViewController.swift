//
//  OnboardingPage1ViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/14.
//
import Lottie
import UIKit

/// 첫번째 온보딩 화면을 보여주는 ViewController다.
final class OnboardingPage1ViewController: UIViewController {
    // 상단 유동적인 높이를 지정하기 위한 빈 뷰
    let topEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var startAnimationView: AnimationView = {
        let view: AnimationView = self.traitCollection.userInterfaceStyle == .dark ? AnimationView(name: "onboarding1Dark") : AnimationView(name: "onboarding1")
        view.animationSpeed = 1.0
        view.loopMode = .loop
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.headline3
        label.text = "물건 기록"
        label.textColor = SwiftGenColors.primaryBlack.color
        return label
    }()
    
    let contentsLael: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.body1
        label.text = "\" 샀다, 사고 싶다, 선물 받았다 \"\n3가지 글쓰기를 통해 모든 물건을 기록하세요!"
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
    private let topPaddingForTextStackView: CGFloat = 63
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.startAnimationView.play()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        startAnimationView.stop()
    }
    
    // 다크모드 감지
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        startAnimationView.animation = Animation.named(self.traitCollection.userInterfaceStyle == .dark ? "onboarding1Dark" : "onboarding1")
        DispatchQueue.main.async {
            self.startAnimationView.play()
        }
    }
    
    func setupView() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        view.addSubviews(topEmptyView,
                         startAnimationView,
                         textStackView)
        NSLayoutConstraint.activate([
            topEmptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topEmptyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.17),
            topEmptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topEmptyView.widthAnchor.constraint(equalToConstant: 1),
            
            startAnimationView.topAnchor.constraint(equalTo: topEmptyView.bottomAnchor),
            startAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            startAnimationView.heightAnchor.constraint(equalTo: startAnimationView.widthAnchor, multiplier: 0.42),
            
            textStackView.topAnchor.constraint(equalTo: startAnimationView.bottomAnchor,
                                               constant: topPaddingForTextStackView),
            textStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

