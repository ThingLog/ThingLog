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
    let startAnimationView: AnimationView = {
        let view: AnimationView = AnimationView(name: "onboarding1")
        view.animationSpeed = 1.1
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
        label.text = "샀다, 사고 싶다, 선물 받았다\n3가지 글쓰기를 통해 물건을 기록하세요!"
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
    private let bottomPaddingForAnimation: CGFloat = 63
    private let bottomPaddingForTextStackView: CGFloat = 80
    
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
    
    func setupView() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        view.addSubview(startAnimationView)
        view.addSubview(textStackView)
        
        NSLayoutConstraint.activate([
            startAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            startAnimationView.heightAnchor.constraint(equalTo: startAnimationView.widthAnchor, multiplier: 0.5),
            startAnimationView.bottomAnchor.constraint(equalTo: textStackView.topAnchor,
                                                       constant: -bottomPaddingForAnimation),
            
            textStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                  constant: -bottomPaddingForTextStackView),
            textStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
