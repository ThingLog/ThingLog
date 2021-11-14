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
    let startAnimationView: AnimationView = {
        let view: AnimationView = AnimationView(name: "onboarding2")
        view.animationSpeed = 1.1
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
        label.text = "나의 모든 기록을 모아보기에서 한눈에 확인하고,\n나에 대해 알아가 보세요!"
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
    private let bottomPaddingForUnderlineView: CGFloat = 110
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
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        view.addSubview(underlineView)
        view.addSubview(textStackView)
        view.addSubview(leadingEmptyView)
        view.addSubview(trailingEmptyView)
        
        NSLayoutConstraint.activate([
            startAnimationView.widthAnchor.constraint(equalTo: underlineView.widthAnchor, multiplier: 0.75),
            startAnimationView.heightAnchor.constraint(equalTo: startAnimationView.widthAnchor),
            startAnimationView.bottomAnchor.constraint(equalTo: underlineView.topAnchor,
                                                       constant: 0),
            startAnimationView.centerXAnchor.constraint(equalTo: underlineView.centerXAnchor),
            
            leadingEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leadingEmptyView.widthAnchor.constraint(equalTo: trailingEmptyView.widthAnchor),
            
            leftLabel.leadingAnchor.constraint(equalTo: leadingEmptyView.trailingAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: trailingEmptyView.leadingAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: underlineView.topAnchor,
                                              constant: -4),
            rightLabel.bottomAnchor.constraint(equalTo: leftLabel.bottomAnchor),
            
            underlineView.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor,
                                                   constant: 2),
            underlineView.trailingAnchor.constraint(equalTo: rightLabel.leadingAnchor,
                                                    constant: -2),
            underlineView.heightAnchor.constraint(equalToConstant: 4),
            underlineView.bottomAnchor.constraint(equalTo: textStackView.topAnchor,
                                                  constant: -bottomPaddingForUnderlineView),
            
            textStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                  constant: -bottomPaddingForTextStackView),
            textStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
