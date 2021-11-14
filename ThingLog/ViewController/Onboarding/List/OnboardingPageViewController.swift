//
//  OnboardingPageViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/14.
//
import RxSwift
import UIKit

/// 온보딩화면을 관리하는 PageViewController다.
final class OnboardingPageViewController: UIPageViewController {
    let controllers: [UIViewController] = [OnboardingPage1ViewController(),
                                           OnboardingPage2ViewController()]
    
    var currentPageIndexSubject: PublishSubject = PublishSubject<Int>()
    var currentPageIndex: Int {
        guard let controller = viewControllers?.first,
              let idx = controllers.firstIndex(of: controller) else {
            return 0
        }
        return idx
    }
    var disposeBag: DisposeBag = DisposeBag() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        dataSource = self
        delegate = self
        setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil }
        let previousIndex: Int = index - 1
        if previousIndex < 0 {
            return nil
        } else {
            return controllers[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil }
        let afterIndex: Int = index + 1
        if afterIndex >= controllers.count {
            return nil
        } else {
            return controllers[afterIndex]
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        currentPageIndexSubject.onNext(currentPageIndex)
    }
}
