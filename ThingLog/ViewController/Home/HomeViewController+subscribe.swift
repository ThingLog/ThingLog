//
//  HomeViewController+subscribe.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/16.
//

import UIKit

// MARK: - Subscribe Rx
extension HomeViewController {
    /// PageViewController의 page가 전환될 시 subscribe하여 뷰 업데이트를 진행하는 메소드다.
    func subscribePageVeiwControllerTransition() {
        pageViewController.currentPageIndexSubject
            .subscribe(onNext: { [weak self] index in
                self?.contentsTabView.updateIndicatorBar(by: index)
                self?.contentsTabView.updateButtonTintColor(by: index)
                self?.changeContentsContainerHeight(viewController: self?.pageViewController.controllers[index] as? BaseContentsCollectionViewController)
            })
            .disposed(by: pageViewController.disposeBag)
    }
    
    /// ContentsTabButton을 subscribe하여 각 버튼을 누를 시 PageViewController의 page를 전환하는 메소드다.
    func subscribeContentsTabButton() {
        for index in 0..<contentsTabView.buttonStackView.arrangedSubviews.count {
            guard let button: UIButton = contentsTabView.buttonStackView.arrangedSubviews[index] as? UIButton else { return }
            button.rx.tap.bind { [weak self] in
                self?.contentsTabView.updateButtonTintColor(by: index)
                var direction: UIPageViewController.NavigationDirection = .forward
                let pageIndex: Int? = self?.pageViewController.currentPageIndex
                if index == 0 {
                    direction = .reverse
                } else if index == 1 {
                    if pageIndex == 2 {
                        direction = .reverse
                    }
                }
                guard let nextViewController: UIViewController = self?.pageViewController.controllers[index] else { return }
                self?.pageViewController.setViewControllers([nextViewController], direction: direction, animated: true, completion: { _ in
                    self?.changeContentsContainerHeight(viewController: nextViewController as? BaseContentsCollectionViewController)
                })
                self?.contentsTabView.updateIndicatorBar(by: index)
            }
            .disposed(by: contentsTabView.disposeBag)
        }
    }
    
    /// PageViewController의 scroll offset을 subscribe 하여 ContainerView 높이를 조절하는 메소드다.
    func subscribePageViewControllerScrollOffset() {
        pageViewController.currentScrollContentsOffsetYSubject
            .subscribe(onNext: { [weak self] dist in
                // 최상단으로 스크롤했을 때
                if dist == -200 {
                    self?.profileView.hideBadgeView(false)
                }
                UIView.animate(withDuration: 0.1) {
                    guard let currentConstant = self?.heightAnchorProfileView?.constant else { return }
                    var dist: CGFloat = dist
                    if dist >= 0 {
                        dist = max(currentConstant - dist, 0)
                        self?.profileView.hideBadgeView(true)
                    } else {
                        dist = min(currentConstant - dist, self?.profileViewHeight ?? 44 + 24 + 16)
                        if dist >= 44 {
                            self?.profileView.hideBadgeView(false)
                        }
                    }
                    self?.heightAnchorProfileView?.constant = dist
                }
            })
            .disposed(by: pageViewController.disposeBag)
    }
    
    /// 유저정보가 변경되는 경우의 notificaiton을 subscribe하여 유저정보를 변경하도록 한다.
    func subscribeUserInformationChange() {
        userInformationViewModel.subscribeUserInformationChange { [weak self] userInformation in
            self?.updateProfileView(by: userInformation)
        }
    }
    
    func subscribeProfileEditButton() {
        profileView.userAliasNameButton.rx.tap.bind { [weak self] in
            self?.coordinator?.showLoginViewController()
        }
        .disposed(by: disposeBag)
    }
    
    /// 진열장 화면으로 이동하는 메서드다.
    func subscribeDrawerImageView() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        profileView.badgeView.addGestureRecognizer(tapGesture)
        profileView.badgeView.isUserInteractionEnabled = true
        tapGesture.rx.event.bind { [weak self] _ in
            self?.coordinator?.showDrawerViewController()
        }.disposed(by: disposeBag)
    }
    
    func subscribeWillEnterForegroundNotification() {
        willEnterForegroundObserver =
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                   object: nil,
                                                   queue: .main) {
                [weak self] notification in
                self?.fetchRepresentativeDrawer()
            }
    }
}

extension HomeViewController {
    /// 콘텐츠 개수가 많은 상황에서 아래로 스크롤한 상태에서 콘텐츠 개수가 적은 페이지로 전환할 시 containerView의 높이를 줄여주는 메소드다.
    /// - Parameter viewController: 콘텐츠가 적은 페이지의 controller를 넣는다.
    func changeContentsContainerHeight(viewController: BaseContentsCollectionViewController?) {
        guard let baseController = viewController else { return }
        DispatchQueue.main.async {
            if baseController.originScrollContentsHeight <= baseController.collectionView.frame.height ||
                baseController.collectionView.contentOffset.y == 0 {
                UIView.animate(withDuration: 0.1) {
                    self.contentsContainerView.layoutIfNeeded()
                } completion: { _ in
                    UIView.animate(withDuration: 0.3) {
                        self.heightAnchorProfileView?.constant = self.profileViewHeight
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        self.profileView.hideBadgeView(false)
                    }
                }
            }
        }
    }
    
    func updateProfileView(by userInformation: UserInformationable?) {
        profileView.userAliasNameButton.setTitle(userInformation?.userAliasName, for: .normal)
        profileView.userOneLineIntroductionLabel.text = userInformation?.userOneLineIntroduction
        profileView.userOneLineIntroductionLabel.isHidden = userInformation?.userOneLineIntroduction == nil
    }
}
