//
//  OnboardingListViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/14.
//
import RxSwift
import UIKit

/// 온보딩 리스트를 보여주는 화면이다. 내부적으로 `OnboardingPageViewController`를 `containerView`로 가지고 있다.
final class OnboardingListViewController: UIViewController {
    var coordinator: OnboardingCoordinator?
    
    // MARK: - View
    let pageViewController: OnboardingPageViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    let contentsContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pageControl: UIStackView = {
        let button: UIImageView = UIImageView(image: SwiftGenIcons.loginStar.image.withRenderingMode(.alwaysTemplate))
        let button2: UIImageView = UIImageView(image: SwiftGenIcons.loginStar.image.withRenderingMode(.alwaysTemplate))
        
        button.tintColor = SwiftGenColors.primaryBlack.color
        button2.tintColor = SwiftGenColors.gray4.color
        let stackView: UIStackView = UIStackView(arrangedSubviews: [button, button2])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let doneButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.title1
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private let bottomPaddingDoneButton: CGFloat = 27
    private let trailingPaddingDoneButton: CGFloat = 20
    private let bottomPaddingForPageControl: CGFloat = 27
    let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        setupView()
        setupNavigationBar()
        setupContainerView()
        
        subscribePageViewController()
        subscribeDoneButton()
    }
    
    func setupView() {
        view.addSubviews(contentsContainerView,
                         pageControl,
                         doneButton)
        
        NSLayoutConstraint.activate([
            contentsContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentsContainerView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
            contentsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: doneButton.topAnchor,
                                                constant: -bottomPaddingForPageControl),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -trailingPaddingDoneButton),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -bottomPaddingDoneButton)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    /// OnboardingPageViewController를 containerView에 추가하도록 한다.
    func setupContainerView() {
        let pageView: UIView = pageViewController.view
        addChild(pageViewController)
        contentsContainerView.addSubview(pageView)
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            pageView.topAnchor.constraint(equalTo: contentsContainerView.topAnchor),
            pageView.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor)
        ])
    }
}

extension OnboardingListViewController {
    /// PageViewController의 스와이프를 subscribe하여, 그에 따라 PageControl 및 doneButton을 변경하도록 한다.
    func subscribePageViewController() {
        pageViewController.currentPageIndexSubject
            .subscribe(onNext: { [weak self] index in
                self?.changePageControl(by: index)
                self?.changeDoneButton(by: index)
        })
        .disposed(by: pageViewController.disposeBag)
    }
    
    /// 바로 로그인화면으로 넘어가도록 한다.
    func subscribeDoneButton() {
        doneButton.rx.tap.bind { [weak self] in
            self?.coordinator?.showLoginViewController()
        }.disposed(by: disposeBag)
    }
    
    /// PageControl의 틴트를 풀고, 강조한다.
    private func changePageControl(by index: Int) {
        pageControl.arrangedSubviews.forEach {
            guard let imageView: UIImageView = $0 as? UIImageView else { return }
            imageView.tintColor = SwiftGenColors.gray4.color
        }
        guard let imageView: UIImageView = pageControl.arrangedSubviews[index] as? UIImageView else { return }
        imageView.tintColor = SwiftGenColors.primaryBlack.color
    }
    
    private func changeDoneButton(by index: Int) {
        let maxListCount: Int = pageViewController.controllers.count - 1
        if index == maxListCount {
            doneButton.setTitle("확인", for: .normal)
        } else {
            doneButton.setTitle("건너뛰기", for: .normal)
        }
    }
}
